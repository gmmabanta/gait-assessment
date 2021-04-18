import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:date_time_format/date_time_format.dart';

class CadenceGraph extends StatefulWidget {
  List<QueryDocumentSnapshot> document;
  CadenceGraph({this.document});

  @override
  State<StatefulWidget> createState() => CadenceGraphState();
}

class CadenceGraphState extends State<CadenceGraph> {

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
    return Container(
      padding: EdgeInsets.only(bottom:10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: (widget.document.length*30).toDouble(),
                    child: LineChart(sampleData2(widget.document),
                      swapAnimationDuration: const Duration(milliseconds: 250),
                    ),
                  ),

                ],
              ),
            ),
          ),

        ],
      ),
    );

  }

  LineChartData sampleData2(documents) {
    return LineChartData(
      backgroundColor: Colors.white,
      lineBarsData: linesBarData2(documents),
      lineTouchData: LineTouchData(
        enabled: true,
      ),
      gridData: FlGridData(
        show: true,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 20,
            getTextStyles: (value) => const TextStyle(
              color: Colors.blueGrey,
              fontSize: 9,
            ),
            margin: 8,
            getTitles: (value) {
              Timestamp t;
              DateTime d;
              var xlabel;
              t = documents[value.toInt()]['date'];
              d = t.toDate();
              xlabel = d.format('n/j').toString();
              print("XLABEL: ${xlabel}");
              // generateXTitles(documents, value);
              /*switch(value.toInt()){
                case 1:
                  return "test";
                default:
                  return generateXTitles(documents, value);
              }*/
              return xlabel;
              //return ;
            }

        ),
        leftTitles: SideTitles(
          interval: 10,
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.blueGrey,
            fontSize: 10,
          ),
          margin: 10,
          reservedSize: 15,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Colors.black26,
              width: 1.5,
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
      maxX: documents.length.toDouble(),
      maxY: checkmaxY(documents, 'cadence'),
      minY: 0,
      //lineBarsData: linesBarData2(documents),
    );
  }

  /*final List<FlSpot> dummyData =
    [
      FlSpot(1, 30),
      FlSpot(4, 50.8),
      FlSpot(7, 30),
      FlSpot(8, 20.8),
      FlSpot(10, 20.9),
      FlSpot(12, 10.5),
      FlSpot(13, 10.9),
    ];
*/

  final List<FlSpot> dummyData2 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  double checkmaxY(documents, String field){
    double _maxY = 0;
    var i;
    documents.forEach((doc){
      i = doc[field].toDouble();
      if(_maxY < i ){
        _maxY = i;
      }
      print("This is an iteration");
      return (_maxY);
    });
  }

  //function that returns string
  generateXTitles(documents, value){
    Timestamp t;
    DateTime d;
    var xlabel;
    t = documents[value.toInt()]['date'];
    d = t.toDate();
    xlabel = d.format('d/j');
    print("XLABEL: ${xlabel}");
    return xlabel;

    //documents.forEach((doc){
    //  t = doc['date'];
    //  d = t.toDate();
    //  xlabel = d.format('d/j');
    //  return xlabel;
    //});
  }


  generateYTitles(documents, String field, value){
    //List<String> yArr = [];
    var yMax = checkmaxY(documents, field);
    for (var i =0; i < yMax; i=i+10){
      //yArr.add(i.toString());
      return i.toString();
    }

    switch(value.toInt()){

    }
    //return yArr;
  }

  /*checkmaxX(documents){
    double _maxX = 0;
    var i;
    documents.forEach((doc){
      if(_maxY < i ){
        _maxY = i;
      }
      print("This is an iteration");
      return (_maxY);
    });
  }*/

  List<LineChartBarData> linesBarData2(documents) {
    print("ITERATE Y");
    //checkmaxY(documents,'total_steps');
    final List<FlSpot> trainingData = List.generate(documents.length, (index) {
      return FlSpot(index.toDouble(), documents[index]['cadence'].toDouble());
    });

    return [
      LineChartBarData(
        spots: trainingData,
        //spots: dummyData2,
        //spots: generateData(documents),
        colors: const [
          Color(0xFF4DB6AC),
        ],
        barWidth: 2,
        dotData: FlDotData(
            show: true
        ),
      ),
    ];
  }
}