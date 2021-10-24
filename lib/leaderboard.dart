import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderBoard extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LeaderBoardState();
  }

}

class LeaderBoardState extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFF343434),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  [
          const SizedBox(
            height: 60,
          ),
        Center(child: Text('Top Scores',style: GoogleFonts.josefinSans(fontSize: 50,color: Colors.white),),),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('score').orderBy('score',descending: true).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            else {
              return ListView(
                children: snapshot.data!.docs.map((document) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      color: Colors.black54,
                      height: 100,

                      child: ListTile(
                        leading: Text(document['score'].toString(),style: GoogleFonts.josefinSans(fontSize: 70,color: Colors.white),),
                        title: Center(child: Text(document['username'].toString(),style: GoogleFonts.josefinSans(fontSize: 30,color: Colors.white),)),
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          }
          ),
        )
        ],
      ),
    );
  }
}