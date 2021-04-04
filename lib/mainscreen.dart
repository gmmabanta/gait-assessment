import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:gait_assessment/training_screen.dart';
import 'package:gait_assessment/schedule_screen.dart';
import 'package:gait_assessment/trainingresults_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gait_assessment/bluetooth.dart';
import 'package:gait_assessment/music_player.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF1EEEE),
      body: Container(

        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,


          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(40)
                  ),
                  Text("Hello!",
                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold,)
                  ),
                  Text("What are you up to today?",
                    style: TextStyle(fontSize: 15, color: Color(0xFFFB1AEAE)),
                  ),
                  /*Container(
                      padding: EdgeInsets.all(15)
                  ),*/
                  MaterialButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    child: Text("Sign Out"),
                  ),

                ],
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15, right: 15),
                        padding: EdgeInsets.all(20),
                        height: 190,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                        child: Align(
                          alignment: FractionalOffset.bottomLeft,
                          child: Text("Start Training",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.teal[300],
                                fontWeight: FontWeight.w500,
                                fontSize: 20
                            ),
                          ),
                        )
                      ),


                      onTap: () {
                        Navigator.push(context,
                          //MaterialPageRoute(builder: (context)=>TrainingProgress()),
                          //MaterialPageRoute(builder: (context)=>BluetoothApp()),
                          MaterialPageRoute(builder: (context)=>LocalAudio()),

                        );
                      },
                    ),

                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15),
                        padding: EdgeInsets.all(20),
                        height: 190,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                        child: Align(
                          alignment: FractionalOffset.bottomLeft,
                          child: Text("View Training Results",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.teal[300],
                                fontWeight: FontWeight.w500,
                                fontSize: 20
                            ),
                          ),
                        ),

                      ),

                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>TrainingScreen()),
                        );
                      },
                    ),


                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(right: 15, bottom: 15),
                        padding: EdgeInsets.all(20),
                        height: 190,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                        child: Align(
                          alignment: FractionalOffset.bottomLeft,
                          child: Text("Schedule",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.teal[300],
                                fontWeight: FontWeight.w500,
                                fontSize: 20
                            ),
                          ),
                        ),


                      ),


                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>SchedulePage()),
                        );
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15),
                        padding: EdgeInsets.all(20),
                        height: 190,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                        child: Align(
                          alignment: FractionalOffset.bottomRight,
                          child: Text("Past Training Results",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.teal[300],
                                fontWeight: FontWeight.w500,
                                fontSize: 20
                            ),
                          ),
                        ),


                      ),


                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>TrainingResultsScreen()),
                        );
                      },
                    ),
                  ],
                ),




              ],
            )
          ],

        )
      ),
    );
  }
}
