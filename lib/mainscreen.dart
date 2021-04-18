import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:gait_assessment/training_screen.dart';
import 'package:gait_assessment/schedule_screen.dart';
import 'package:gait_assessment/trainingresults_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gait_assessment/select_patient.dart';
import 'package:gait_assessment/therapist_calendar.dart';
import 'package:gait_assessment/user_settings.dart';

FirebaseAuth auth;
User user;
var uid;
//var u_data;

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
var _role = "";
var _fname = "";

/*Future getRole(var userid) async {
  var user_data = await FirebaseFirestore.instance.collection('users').where('user_id', isEqualTo: userid).limit(1);
  //print(user_data);
  user_data.get().then((data) {
    if (data.docs.length > 0) {
      print(data.docs[0]['role'].toString());
      _role = data.docs[0]['role'].toString();
      _fname = data.docs[0]['first_name'].toString();
    } else {
      _role = "patient";
      _fname = "";
    }
  });
}*/

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //double _menuHeight = 240;
  //double _menuWidth = 175;
  double _menuHeight;
  double _menuWidth;

  @override
  void initState(){
    auth = FirebaseAuth.instance;
    user = auth.currentUser;
    uid = user.uid;

    print(uid);
  }

  @override
  Widget build(BuildContext context) {
    _menuHeight = MediaQuery.of(context).size.height*0.30;
    _menuWidth = MediaQuery.of(context).size.width*0.42;

    return Container(
      child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').where('user_id', isEqualTo: uid).limit(1).snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return Container();
              } else if (snapshot.hasData){
                _role = snapshot.data.docs[0]['role'].toString();
                if(_role == "patient"){
                  return Scaffold(
                    appBar: AppBar(
                      actions: [
                        IconButton(
                          icon: Icon(Icons.logout),
                          onPressed:() async {
                            setState(() {
                              _role = "";
                              _fname = "";
                            });
                            await FirebaseAuth.instance.signOut();
                          },
                        )
                      ],
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      iconTheme: IconThemeData(
                          color: Colors.teal[300]
                      ),
                    ),
                    backgroundColor: Color(0xFFFF1EEEE),
                    body: Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 7),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.all(00)
                                  ),
                                  Text("Hello ${capitalize(snapshot.data.docs[0]['first_name'].toString())}!",
                                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold,)
                                  ),
                                  Text("What are you up to today?",
                                    style: TextStyle(fontSize: 15, color: Color(0xFFFB1AEAE)),
                                  ),
                                  /*Container(
                      padding: EdgeInsets.all(15)
                  ),*/
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
                                          height: _menuHeight,
                                          width: _menuWidth,
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
                                          MaterialPageRoute(builder: (context)=>TrainingProgress()),
                                          //MaterialPageRoute(builder: (context)=>BluetoothApp()),
                                          //MaterialPageRoute(builder: (context)=>LocalAudio()),
                                        );
                                      },
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        padding: EdgeInsets.all(20),
                                        height: _menuHeight,
                                        width: _menuWidth,
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
                                          MaterialPageRoute(builder: (context)=>ListTraining()),
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
                                        height: _menuHeight,
                                        width: _menuWidth,
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
                                        height: _menuHeight,
                                        width: _menuWidth,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(18)),
                                        ),
                                        child: Align(
                                          alignment: FractionalOffset.bottomLeft,
                                          child: Text("Summary",
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
                } else if (_role == "staff"){
                  return Scaffold(
                    appBar: AppBar(
                      actions: [
                        IconButton(
                          icon: Icon(Icons.logout),
                          onPressed:() async {
                            await FirebaseAuth.instance.signOut();
                          },
                        )
                      ],
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      iconTheme: IconThemeData(
                          color: Colors.teal[300]
                      ),
                    ),
                    backgroundColor: Color(0xFFFF1EEEE),
                    body: Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 7),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.all(00)
                                  ),
                                  Text("Hello ${capitalize(snapshot.data.docs[0]['first_name'].toString())}!",
                                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold,)
                                  ),
                                  Text("What are you up to today?",
                                    style: TextStyle(fontSize: 15, color: Color(0xFFFB1AEAE)),
                                  ),
                                  /*Container(
                      padding: EdgeInsets.all(15)
                  ),*/

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
                                          height: _menuHeight,
                                          width: _menuWidth,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(18)),
                                          ),
                                          child: Align(
                                            alignment: FractionalOffset.bottomLeft,
                                            child: Text("Select Patient",
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
                                          MaterialPageRoute(builder: (context)=>SelectPatient()),

                                        );
                                      },
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        padding: EdgeInsets.all(20),
                                        height: _menuHeight,
                                        width: _menuWidth,
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
                                          MaterialPageRoute(builder: (context)=>ScheduleStaff()),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(height: _menuHeight,)

                                  ],
                                ),




                              ],
                            )
                          ],

                        )
                    ),
                  );
                } else if (_role == "admin"){
                  return Scaffold(
                    appBar: AppBar(
                      actions: [
                        IconButton(
                          icon: Icon(Icons.logout),
                          onPressed:() async {
                            await FirebaseAuth.instance.signOut();
                          },
                        )
                      ],
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      iconTheme: IconThemeData(
                          color: Colors.teal[300]
                      ),
                    ),
                    backgroundColor: Color(0xFFFF1EEEE),
                    body: Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 7),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.all(00)
                                  ),
                                  Text("Hello ${capitalize(snapshot.data.docs[0]['role'].toString())}!",
                                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold,)
                                  ),
                                  Text("What are you up to today?",
                                    style: TextStyle(fontSize: 15, color: Color(0xFFFB1AEAE)),
                                  ),
                                  /*Container(
                                        padding: EdgeInsets.all(15)
                                    ),*/
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
                                          height: _menuHeight,
                                          width: _menuWidth,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(18)),
                                          ),
                                          child: Align(
                                            alignment: FractionalOffset.bottomLeft,
                                            child: Text("Users Settings",
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
                                          MaterialPageRoute(builder: (context)=>UserSettings()),
                                        );
                                      },
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        padding: EdgeInsets.all(20),
                                        height: _menuHeight,
                                        width: _menuWidth,
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
                                          MaterialPageRoute(builder: (context)=>ListTraining()),
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
                                        height: _menuHeight,
                                        width: _menuWidth,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(18)),
                                        ),
                                        child: Align(
                                          alignment: FractionalOffset.bottomLeft,
                                          child: Text("Schedules",
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
                                        height: _menuHeight,
                                        width: _menuWidth,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(18)),
                                        ),
                                        child: Align(
                                          alignment: FractionalOffset.bottomLeft,
                                          child: Text("Therapist Assignment",
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
                                        //Navigator.push(context,
                                        //  MaterialPageRoute(builder: (context)=>TrainingResultsScreen()),
                                        //);
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
                } else {
                  return Scaffold(
                    appBar: AppBar(
                      actions: [
                        IconButton(
                          icon: Icon(Icons.logout),
                          onPressed:() async {
                            setState(() {
                              _role = "";
                              _fname = "";
                            });
                            await FirebaseAuth.instance.signOut();
                          },
                        )
                      ],
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      iconTheme: IconThemeData(
                          color: Colors.teal[300]
                      ),
                    ),
                    backgroundColor: Color(0xFFFF1EEEE),
                    body: Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 7),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.all(00)
                                  ),
                                  Text("Hello ${capitalize(snapshot.data.docs[0]['first_name'].toString())}!",
                                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold,)
                                  ),
                                  Text("What are you up to today?",
                                    style: TextStyle(fontSize: 15, color: Color(0xFFFB1AEAE)),
                                  ),
                                  /*Container(
                      padding: EdgeInsets.all(15)
                  ),*/
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
                                          height: _menuHeight,
                                          width: _menuWidth,
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
                                          MaterialPageRoute(builder: (context)=>TrainingProgress()),
                                          //MaterialPageRoute(builder: (context)=>BluetoothApp()),
                                          //MaterialPageRoute(builder: (context)=>LocalAudio()),
                                        );
                                      },
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        padding: EdgeInsets.all(20),
                                        height: _menuHeight,
                                        width: _menuWidth,
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
                                          MaterialPageRoute(builder: (context)=>ListTraining()),
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
                                        height: _menuHeight,
                                        width: _menuWidth,
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
                                        height: _menuHeight,
                                        width: _menuWidth,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(18)),
                                        ),
                                        child: Align(
                                          alignment: FractionalOffset.bottomLeft,
                                          child: Text("Summary",
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
            }
        ),
    );
    /*
    if(_role == "patient"){
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed:() async {
                setState(() {
                  _role = "";
                  _fname = "";
                });
                await FirebaseAuth.instance.signOut();
              },
            )
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
              color: Colors.teal[300]
          ),
        ),
        backgroundColor: Color(0xFFFF1EEEE),
        body: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(00)
                      ),
                      Text("Hello ${capitalize(_fname)}!",
                          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold,)
                      ),
                      Text("What are you up to today?",
                        style: TextStyle(fontSize: 15, color: Color(0xFFFB1AEAE)),
                      ),
                      /*Container(
                      padding: EdgeInsets.all(15)
                  ),*/
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
                              height: _menuHeight,
                              width: _menuWidth,
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
                              MaterialPageRoute(builder: (context)=>TrainingProgress()),
                              //MaterialPageRoute(builder: (context)=>BluetoothApp()),
                              //MaterialPageRoute(builder: (context)=>LocalAudio()),
                            );
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 15),
                            padding: EdgeInsets.all(20),
                            height: _menuHeight,
                            width: _menuWidth,
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
                              MaterialPageRoute(builder: (context)=>ListTraining()),
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
                            height: _menuHeight,
                            width: _menuWidth,
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
                            height: _menuHeight,
                            width: _menuWidth,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(18)),
                            ),
                            child: Align(
                              alignment: FractionalOffset.bottomLeft,
                              child: Text("Summary",
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
    } else if (_role == "staff"){
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.logout),
                onPressed:() async {
                  await FirebaseAuth.instance.signOut();
                },
            )
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
              color: Colors.teal[300]
          ),
        ),
        backgroundColor: Color(0xFFFF1EEEE),
        body: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(00)
                      ),
                      Text("Hello ${capitalize(_fname)}!",
                          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold,)
                      ),
                      Text("What are you up to today?",
                        style: TextStyle(fontSize: 15, color: Color(0xFFFB1AEAE)),
                      ),
                      /*Container(
                      padding: EdgeInsets.all(15)
                  ),*/

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
                              height: _menuHeight,
                              width: _menuWidth,
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
                              MaterialPageRoute(builder: (context)=>TrainingProgress()),
                              //MaterialPageRoute(builder: (context)=>BluetoothApp()),
                              //MaterialPageRoute(builder: (context)=>LocalAudio()),
                            );
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 15),
                            padding: EdgeInsets.all(20),
                            height: _menuHeight,
                            width: _menuWidth,
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
                              MaterialPageRoute(builder: (context)=>ListTraining()),
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
                            height: _menuHeight,
                            width: _menuWidth,
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
                            height: _menuHeight,
                            width: _menuWidth,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(18)),
                            ),
                            child: Align(
                              alignment: FractionalOffset.bottomLeft,
                              child: Text("Summary",
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
    } else if (_role == "admin"){
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed:() async {
                await FirebaseAuth.instance.signOut();
              },
            )
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
              color: Colors.teal[300]
          ),
        ),
        backgroundColor: Color(0xFFFF1EEEE),
        body: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(00)
                      ),
                      Text("Hello ${capitalize(_fname)}!",
                          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold,)
                      ),
                      Text("What are you up to today?",
                        style: TextStyle(fontSize: 15, color: Color(0xFFFB1AEAE)),
                      ),
                      /*Container(
                      padding: EdgeInsets.all(15)
                  ),*/
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
                              height: _menuHeight,
                              width: _menuWidth,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(18)),
                              ),
                              child: Align(
                                alignment: FractionalOffset.bottomLeft,
                                child: Text("Users",
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
                            //Navigator.push((){});
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 15),
                            padding: EdgeInsets.all(20),
                            height: _menuHeight,
                            width: _menuWidth,
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
                              MaterialPageRoute(builder: (context)=>ListTraining()),
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
                            height: _menuHeight,
                            width: _menuWidth,
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
                            height: _menuHeight,
                            width: _menuWidth,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(18)),
                            ),
                            child: Align(
                              alignment: FractionalOffset.bottomLeft,
                              child: Text("Summary",
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
    } else {
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed:() async {
                await FirebaseAuth.instance.signOut();
              },
            )
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
              color: Colors.teal[300]
          ),
        ),
        backgroundColor: Color(0xFFFF1EEEE),
        body: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(00)
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
                    ],
                  ),
                ),
                Center(
                  child: CircularProgressIndicator()
                )
              ],

            )
        ),
      );
    }
    */
  }
}


