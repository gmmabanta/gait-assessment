import 'package:flutter/material.dart';
import 'package:gait_assessment/linegraph.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gait_assessment/cadence_graph.dart';
import 'package:gait_assessment/therapist_feedback.dart';
import 'package:gait_assessment/totalsteps_bar.dart';
import 'package:date_time_format/date_time_format.dart';

class TrainingResultsScreen extends StatefulWidget {
  @override
  _TrainingResultsScreenState createState() => _TrainingResultsScreenState();
}

class _TrainingResultsScreenState extends State<TrainingResultsScreen> {
  bool _viewAveStepTime = false;
  bool _viewCadence = false;
  bool _viewStep = false;
  bool _viewFeedback = false;
  //bool _showLogs = true;
  @override
  Widget build(BuildContext context) {

    final FirebaseAuth auth = FirebaseAuth.instance;
    user_id(){
      final User user = auth.currentUser;
      final uid = user.uid;
      //print(uid);
      return uid;
    }

    Future getData() async {
      QuerySnapshot qn = await FirebaseFirestore.instance.collection("/users/" +user_id() +"/training/").orderBy('date', descending: false).get();
      return qn;
    }

    return Scaffold(
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
          /*actions: [
            IconButton(icon: Icon(
                _showLogs ? Icons.wysiwyg_rounded : Icons.show_chart_rounded),
                onPressed: (){
                  setState(() {
                    _showLogs = !_showLogs;
                  });
                })
          ],*/
        ),

        backgroundColor: Color(0xFFFF1EEEE),
        body: SingleChildScrollView(
                child: FutureBuilder(
                    future: getData(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        //if(!_showLogs){
                        //  return Text("This is it pancit");
                        //} else {
                          return Stack(children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(5),
                              child: Column(
                                children: <Widget>[
                                  GestureDetector(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      child: ListTile(
                                        dense: true,
                                        title: Text(
                                          'Average Step Time',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16),
                                        ),
                                        trailing: IconButton(
                                            icon: Icon(_viewAveStepTime
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down),
                                            color: Colors.black,
                                            splashRadius: 28,
                                            onPressed: () {}),
                                      ),
                                    ),
                                    onTap: () {},
                                  ),
                                  Divider(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      child: ListTile(
                                        dense: true,
                                        title: Text(
                                          'Cadence',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16),
                                        ),
                                        trailing: IconButton(
                                            icon: Icon(_viewCadence
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down),
                                            color: Colors.black,
                                            splashRadius: 28,
                                            onPressed: () {
                                              setState(() {});
                                            }),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {});
                                    },
                                  ),
                                  Divider(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      child: ListTile(
                                        dense: true,
                                        title: Text(
                                          'Step Data',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16),
                                        ),
                                        trailing: IconButton(
                                            icon: Icon(_viewCadence
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down),
                                            color: Colors.black,
                                            splashRadius: 28,
                                            onPressed: () {
                                              setState(() {});
                                            }),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {});
                                    },
                                  ),
                                  Divider(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      child: ListTile(
                                        dense: true,
                                        title: Text(
                                          'Therapist Feedback',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16),
                                        ),
                                        trailing: IconButton(
                                            icon: Icon(_viewFeedback
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down),
                                            color: Colors.black,
                                            splashRadius: 28,
                                            onPressed: () {
                                              setState(() {
                                                //_viewFeedback = !_viewFeedback;
                                              });
                                            }),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        //_viewFeedback = !_viewFeedback;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        //}
                      } else if (snapshot.hasData){
                          final List<QueryDocumentSnapshot> documents = snapshot.data.docs;
                          /*if(!_showLogs){
                          return StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('/users/'+user_id()+'/training/').orderBy('date', descending: true).snapshots(),
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
                          );
                          } */
                          //else {
                            return Stack(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.all(3),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              children: <Widget>[
                                                GestureDetector(
                                                  child: Container(
                                                    padding: EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    child: ListTile(
                                                      dense: true,
                                                      title: Text(
                                                        'Average Step Time (min)',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .w400,
                                                            fontSize: 16
                                                        ),
                                                      ),
                                                      trailing: IconButton(
                                                          icon: Icon(
                                                              _viewAveStepTime
                                                                  ? Icons
                                                                  .arrow_drop_up
                                                                  : Icons
                                                                  .arrow_drop_down),
                                                          color: Colors.black,
                                                          splashRadius: 28,
                                                          onPressed: () {
                                                            setState(() {
                                                              _viewAveStepTime =
                                                              !_viewAveStepTime;
                                                            });
                                                          }),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      _viewAveStepTime =
                                                      !_viewAveStepTime;
                                                    });
                                                  },
                                                ),
                                                Visibility(
                                                    visible: _viewAveStepTime,
                                                    child: LineChartSample1(
                                                        document: documents)
                                                ),
                                                Divider(height: 2,
                                                  color: Colors.grey,
                                                  indent: 15,
                                                  endIndent: 15,),
                                                GestureDetector(
                                                  child: Container(
                                                    padding: EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    child: ListTile(
                                                      dense: true,
                                                      title: Text(
                                                        'Cadence (steps/min)',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .w400,
                                                            fontSize: 16
                                                        ),
                                                      ),
                                                      trailing: IconButton(
                                                          icon: Icon(
                                                              _viewCadence
                                                                  ? Icons
                                                                  .arrow_drop_up
                                                                  : Icons
                                                                  .arrow_drop_down),
                                                          color: Colors.black,
                                                          splashRadius: 28,
                                                          onPressed: () {
                                                            setState(() {
                                                              _viewCadence =
                                                              !_viewCadence;
                                                            });
                                                          }),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      _viewCadence =
                                                      !_viewCadence;
                                                    });
                                                  },
                                                ),
                                                Visibility(
                                                    visible: _viewCadence,
                                                    child: CadenceGraph(
                                                        document: documents)
                                                ),
                                                Divider(height: 2,
                                                  color: Colors.grey,
                                                  indent: 15,
                                                  endIndent: 15,),
                                                GestureDetector(
                                                  child: Container(
                                                    padding: EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    child: ListTile(
                                                      dense: true,
                                                      title: Text('Step Data',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .w400,
                                                            fontSize: 16
                                                        ),
                                                      ),
                                                      trailing: IconButton(
                                                          icon: Icon(
                                                              _viewStep
                                                                  ? Icons
                                                                  .arrow_drop_up
                                                                  : Icons
                                                                  .arrow_drop_down),
                                                          color: Colors.black,
                                                          splashRadius: 28,
                                                          onPressed: () {
                                                            setState(() {
                                                              _viewStep =
                                                              !_viewStep;
                                                            });
                                                          }),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      _viewStep = !_viewStep;
                                                    });
                                                  },
                                                ),
                                                Visibility(
                                                  visible: _viewStep,
                                                  child: BarChartView(
                                                      document: documents),
                                                ),
                                                Divider(height: 2,
                                                  color: Colors.grey,
                                                  indent: 15,
                                                  endIndent: 15,),
                                                GestureDetector(
                                                  child: Container(
                                                    padding: EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    child: ListTile(
                                                      dense: true,
                                                      title: Text(
                                                        'Therapist Feedback',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .w400,
                                                            fontSize: 16
                                                        ),
                                                      ),
                                                      trailing: IconButton(
                                                          icon: Icon(
                                                              _viewFeedback
                                                                  ? Icons
                                                                  .arrow_drop_up
                                                                  : Icons
                                                                  .arrow_drop_down),
                                                          color: Colors.black,
                                                          splashRadius: 28,
                                                          onPressed: () {
                                                            setState(() {
                                                              _viewFeedback = !_viewFeedback;
                                                            });
                                                          }),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      _viewFeedback = !_viewFeedback;
                                                    });
                                                  },
                                                ),
                                                Visibility(
                                                    visible: _viewFeedback,
                                                    child: TherapistFeedback(document: documents)
                                                ),
                                                SizedBox(height: 5),
                                                Divider(height: 2,
                                                  color: Colors.grey,
                                                  indent: 15,
                                                  endIndent: 15,),
                                              ],
                                            )
                                        ),
                                        SizedBox(height: 15),
                                      ],
                                    ),
                                  ),
                                ]
                            );
                          //}
                        }
                      }
                ),

              )
    );
  }
}
