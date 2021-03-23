import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BarChartView extends StatefulWidget {
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
        padding: EdgeInsets.all(25),
        width: 385,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Step Percentage",
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 16
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
                        Icon(IconData(61645, fontFamily: 'MaterialIcons'),
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
                        Icon(IconData(61645, fontFamily: 'MaterialIcons'),
                            size: 10,
                            color: Color(0xFFCFD8DC)
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 17),
            BarChart(mainBarData()),
          ],
        )
    );
  }

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color barColor = const Color(0xFF4DB6AC),
        double width = 10,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
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

  List<BarChartGroupData> showingGroups() => List.generate(15, (i) {
    switch (i) {
      case 0:
        return makeGroupData(0, 40, isTouched: i == touchedIndex);
      case 1:
        return makeGroupData(1, 65, isTouched: i == touchedIndex);
      case 2:
        return makeGroupData(2, 50, isTouched: i == touchedIndex);
      case 3:
        return makeGroupData(3, 75, isTouched: i == touchedIndex);
      case 4:
        return makeGroupData(4, 90, isTouched: i == touchedIndex);
      case 5:
        return makeGroupData(5, 11.5, isTouched: i == touchedIndex);
      case 6:
        return makeGroupData(6, 60, isTouched: i == touchedIndex);
      case 7:
        return makeGroupData(7, 60, isTouched: i == touchedIndex);
      case 8:
        return makeGroupData(7, 60, isTouched: i == touchedIndex);
      case 9:
        return makeGroupData(7, 60, isTouched: i == touchedIndex);
      case 10:
        return makeGroupData(7, 60, isTouched: i == touchedIndex);
      case 11:
        return makeGroupData(7, 60, isTouched: i == touchedIndex);
      case 12:
        return makeGroupData(7, 60, isTouched: i == touchedIndex);
      case 13:
        return makeGroupData(7, 60, isTouched: i == touchedIndex);
      case 14:
        return makeGroupData(7, 60, isTouched: i == touchedIndex);

      default:
        return null;
    }
  });



  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey[400],
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String totalN;
              String correctN;
              String wrongN;
              totalN = "total: 4";
              correctN = "correct: 3";
              wrongN = "wrong: 1";
              return BarTooltipItem(
                  totalN + '\n' + correctN + '\n' + wrongN + '\n' + (rod.y - 1).toString(),
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
        bottomTitles: SideTitles(
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
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }
}

class TestBar extends StatefulWidget {
  @override
  _TestBarState createState() => _TestBarState();
}

class _TestBarState extends State<TestBar> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class Sales{
  final int saleVal;
  final String saleYear;
  final String colorVal;
  Sales(this.saleVal, this.saleYear, this.colorVal);

  Sales.fromMap(Map<String, dynamic> map)
  :assert(map['salesVal']!=null),
  assert(map['saleYear']!=null),
  assert(map['colorVal']!=null),
    saleVal=map['salesVal'],
    saleYear=map['salesVal'],
    colorVal=map['colorVal'];

  @override
  String toString() => "Record<$saleVal:$saleYear:$colorVal>";

}

