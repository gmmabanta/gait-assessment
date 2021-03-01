import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gait_assessment/training_screen.dart';
import 'package:gait_assessment/schedule_screen.dart';
import 'package:gait_assessment/trainingresults_screen.dart';
import 'package:gait_assessment/calendar.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF1EEEE),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Hello Patient",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,)
                  ),
                  Text("What are you up to today?",
                    style: TextStyle(fontSize: 20, color: Color(0xFFFB1AEAE)),
                  ),
                ],
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(30),
                    width: 400,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Text("Start Training",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.teal[300],
                          fontWeight: FontWeight.w500,
                          fontSize: 20
                      ),
                    ),
                  ),


                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>TrainingScreen()),
                    );
                  },
                ),

                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(30),
                    width: 400,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Text("Schedule",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.teal[300],
                          fontWeight: FontWeight.w500,
                          fontSize: 20
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
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(30),
                    width: 400,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Text("Past Training Results",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.teal[300],
                          fontWeight: FontWeight.w500,
                          fontSize: 20
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
            )
          ],

        )
      ),
    );
  }
}
