import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:gait_assessment/view_patientresults.dart';


class SelectPatient extends StatefulWidget {
  @override
  _SelectPatientState createState() => _SelectPatientState();
}

class _SelectPatientState extends State<SelectPatient> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
              child: Text("Select Patient",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'patient').snapshots(),
                builder: (context, snapshot){
                  if(!snapshot.hasData){
                    return Text("Loading data...");
                  } else if (snapshot.hasData){
                    final documents = snapshot.data.docs;
                    int docLen = documents.length;
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: docLen,
                        shrinkWrap: true,
                        itemBuilder: (context, index){
                          print(index.toString());
                          var fname = documents[index]['first_name'].toString();
                          var lname = documents[index]['last_name'].toString();
                          var email = documents[index]['email'].toString();
                          return Container(
                            //margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
//                        width: 400
                            decoration: BoxDecoration(
                              //color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.account_circle_rounded,
                                  color: Colors.grey,
                                  size: 38),
                              title: Text("${fname} ${lname}"),
                              subtitle: Text("${email}",
                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),),
                              onTap: () {
                                Navigator.push(context,
                                    //add parameters
                                    MaterialPageRoute(builder: (context) => DetailPatient(detail_doc: documents[index])
                                ));
                              }),

                          );
                        }
                    );
                  }
                })
          ],
        )
      )
    );
  }
}

class DetailPatient extends StatefulWidget {
  final DocumentSnapshot detail_doc;        //documents under /users/uid
  DetailPatient({this.detail_doc});

  @override
  _DetailPatientState createState() => _DetailPatientState();
}

class _DetailPatientState extends State<DetailPatient> {
  var ave_step_time, cadence, total_steps, correct_steps, wrong_steps;
  var _showGraph = false;
  @override
  Widget build(BuildContext context) {
    var uid = widget.detail_doc['user_id'].toString();
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.detail_doc['first_name'].toString()} ${widget.detail_doc['last_name'].toString()}",
            style: TextStyle(fontSize: 21, color: Colors.teal[300], fontWeight: FontWeight.w500)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(icon: Icon(_showGraph ? Icons.show_chart_rounded : Icons.wysiwyg_rounded, size: 30,), onPressed: (){
              setState(() {
                _showGraph = !_showGraph;
              });
            })
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
              color: Colors.teal[300]
          ),
        ),
        backgroundColor: Color(0xFFFF1EEEE),
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, top: 10),
              child: Text(_showGraph ? "Session Logs" : "Summary",
                style: TextStyle(fontSize: 16,color: Colors.grey, fontWeight: FontWeight.w500),),
            ),
            Visibility(
              visible: !_showGraph,
              child: Container (
                child: ViewPatientResults(uid: uid)
              ),
            ),
            Visibility(
              visible: _showGraph,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('/users/'+uid+'/training/').orderBy('date', descending: true).snapshots(),
                  builder: (context, snapshot){
                    if(!snapshot.hasData){
                      return Text("Loading data...");
                    } else if (snapshot.hasData){
                      final documents = snapshot.data.docs;
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: documents.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index){
                                  ave_step_time = documents[index]['ave_step_time'];
                                  cadence = documents[index]['cadence'];
                                  total_steps = documents[index]['total_steps'];
                                  correct_steps = documents[index]['correct_steps'];
                                  wrong_steps = documents[index]['wrong_steps'];
                                  Timestamp t = documents[index]['date'];
                                  DateTime d = t.toDate();
                                  return Container(
                                      margin: EdgeInsets.only(left: 10, right: 10),
                                      decoration: BoxDecoration(
                                        //color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      child: ListTile(
                                        title: Text(d.format('F j'),
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        subtitle: Text(d.format('g:i A')),
                                      )
                                  );
                                }
                            ),
                          ],
                        )
                      );



                    }


                  }
              )
            )

          ],
        )


      ),
    );
  }
}
