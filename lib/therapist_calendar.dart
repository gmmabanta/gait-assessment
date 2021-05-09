import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:gait_assessment/mainscreen.dart';
//import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';

//var docUsers;
//var usersList;


class ScheduleStaff extends StatefulWidget {
  var patientList;
  ScheduleStaff({this.patientList});
  @override
  _ScheduleStaffState createState() => _ScheduleStaffState();
}

class _ScheduleStaffState extends State<ScheduleStaff> {
  CalendarController _calendarController = CalendarController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  //bool editSched = true;
  @override
  Widget build(BuildContext context) {
    var calendarHeight = MediaQuery.of(context).size.height*0.50;
    var patientMap = {};

    for(var i=0; i<widget.patientList.length; i++){
      var splitString = widget.patientList[i].split('\n');
      var idParsed = '';
      for(var j=1; j<splitString[1].length-1; j++){
        idParsed = idParsed + splitString[1][j];
      }
      //print("idParsed: ${idParsed}");
      patientMap[idParsed] = "${splitString[0]}";
      //print("List length: ${splitString}");
    }

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
        actions: [
          IconButton(icon: Icon(Icons.add_rounded),
              onPressed: (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>AddSession(patientList: widget.patientList)),
                );
              }
          ),
        ],
      ),
      backgroundColor: Color(0xFFFF1EEEE),
      body: Container(
        child: Stack(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
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
                        child: Expanded(
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('schedule').where('date', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(hours: 12))).orderBy('date', descending: true).snapshots(),
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
                                                title: Text("${d.format('F j')} | ${patientMap[ event_doc[index]['user_id'] ]}"),
                                              leading: Icon(event_doc[index]['done'] ? Icons.check_box_outlined : Icons.check_box_outline_blank_rounded, color: Colors.teal[300]),
                                              trailing: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                  IconButton(icon: Icon(Icons.delete_outline_rounded), color: Colors.redAccent[300],
                                                      onPressed: () async {
                                                        await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
                                                          await myTransaction.delete(event_doc[index].reference);
                                                        });
                                                      }),
                                                  IconButton(icon: Icon(Icons.edit_rounded), color: Colors.teal[300],
                                                    onPressed: ()  {
                                                      Navigator.push( context,
                                                        MaterialPageRoute(builder: (context)=>UpdateSession(event_doc: event_doc, index: index,))
                                                      );
                                                    }
                                                  ),
                                                ],
                                              )

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

class UpdateSession extends StatefulWidget {
  var event_doc;
  var index;
  UpdateSession({this.event_doc, this.index});
  @override
  _UpdateSessionState createState() => _UpdateSessionState();
}

class _UpdateSessionState extends State<UpdateSession> {

  DateTime selectedDate = DateTime.now();

  final FirebaseAuth auth = FirebaseAuth.instance;

  _selectDate(BuildContext context) async {
    //DateTime d = DateTime.now();
    //if(widget.event_doc != null){
    //  Timestamp t = widget.event_doc[widget.index]['date'];
    //  DateTime d = t.toDate();
    //}
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
  var selectedBPM;
  //= widget.event_doc[widget.index]['bpm'];
  var selectedDuration;
  //= widget.event_doc[widget.index]['duration'];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Update Session",
          style: TextStyle(color: Colors.teal[300],),
        ),
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
            color: Colors.teal[300]
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            child: ElevatedButton(
                onPressed: () async {
                  //print(widget.event_doc[widget.index]['patient_id'].toString());
                  Map <String,dynamic> updatedData = {
                    "date": selectedDate,
                    //"user_id": userId,
                    "bpm": selectedBPM,      //shows the thread sequencing
                    "duration": selectedDuration,     //shows the training session associated with
                    //"therapist_id": auth.currentUser.uid,
                    //"done": widget.event_doc[widget.index]['done']
                  };
                  await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
                    await myTransaction.update(widget.event_doc[widget.index].reference, updatedData);
                  });
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(7.0),),
                    primary: Colors.teal[300],
                    elevation: 0,
                    minimumSize: Size(10, 20)
                ),
                child: Text(
                  "Update",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                )
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFFFF1EEEE),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.date_range_rounded, color: Colors.grey,),
            title: Text("${selectedDate.format('D, M j, Y')}"),
            onTap: () => _selectDate(context),
          ),
          SizedBox(height: 20,),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text("BPM setting",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      color:Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('49 BPM'),
                  leading: Radio(
                    value: 49,
                    groupValue: selectedBPM,
                    onChanged: (value) {
                      setState(() {
                        selectedBPM = value;
                      });
                    },
                    activeColor: Colors.teal[300],
                  ),
                  onTap: (){
                    setState(() {
                      selectedBPM = 49;
                    });
                  },
                ),
                ListTile(
                  title: const Text('55 BPM'),
                  leading: Radio(
                    value: 55,
                    groupValue: selectedBPM,
                    onChanged: (value) {
                      setState(() {
                        selectedBPM = value;
                      });
                    },
                    activeColor: Colors.teal[300],
                  ),
                  onTap: (){
                    setState(() {
                      selectedBPM = 55;
                    });
                  },
                ),
                ListTile(
                  title: const Text('60 BPM'),
                  leading: Radio(
                    value: 60,
                    groupValue: selectedBPM,
                    onChanged: (value) {
                      setState(() {
                        selectedBPM = value;
                      });
                    },
                    activeColor: Colors.teal[300],
                  ),
                  onTap: (){
                    setState(() {
                      selectedBPM = 60;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text("Duration",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      color:Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('10 minutes'),
                  leading: Radio(
                    value: 10,
                    groupValue: selectedDuration,
                    onChanged: (value) {
                      setState(() {
                        selectedDuration = value;
                      });
                    },
                    activeColor: Colors.teal[300],
                  ),
                  onTap: (){
                    setState(() {
                      selectedDuration = 10;
                    });
                  },
                ),
                ListTile(
                  title: const Text('15 minutes'),
                  leading: Radio(
                    value: 15,
                    groupValue: selectedDuration,
                    onChanged: (value) {
                      setState(() {
                        selectedDuration = value;
                      });
                    },
                    activeColor: Colors.teal[300],
                  ),
                  onTap: (){
                    setState(() {
                      selectedDuration = 15;
                    });
                  },
                ),
                ListTile(
                  title: const Text('20 minutes'),
                  leading: Radio(
                    value: 20,
                    groupValue: selectedDuration,
                    onChanged: (value) {
                      setState(() {
                        selectedDuration = value;
                      });
                    },
                    activeColor: Colors.teal[300],
                  ),
                  onTap: (){
                    setState(() {
                      selectedDuration = 20;
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),

    );
  }
}

class AddSession extends StatefulWidget {
  var patientList;
  AddSession({this.patientList});
  @override
  _AddSessionState createState() => _AddSessionState();
}

class _AddSessionState extends State<AddSession> {
  DateTime selectedDate = DateTime.now();
  final FirebaseAuth auth = FirebaseAuth.instance;

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
  
  var _bpmChoice = 55;
  var _durationChoice = 15;
  var _userSched;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Add Session",
            style: TextStyle(color: Colors.teal[300],),
          ),
          leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
              color: Colors.teal[300]
          ),
          actions: [
            Container(
              margin: EdgeInsets.all(8),
              child: ElevatedButton(
                  onPressed: (){
                    bool go = false;
                    String patient_id = "";
                    var j=0;
                    //print(_userSched);
                    //print(_userSched.length);
                    for(var i=0; i<_userSched.length; i++){
                      if(_userSched[i] == '(' || _userSched[i] == ')'){
                        go = !go;
                        i++;
                      }
                      if(go){
                        patient_id = patient_id + _userSched[i];
                        //print(j);
                        j++;
                      }
                    }

                    Map <String,dynamic> schedule = {
                      "date": selectedDate,
                      "user_id": patient_id,
                      "bpm": _bpmChoice,      //shows the thread sequencing
                      "duration": _durationChoice,     //shows the training session associated with
                      "therapist_id": auth.currentUser.uid,
                      "done": false,
                      "date_completed": null
                    };
                    FirebaseFirestore.instance.collection("schedule").add(schedule);
                    Navigator.pop(context);

                  },
                  style: ElevatedButton.styleFrom(
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(7.0),),
                      primary: Colors.teal[300],
                      elevation: 0,
                      minimumSize: Size(10, 20)
                  ),
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  )
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFFF1EEEE),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.date_range_rounded, color: Colors.grey,),
              title: Text("${selectedDate.format('D, M j, Y')}"),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              leading: Icon(Icons.perm_contact_cal_rounded, color: Colors.grey,),
              title: DropdownButtonFormField(
                hint: Text("Patient"),
                value: _userSched,
                items: widget.patientList
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _userSched = val;
                  });
                },
              ),
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 20,),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text("BPM setting",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        color:Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('49 BPM'),
                    leading: Radio(
                      value: 49,
                      groupValue: _bpmChoice,
                      onChanged: (value) {
                        setState(() {
                          _bpmChoice = value;
                        });
                      },
                      activeColor: Colors.teal[300],
                    ),
                    onTap: (){
                      setState(() {
                        _bpmChoice = 49;
                      });
                    },
                  ),
                  ListTile(
                    title: const Text('55 BPM'),
                    leading: Radio(
                      value: 55,
                      groupValue: _bpmChoice,
                      onChanged: (value) {
                        setState(() {
                          _bpmChoice = value;
                        });
                      },
                      activeColor: Colors.teal[300],
                    ),
                    onTap: (){
                      setState(() {
                        _bpmChoice = 55;
                      });
                    },
                  ),
                  ListTile(
                    title: const Text('60 BPM'),
                    leading: Radio(
                      value: 60,
                      groupValue: _bpmChoice,
                      onChanged: (value) {
                        setState(() {
                          _bpmChoice = value;
                        });
                      },
                      activeColor: Colors.teal[300],
                    ),
                    onTap: (){
                      setState(() {
                        _bpmChoice = 60;
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text("Duration",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        color:Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('10 minutes'),
                    leading: Radio(
                      value: 10,
                      groupValue: _durationChoice,
                      onChanged: (value) {
                        setState(() {
                          _durationChoice = value;
                        });
                      },
                      activeColor: Colors.teal[300],
                    ),
                    onTap: (){
                      setState(() {
                        _durationChoice = 10;
                      });
                    },
                  ),
                  ListTile(
                    title: const Text('15 minutes'),
                    leading: Radio(
                      value: 15,
                      groupValue: _durationChoice,
                      onChanged: (value) {
                        setState(() {
                          _durationChoice = value;
                        });
                      },
                      activeColor: Colors.teal[300],
                    ),
                    onTap: (){
                      setState(() {
                        _durationChoice = 15;
                      });
                    },
                  ),
                  ListTile(
                    title: const Text('20 minutes'),
                    leading: Radio(
                      value: 20,
                      groupValue: _durationChoice,
                      onChanged: (value) {
                        setState(() {
                          _durationChoice = value;
                        });
                      },
                      activeColor: Colors.teal[300],
                    ),
                    onTap: (){
                      setState(() {
                        _durationChoice = 20;
                      });
                    },
                  ),
                ],
              ),
            )
          ],
        ),

      );
  }
}
