import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gait_assessment/mainscreen.dart';
import 'package:gait_assessment/training_screen.dart';
//import 'package:gait_assessment/mainscreen.dart';
//import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:date_time_format/date_time_format.dart';

class SchedulePage extends StatefulWidget {
  var uid;
  SchedulePage({this.uid});
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  CalendarController _calendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    var calendarHeight = MediaQuery.of(context).size.height*0.50;
    return Scaffold(
      appBar: AppBar(
        title: Text("Patient Calendar",
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
        child: Stack(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              //height: calendarHeight,
                child: TableCalendar(
                availableGestures: AvailableGestures.horizontalSwipe,
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
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: calendarHeight,),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child:  Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding: EdgeInsets.only(top: 10),
                        clipBehavior: Clip.hardEdge,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - calendarHeight-80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        /*child: Container(
                          child: FutureBuilder(
                              future: FirebaseFirestore.instance.collection('schedule').where('user_id', isEqualTo: widget.uid).where('date', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(hours: 12))).orderBy('date', descending: true).get(),
                              builder: (context, snapshot) {
                                print("SNAPSHOT: ${snapshot.toString()}");
                                if (!snapshot.hasData) {
                                  return Container(
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                      child:Text("No data")
                                  );
                                } else if(snapshot.hasData){
                                  final event_doc = snapshot.data.docs;
                                  int docLen = event_doc.length;
                                  return Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: ListView.builder(
                                          clipBehavior: Clip.hardEdge,
                                          scrollDirection: Axis.vertical,
                                          itemCount: docLen,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index){
                                            Timestamp t = event_doc[index]['date'];
                                            DateTime d = t.toDate();
                                            return ListTile(
                                              title: Text("${d.format('F j')}"),
                                              leading: Icon(event_doc[index]['done'] ? Icons.check_box_outlined : Icons.check_box_outline_blank_rounded, color: Colors.teal[300]),
                                            );
                                          }
                                      )
                                  );
                                }
                              }
                          ),
                        )*/
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                            child:StreamBuilder(
                                stream: FirebaseFirestore.instance.collection('schedule')
                                    .where('date', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(hours: 12)))
                                    .where('date', isLessThanOrEqualTo: DateTime.now().add(Duration(days: 7)))
                                    .where('user_id', isEqualTo: widget.uid)
                                    .orderBy('date', descending: true).snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Text("Loading");
                                  } else if(snapshot.hasData){
                                    final event_doc = snapshot.data.docs;
                                    int docLen = event_doc.length;
                                    return Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: ListView.builder(
                                            clipBehavior: Clip.hardEdge,
                                            scrollDirection: Axis.vertical,
                                            itemCount: docLen,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index){
                                              Timestamp t = event_doc[index]['date'];
                                              DateTime d = t.toDate();
                                              return ListTile(
                                                  title: Text("${d.format('F j')}  |   ${event_doc[index]['duration']} mins"),
                                                  leading: Icon(event_doc[index]['done'] ? Icons.check_box_outlined : Icons.check_box_outline_blank_rounded, color: Colors.teal[300]),

                                              );
                                            }
                                        )
                                    );
                                  }
                                }
                            ),
                        )
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


class ScheduleAdmin extends StatefulWidget {
  var patientList;
  var uid;
  ScheduleAdmin({this.uid, this.patientList});
  @override
  _ScheduleAdminState createState() => _ScheduleAdminState();
}

class _ScheduleAdminState extends State<ScheduleAdmin> {
  CalendarController _calendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    var calendarHeight = MediaQuery.of(context).size.height*0.50;
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar",
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
        child: Stack(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                //height: calendarHeight,
                child: TableCalendar(
                  availableGestures: AvailableGestures.horizontalSwipe,
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
              ),
            ),
            Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: calendarHeight,),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child:  Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          padding: EdgeInsets.only(top: 10),
                          clipBehavior: Clip.hardEdge,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - calendarHeight-80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          /*child: Container(
                          child: FutureBuilder(
                              future: FirebaseFirestore.instance.collection('schedule').where('user_id', isEqualTo: widget.uid).where('date', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(hours: 12))).orderBy('date', descending: true).get(),
                              builder: (context, snapshot) {
                                print("SNAPSHOT: ${snapshot.toString()}");
                                if (!snapshot.hasData) {
                                  return Container(
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                      child:Text("No data")
                                  );
                                } else if(snapshot.hasData){
                                  final event_doc = snapshot.data.docs;
                                  int docLen = event_doc.length;
                                  return Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: ListView.builder(
                                          clipBehavior: Clip.hardEdge,
                                          scrollDirection: Axis.vertical,
                                          itemCount: docLen,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index){
                                            Timestamp t = event_doc[index]['date'];
                                            DateTime d = t.toDate();
                                            return ListTile(
                                              title: Text("${d.format('F j')}"),
                                              leading: Icon(event_doc[index]['done'] ? Icons.check_box_outlined : Icons.check_box_outline_blank_rounded, color: Colors.teal[300]),
                                            );
                                          }
                                      )
                                  );
                                }
                              }
                          ),
                        )*/
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child:StreamBuilder(
                                stream: FirebaseFirestore.instance.collection('schedule')
                                    .where('date', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 1)))
                                    .where('date', isLessThanOrEqualTo: DateTime.now().add(Duration(days: 7)))
                                    .orderBy('date', descending: true).snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Text("Loading");
                                  } else if(snapshot.hasData){
                                    final event_doc = snapshot.data.docs;
                                    int docLen = event_doc.length;
                                    return Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: ListView.builder(
                                            clipBehavior: Clip.hardEdge,
                                            scrollDirection: Axis.vertical,
                                            itemCount: docLen,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index){
                                              Timestamp t = event_doc[index]['date'];
                                              DateTime d = t.toDate();

                                              List usersList = widget.patientList;
                                              var userSched = event_doc[index]['user_id'];
                                              var userChecker = "";
                                              var userName = "";
                                              //print("LIST: ${usersList}");

                                              for (var i=0; i < usersList[index].length; i++){
                                                if(i < 28){
                                                  userChecker = userChecker + usersList[index][i];
                                                } else if (i > 28){
                                                  userName = userName + usersList[index][i];
                                                }
                                              }

                                              return ListTile(
                                                title: Text("${d.format('F j')}  |   ${event_doc[index]['duration']} mins"),
                                                subtitle: Text("${userName}"),
                                                leading: Icon(event_doc[index]['done'] ? Icons.check_box_outlined : Icons.check_box_outline_blank_rounded, color: Colors.teal[300]),
                                              );
                                            }
                                        )
                                    );
                                  }
                                }
                            ),
                          )
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

