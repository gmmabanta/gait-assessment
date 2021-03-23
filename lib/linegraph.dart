import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Parameters {
  final double total_steps;
  final double correct_steps;
  final double wrong_steps;
  final double avestep_time;
  final double cadence;

  Parameters(this.total_steps, this.correct_steps, this.wrong_steps, this.avestep_time, this.cadence);
}

class LineChartSample1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  user_id(){
    final User user = auth.currentUser;
    final uid = user.uid;
    //print(uid);
    return uid;
  }

  Future getData() async {
    QuerySnapshot qn = await FirebaseFirestore.instance.collection("/users/" +user_id() +"/training/").get();
    return qn;
  }

  List<FlSpot> generateData(documents){
    //for (int index = 0; documents!=null || index<documents.length;index++){
      //print("index: $index");
      //print("first ${index.toDouble()} | second: ${documents[index]['total_steps'].toDouble()}");
      if(documents == null){
        return [FlSpot(0, 0)];
      } else{
        print(List.generate(documents.length, (index) {
          return FlSpot(index.toDouble(), documents[index]['total_steps'].toDouble());
        })
        );
      }

    //}
  }
  /*
  List<FlSpot> generateData (documents){
    for (int index = 0;index<documents.length;index++){
      print(documents[index]['date']);
      return [documents[index]['date']];

    }
  }

   */

  bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Text("no data");
        } else {
          final documents = snapshot.data.docs;
          return Container(
            padding: EdgeInsets.only(top:20, bottom:10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Average Step Time",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 16
                      ),
                    ),
                    SizedBox(width: 110)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    LineChart(sampleData2(documents),
                      swapAnimationDuration: const Duration(milliseconds: 250),
                    ),
                    SizedBox(width: 5)

                  ],
                ),



              ],
            ),
          );

        }

      },
    );

  }

  LineChartData sampleData2(documents) {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
      ),
      gridData: FlGridData(
        show: true,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 25,
          getTextStyles: (value) => const TextStyle(
            color: Colors.blueGrey,
            fontSize: 14,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'SEPT';
              case 7:
                return 'OCT';
              case 12:
                return 'DEC';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.blueGrey,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 10:
                return '10';
              case 20:
                return '20';
              case 30:
                return '30';
              case 40:
                return '40';
              case 50:
                return '50';
            }
            return '';
          },
          margin: 5,
          reservedSize: 15,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Colors.black26,
              width: 1,
            ),
            left: BorderSide(
              color: Colors.transparent,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          )),
      minX: 0,
      maxX: 14,//make this the current # of entries?
      maxY: 60,
      minY: 0,
      lineBarsData: linesBarData2(documents),
    );
  }

  final List<FlSpot> dummyData =
    [
      FlSpot(1, 30),
      FlSpot(4, 50.8),
      FlSpot(7, 30),
      FlSpot(8, 20.8),
      FlSpot(10, 20.9),
      FlSpot(12, 10.5),
      FlSpot(13, 10.9),
    ];

  /*
  final List<FlSpot> dummyData2 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });
  */

  List<LineChartBarData> linesBarData2(documents) {
    final List<FlSpot> trainingData = List.generate(documents.length, (index) {
      return FlSpot(index.toDouble(), documents[index]['total_steps'].toDouble());
    });

    return [
      LineChartBarData(
        spots: trainingData,
        //spots: generateData(documents),
        colors: const [
          Color(0xFF4DB6AC),
        ],
        barWidth: 1.5,
        dotData: FlDotData(
          show: true
        ),
      ),
    ];
  }
}



class StepPercentage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StepPercentageState();
}

class StepPercentageState extends State<StepPercentage> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  user_id(){
    final User user = auth.currentUser;
    final uid = user.uid;
    //print(uid);
    return uid;
  }

  Future getData() async {
    QuerySnapshot qn = await FirebaseFirestore.instance.collection("/users/" +user_id() +"/training/").get();
    return qn;
  }
  bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Text("no data");
        } else {
          final documents = snapshot.data.docs;
          return Container(
            padding: EdgeInsets.only(top:20, bottom:10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Average Step Time",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 16
                      ),
                    ),
                    SizedBox(width: 110)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    LineChart(sampleData2(documents),
                      swapAnimationDuration: const Duration(milliseconds: 250),
                    ),
                    SizedBox(width: 5)

                  ],
                ),



              ],
            ),
          );

        }

      },
    );

  }

  LineChartData sampleData2(documents) {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
      ),
      gridData: FlGridData(
        show: true,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 25,
          getTextStyles: (value) => const TextStyle(
            color: Colors.blueGrey,
            fontSize: 14,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'SEPT';
              case 7:
                return 'OCT';
              case 12:
                return 'DEC';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.blueGrey,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 10:
                return '10';
              case 20:
                return '20';
              case 30:
                return '30';
              case 40:
                return '40';
              case 50:
                return '50';
            }
            return '';
          },
          margin: 5,
          reservedSize: 15,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Colors.black26,
              width: 1,
            ),
            left: BorderSide(
              color: Colors.transparent,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          )),
      minX: 0,
      maxX: 14,//make this the current # of entries?
      maxY: 60,
      minY: 0,
      lineBarsData: linesBarData2(documents),
    );
  }

  final List<FlSpot> dummyData =
  [
    FlSpot(1, 30),
    FlSpot(4, 50.8),
    FlSpot(7, 30),
    FlSpot(8, 20.8),
    FlSpot(10, 20.9),
    FlSpot(12, 10.5),
    FlSpot(13, 10.9),
  ];

  /*
  final List<FlSpot> dummyData2 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });
  */

  List<LineChartBarData> linesBarData2(documents) {
    final List<FlSpot> trainingData = List.generate(documents.length, (index) {
      return FlSpot(index.toDouble(), documents[index]['total_steps'].toDouble());
    });

    return [
      LineChartBarData(
        spots: trainingData,
        //spots: generateData(documents),
        colors: const [
          Color(0xFF4DB6AC),
        ],
        barWidth: 1.5,
        dotData: FlDotData(
            show: true
        ),
      ),
    ];
  }
}