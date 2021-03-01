import 'package:flutter/material.dart';
import 'package:gait_assessment/mainscreen.dart';
import 'package:gait_assessment/training_screen.dart';

class TrainingResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Training Results",
          style: TextStyle(color: Colors.teal[300],),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
            color: Colors.teal[300]
        ),
      ),
      backgroundColor: Color(0xFFFF1EEEE),
      body: Container(
        padding: EdgeInsets.all(30),
        child: ListResults(),
      )
    );
  }
}

class ListResults extends StatefulWidget {
  @override
  _ListResultsState createState() => _ListResultsState();
}

class _ListResultsState extends State<ListResults> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
                MaterialPageRoute(builder: (context)=>TrainingScreen()),
              );
            },
          ),
        ],
      )

    );
  }
}
