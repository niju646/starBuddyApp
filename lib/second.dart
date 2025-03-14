import 'package:flutter/material.dart';
import 'package:star_buddy/explore.dart';

class Second extends StatelessWidget {
  const Second({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[800],
        body: Stack(
          children: [
           Positioned.fill(
            child: Image.asset(
              "assets/image.jpg",
              fit: BoxFit.cover, 
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 300,
            
            child: Center(
              child: Container(
                child: Text(
                  "Star Buddy",style: TextStyle(
                    color: Colors.white,fontSize: 40,
                    fontFamily: 'EmblemaOne',fontWeight: FontWeight.bold,
                    shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.7), 
                      blurRadius: 5, 
                      offset: Offset(3, 3),
                    ),
                  ],
                    ),
                    ),
              ),
            ),
            
          ),
          Positioned(
            top: 400,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                child:Text("Discover the mysteries of the universe.\n Explore the stars, planets, and galaxies\n beyond imagination. Join us on a journey through cosmos!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white,
                shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.7), 
                      blurRadius: 5, 
                      offset: Offset(3, 3), 
                    ),
                  ],
                ),
                
                )
                 ),
            ),
          ),
          buttonStart(context,isSelected:  true)
          ],
        ),

    );
  }

  Positioned buttonStart(BuildContext context,{bool isSelected = false} ) {
    return Positioned(
          top: 700,
          left: 50,
          right: 50,
          child: GestureDetector(
            onTap: (){
              print("lets start");
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return  Explore();
              }));
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(4, 4)
                  )
                ],
                color:isSelected? Colors.blueGrey[800]:Colors.blueGrey[700],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(child: Text("Lets Explore",style: TextStyle(
                color:isSelected? const Color.fromARGB(255, 194, 49, 39):Colors.white,fontSize: 20
              ),)),
            ),
          ),
        );
  }
}
