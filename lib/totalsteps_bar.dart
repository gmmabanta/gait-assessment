import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';

class BarChartView extends StatefulWidget {
  List<QueryDocumentSnapshot> document;
  BarChartView({this.document});

  @override
  State<StatefulWidget> createState() => BarChartViewState();
}

class BarChartViewState extends State<BarChartView> {
  final Color barBackgroundColor = const Color(0xFFCFD8DC);
  final Duration animDuration = const Duration(milliseconds: 200);
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        //width: 385,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: SizedBox(
                width: (widget.document.length * 35).toDouble(),
                child: BarChart(mainBarData(widget.document))),
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Step Percentage (%)",
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 14
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Correct Steps",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                              fontSize: 10
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(Icons.circle,
                            size: 10,
                            color: Colors.teal[300]
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("Total Steps",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                              fontSize: 10
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(Icons.circle,
                            size: 10,
                            color: Color(0xFFCFD8DC)
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),

          ],
        )
    );
  }

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color barColor = const Color(0xFF4DB6AC),
        double width = 14,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barsSpace: 20,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.teal[200]] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 100,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  BarChartData mainBarData(documents) {
    List<BarChartGroupData> showingGroups(documents) => List.generate(documents.length, (index) {
      return makeGroupData(index, ((documents[index]['correct_steps']/documents[index]['total_steps'])*100).toDouble(), isTouched: index == touchedIndex, width: 14);
    });

    return BarChartData(
      maxY: 100,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey[300],
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String totalN;
              String correctN;
              String wrongN;
              totalN = "total: ${documents[groupIndex]['total_steps'].toString()}";
              correctN = "correct: ${documents[groupIndex]['correct_steps'].toString()}";
              wrongN = "wrong: ${documents[groupIndex]['wrong_steps'].toString()}";
              return BarTooltipItem(
                  (("Total steps: "+documents[groupIndex]['total_steps'].toString()+ "\n"+ documents[groupIndex]['correct_steps']/documents[groupIndex]['total_steps'])*100).toString() + "%",
                  TextStyle(color: Colors.white));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        /*bottomTitles: SideTitles(
          reservedSize: 20,
          showTitles: true,
          getTextStyles: (value) =>
          const TextStyle(color: Color(0xFF4DB6AC), fontSize: 14),
          margin: 5,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),*/
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
          showTitles: true,
          interval: 50
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(documents),
    );
  }
}

