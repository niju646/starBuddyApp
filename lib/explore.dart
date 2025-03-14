import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {

FlutterTts flutterTts = FlutterTts();
  Database? database;

  String name = "Loading...";
  String type = "";
  String iauConstellation = "";
  double azimuth = 0.0;
  double altitude = 0.0;
  String descriptionEn = "Fetching...";
  String descriptionMl = "കാത്തിരിക്കുന്നു...";



  @override

void initState() {
    super.initState();
    initDatabase();
    fetchData();
  }

  Future<void> initDatabase() async {
    String path = join(await getDatabasesPath(), 'star_buddy.db');
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE IF NOT EXISTS celestial_objects (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE,
            type TEXT,
            iau_constellation TEXT,
            azimuth REAL,
            altitude REAL,
            description_en TEXT,
            description_ml TEXT
          )
        ''');
      },
    );
  }

  Future<void> fetchData() async {
    const String stellariumApiUrl =
        "http://localhost:8090/api/objects/info?format=json";
    
    try {
      var response = await http.get(Uri.parse(stellariumApiUrl));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String objectName = data["localized-name"] ?? data["name"] ?? "Unknown";
        String objectType = data["type"] ?? "Unknown";
        String iau = data["iauConstellation"] ?? "Not Available";
        double az = data["azimuth"] ?? 0.0;
        double alt = data["altitude"] ?? 0.0;

        String wikiDescription = await fetchWikipediaDescription(objectName);
        String translatedDescription = "Translation required"; // Add translation logic

        await saveToDatabase(
            objectName, objectType, iau, az, alt, wikiDescription, translatedDescription);

        setState(() {
          name = objectName;
          type = objectType;
          iauConstellation = iau;
          azimuth = az;
          altitude = alt;
          descriptionEn = wikiDescription;
          descriptionMl = translatedDescription;
        });
      }
    } catch (e) {
      print("Error fetching Stellarium data: $e");
    }
  }

  Future<String> fetchWikipediaDescription(String title) async {
    const String wikiApiUrl =
        "https://en.wikipedia.org/w/api.php?action=query&redirects&prop=extracts&exintro&exsentences=5&format=json&origin=*&titles=";
    try {
      var response = await http.get(Uri.parse(wikiApiUrl + title));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var pages = jsonData["query"]["pages"];
        if (pages.isNotEmpty) {
          return pages.values.first["extract"].replaceAll(RegExp(r"<.*?>"), "");
        }
      }
    } catch (e) {
      print("Error fetching Wikipedia data: $e");
    }
    return "No additional description available.";
  }

   Future<void> saveToDatabase(String name, String type, String iau,
      double az, double alt, String descEn, String descMl) async {
    await database?.insert(
      "celestial_objects",
      {
        "name": name,
        "type": type,
        "iau_constellation": iau,
        "azimuth": az,
        "altitude": alt,
        "description_en": descEn,
        "description_ml": descMl,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> speak(String text, String lang) async {
    await flutterTts.setLanguage(lang);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {

    Widget space1 = const SizedBox(height: 39,);
    Widget space2 = const SizedBox(height: 10,);


    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/image.jpg",fit: BoxFit.cover,),
            
            ),
          
          Positioned(
            top: 80,
            left: 20,
            right: 20,
            bottom: 30,
            child: Center(
              child: Container(width: 500,height: 700,
              //padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 119, 112, 112),
                  borderRadius: BorderRadius.circular(20),
                   boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      color: Colors.black.withOpacity(0.7), 

                    )
                  ],
                  
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Name: $name",
                        style: TextStyle(fontSize: 20, color: Colors.white,
                        shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.7), 
                        blurRadius: 5, 
                        offset: Offset(3, 3),
                      ),
                    ],
                        )),
                        space1,
                    Text("Type: $type",
                        style: TextStyle(fontSize: 18, color: Colors.white,
                        shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.7), 
                        blurRadius: 5, 
                        offset: Offset(3, 3),
                      ),
                    ],
                        )),
                        space1,
                    Text("IAU Constellation: $iauConstellation",
                        style: TextStyle(fontSize: 18, color: Colors.white,shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.7), 
                        blurRadius: 5, 
                        offset: Offset(3, 3),
                      ),
                    ],)),
                        space2,
                    Text("Azimuth: ${azimuth.toStringAsFixed(2)}°",
                        style: TextStyle(fontSize: 18, color: Colors.white,shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.7), 
                        blurRadius: 5, 
                        offset: Offset(3, 3),
                      ),
                    ],)),
                        space2,
                    Text("Altitude: ${altitude.toStringAsFixed(2)}°",
                        style: TextStyle(fontSize: 18, color: Colors.white,shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.7), 
                        blurRadius: 5, 
                        offset: Offset(3, 3),
                      ),
                    ],)),
                        space2,
                    SizedBox(height: 20),
                    Text("Description (English):", style: TextStyle(fontSize: 18, color: Colors.white,shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.7), 
                        blurRadius: 5, 
                        offset: Offset(3, 3),
                      ),
                    ],)),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(descriptionEn,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                    space1,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[800]
                      ),
                        onPressed: () => speak(descriptionEn, "en"),
                        child: Text("🔊 Read in English",style: TextStyle(color: Colors.white),)),
                    SizedBox(height: 10),
                    Text("വിവരണം (Malayalam):",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(descriptionMl,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),

                    space1,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[800]
                      ),
                        onPressed: () => speak(descriptionMl, "ml"),
                        child: Text("🔊 മലയാളത്തിൽ വായിക്കുക",style: TextStyle(color:Colors.white),)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}