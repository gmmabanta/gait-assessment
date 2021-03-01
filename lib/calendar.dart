import 'package:flutter/material.dart';
//import 'package:gait_assessment/mainscreen.dart';


class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Calendar")),
      backgroundColor: Color(0xFFFF1EEEE),
      body: Container(
        margin: EdgeInsets.all(60),
        child: Column(
          children: <Widget>[
            Text("This is a schedule screen"),
            Column(
              children: <Widget>[
                Text("Flutter and Firebase"),
                TextField(
                  decoration: new InputDecoration(
                    enabledBorder: new OutlineInputBorder(
                        borderSide: new BorderSide(color:Colors.black)),
                    labelText: 'Enter Value A',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20, top: 20),
                  padding: EdgeInsets.all(10),
                  width: 600,
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


              ],
            ),
          ],
        ),
      ),
    );
  }
}
