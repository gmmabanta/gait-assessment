import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:gait_assessment/mainscreen.dart';
//import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  CalendarController _calendarController = CalendarController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Calendar",
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              calendarController: _calendarController,
              calendarStyle: CalendarStyle(
                selectedColor: Colors.teal[300],
                todayColor: Colors.transparent,
                todayStyle: TextStyle(color: Colors.teal[300]),
                weekendStyle: TextStyle(color: Colors.blueGrey[400]),
                outsideStyle: TextStyle(color: Colors.grey[300]),
                outsideWeekendStyle: TextStyle(color: Colors.grey[300]),
                markersColor: Colors.teal[300]
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle().copyWith(color: Colors.blueGrey[400])
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                centerHeaderTitle: true
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(30),
                    width: 400,
                    height: 600,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Text("Event#1",
                          //textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.blueGrey[300],
                              fontSize: 15
                          ),
                        ),
                        Text("Event#1",
                          //textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.blueGrey[300],
                              fontSize: 15
                          ),
                        ),
                        Text("Event#1",
                          //textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.blueGrey[300],
                              fontSize: 15
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}

