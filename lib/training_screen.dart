import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gait_assessment/settings_screen.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:date_time_format/date_time_format.dart';
import 'dart:math';
import 'package:gait_assessment/bluetooth.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

Random random = new Random();
final FirebaseAuth auth = FirebaseAuth.instance;
user_id(){
  final User user = auth.currentUser;
  final uid = user.uid;
  print(uid);
  return uid;
}

class TrainingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Training",
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
        margin: EdgeInsets.all(60),
        child: ListPage(),
        //GestureDetector(
        //  child: Container(
        //    decoration: BoxDecoration(
        //        color: Colors.pink
        //    ),
        //    child: Text("This is a training screen"),

        //  ),
        //  onTap: () {
        //    Navigator.push(context,
        //      MaterialPageRoute(builder: (context)=>MainScreen()),
        //    );
        //  },
        ),
        
      //),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  int total_steps = random.nextInt(100), correct_steps = random.nextInt(70), wrong_steps = random.nextInt(30);
  int cadence = random.nextInt(100), ave_step_time = random.nextInt(60);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            /*
            TextFormField(
              controller: sampledata1,
              decoration: InputDecoration(
                hintText: "sample data 1"
              ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: sampledata2,
              decoration: InputDecoration(
                  hintText: "sample data 1"
              ),
            ),
             */
            SizedBox(height: 10),
            /*FlatButton(
              onPressed: (){
                Map <String,dynamic> training_data= {
                  "date": DateTime.now(),
                  "user_id": user_id(),
                  "total_steps":total_steps.toInt(),
                  "correct_steps":correct_steps.toInt(),
                  "wrong_steps":wrong_steps.toInt(),
                  "cadence":cadence.toInt(),
                  "ave_step_time":ave_step_time.toInt(),
                };
                FirebaseFirestore.instance.collection("users").doc(user_id()).collection("training").add(training_data);
              },
              child: Text("Submit"),
              color: Colors.blueAccent,
            ),*/
            FlatButton(
              onPressed: () async{
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> ListTraining() ));
                },
              child: Text("Results"),
              color: Colors.blueAccent,
            )
          ],
        ),
      ),

    );
  }
}

class ListTraining extends StatefulWidget {
  @override
  _ListTrainingState createState() => _ListTrainingState();
}

class _ListTrainingState extends State<ListTraining> {

  Future getData() async {
    QuerySnapshot qn = await FirebaseFirestore.instance.collection("/users/" +user_id() +"/training/").get();
    return qn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF1EEEE),

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
      body: FutureBuilder(
        future: getData(),
        builder: (_,snapshot){
        if(!snapshot.hasData){
          return Text("no data");
        }else{
          final documents = snapshot.data.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index){
            Timestamp t = documents[index]['date'];
            DateTime d = t.toDate();
              return Container(
                margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                padding: EdgeInsets.only(top: 20, bottom: 20, right: 25, left: 25),
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                     //Text(document["user_id"].toString()),
                    Text(d.format('F j'),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(d.format('g:i A')),




                  ],
                ),
              );
            },
          );

        }

      }),
    );
  }
}

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class TrainingProgress extends StatefulWidget {
  @override
  _TrainingProgressState createState() => _TrainingProgressState();
}

class _TrainingProgressState extends State<TrainingProgress> {
  Duration _duration = Duration(seconds: 1);
  Duration _position = Duration();
  AudioPlayer advancedPlayer;
  AudioCache audioCache;

  int total_steps = random.nextInt(100), correct_steps = random.nextInt(70), wrong_steps = random.nextInt(30);
  int cadence = random.nextInt(100), ave_step_time = random.nextInt(60);


  @override
  void initState(){
    super.initState();
    initPlayer();
  }

  void initPlayer(){
    advancedPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: advancedPlayer);

    advancedPlayer.durationHandler = (d) => setState((){
      _duration = d;
    });

    advancedPlayer.positionHandler = (p) => setState((){
      _position = p;
    });
  }

  String localFilePath;

  bool _endTraining = false;
  signalEndTraining(){
    if(_duration.inSeconds.toDouble() == _position.inSeconds.toDouble()){
      _endTraining = true;
    } else{
      _endTraining = false;
    }
    return _position.inSeconds.toDouble();
  }

  bool _play = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Training",
          style: TextStyle(color: Colors.teal[300],),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context,
                //MaterialPageRoute(builder: (context) => SettingsScreen()),
                MaterialPageRoute(builder: (context)=>BluetoothApp()),
              );
            }
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
            color: Colors.teal[300]
        ),
      ),
      backgroundColor: Color(0xFFFF1EEEE),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left:60, right:60, bottom: 40),
            child: Stack(
              children: <Widget>[
                SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 0,
                      maximum: _duration.inSeconds.toDouble(),
                      showLabels: false,
                      showTicks: false,
                      startAngle: 270,
                      endAngle: 270,
                      axisLineStyle: AxisLineStyle(
                        thickness: 0.15,
                        cornerStyle: CornerStyle.bothFlat,
                        color: Color(0xFFBCFD8DC),
                        thicknessUnit: GaugeSizeUnit.factor,
                      ),
                      pointers: <GaugePointer>[
                        RangePointer(
                            value: signalEndTraining(),
                            cornerStyle: CornerStyle.bothFlat,
                            width: 0.15,
                            sizeUnit: GaugeSizeUnit.factor,
                            color: Colors.teal[300]
                        )
                      ],
                    ),
                  ],

                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 107),
                    child: IconButton(
                      icon: Icon(_play? Icons.play_arrow_rounded : Icons.pause_rounded),
                      onPressed: (){
                        setState(() {
                          if(_play){
                            audioCache.play('metronome_test.mp3');
                            _play = false;
                          } else {
                            advancedPlayer.pause();
                            _play = true;
                          }
                        });
                      },
                      //icon: Icon(_play? Icons.play_arrow_rounded : Icons.pause_rounded),
                      color: Colors.teal[300],
                      iconSize: 120,
                    ),
                  )
                ),


              ],
            )
          ),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(left:60, right:60),
              padding: EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: _endTraining? Colors.teal[300] : Color(0xFFBCFD8DC),
                borderRadius: BorderRadius.all(Radius.circular(80)),
              ),
              child: Text("End Training",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18
                ),
              ),
            ),

            onTap: () {
              if(_endTraining){
                Map <String,dynamic> training_data= {
                  "date": DateTime.now(),
                  "user_id": user_id(),
                  "total_steps":total_steps.toInt(),
                  "correct_steps":correct_steps.toInt(),
                  "wrong_steps":wrong_steps.toInt(),
                  "cadence":cadence.toInt(),
                  "ave_step_time":ave_step_time.toInt(),
                };
                FirebaseFirestore.instance.collection("users").doc(user_id()).collection("training").add(training_data);
                Navigator.of(context).pop();
              } else {
                //do nothing
              }
              //@TODO: add function to upload all data to Firebase

            },
          ),
        ],

      ),
    );
  }
}
