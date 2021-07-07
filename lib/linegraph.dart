import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:date_time_format/date_time_format.dart';

class LineChartSample1 extends StatefulWidget {
  List<QueryDocumentSnapshot> document;
  LineChartSample1({this.document});

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {

  /*List<FlSpot> generateData(documents){
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
  }*/
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
          interval: 0.20,
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.blueGrey,
            fontSize: 10,
          ),
          /*getTitles: (value) {
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
              case 60:
                return '60';
              case 70:
                return '70';
            }
            return '';
          },

           */
          //getTitles: (value){
          //  return generateYTitles(documents, 'ave_step_time', value);
          //},
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
      maxY: checkmaxY(documents, 'ave_step_time'),
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
      //print("This is an iteration");
      return (_maxY);
    });
  }

  //function that returns string
  generateXTitles(documents, value){
    var xlabel;
    Timestamp t;
    DateTime d;
    //if(documents == null){
    //  d = DateTime.now();
    //  xlabel = d.format('d/j');
    //  return xlabel;
    //} else {
      t = documents[value.toInt()]['date'];
      d = t.toDate();
      xlabel = d.format('d/j');
      //print("XLABEL: ${xlabel}");
      return xlabel;
    //}


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

    //switch(value.toInt()){

    //}
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
    //print("ITERATE Y");
    //checkmaxY(documents,'total_steps');
    final List<FlSpot> trainingData = List.generate((documents == null) ? 1 : documents.length, (index) {
      if(documents == null){
        return FlSpot(0, 0);
      } else {
        return FlSpot(index.toDouble(), documents[index]['ave_step_time'].toDouble());
      }
    });

    final List<FlSpot> bpmData = List.generate((documents == null) ? 1 : documents.length, (index) {
      if(documents == null){
        return FlSpot(0, 0);
      } else {
          switch(documents[index]['bpm'].toInt()){
            case 49:
              return FlSpot(index.toDouble(), 1.224);
            case 55:
              return FlSpot(index.toDouble(), 1.09);
            case 60:
              return FlSpot(index.toDouble(), 1);;
          }
        //return FlSpot(index.toDouble(), documents[index]['bpm'].toDouble());
      }
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
      LineChartBarData(
        spots: bpmData,
        //spots: dummyData2,
        //spots: generateData(documents),
        colors: [
          Colors.blueGrey.shade300
        ],
        barWidth: 1,
        dotData: FlDotData(
            show: false
        ),
        isCurved: true
      ),
    ];
  }
}
