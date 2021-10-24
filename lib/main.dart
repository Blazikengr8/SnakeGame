import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake_game/leaderboard.dart';

import 'game.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage()));
}


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String username='';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF343434),
        body: SingleChildScrollView(
          child: Column(
           // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height:80,
              ),
              Center(child: Text('Snake Game',style: GoogleFonts.josefinSans(fontSize: 55,fontWeight: FontWeight.w800,color: Colors.white),)),
              const SizedBox(
                height: 40,
              ),
             Padding(
               padding: const EdgeInsets.fromLTRB(60.0,0,0,10),
               child: Align(
                   alignment: Alignment.bottomLeft,
                   child: Text('Username:',style: GoogleFonts.josefinSans(fontSize: 24,color: Colors.white),)),
             ),
              Container(
                height: 100,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: 80,
                    width: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black,
                    ),
                    child:   Center(
                      child: TextField(
                          onChanged:(String value){
                            username=value;
                          },
                          cursorColor: Colors.white,
                          style: GoogleFonts.josefinSans(fontSize: 30,color: Colors.white),
                          ),
                    ),
                    )
                  ),
                ),
             const SizedBox(
                height: 20,
              ),
              Container(
                height: 250,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Center(
                  child: Container(
                      height: 230,
                      width: 280,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black,
                      ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SnakeGame(username)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black87,
                                    ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:  [
                                      const Icon(Icons.play_arrow,size: 75,color: Colors.white,),
                                      Text('Play',style: GoogleFonts.josefinSans(fontSize: 55,fontWeight: FontWeight.w800,color: Colors.white),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>LeaderBoard()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black87,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:  [
                                      Text('Top Scores',style: GoogleFonts.josefinSans(fontSize: 45,fontWeight: FontWeight.w800,color: Colors.white),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

