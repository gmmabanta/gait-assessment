import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:gait_assessment/cadence_graph.dart';
import 'package:gait_assessment/therapist_feedback.dart';
import 'package:gait_assessment/totalsteps_bar.dart';
import 'package:gait_assessment/linegraph.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ViewPatientResults extends StatefulWidget {
  var uid;
  ViewPatientResults({this.uid});

  @override
  _ViewPatientResultsState createState() => _ViewPatientResultsState();
}

class _ViewPatientResultsState extends State<ViewPatientResults> {

  bool _viewAveStepTime = false;
  bool _viewCadence = false;
  bool _viewStep = false;
  bool _viewFeedback = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future getData() async {
    QuerySnapshot qn = await FirebaseFirestore.instance.collection("/users/" +widget.uid.toString()+"/training/").orderBy('date', descending: false).get();
    return qn;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Stack(
                  children: <Widget>[
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
                                title: Text('Average Step Time',
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16
                                  ),
                                ),
                                trailing: IconButton(
                                    icon: Icon(_viewAveStepTime ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                                    color: Colors.blueGrey,
                                    splashRadius: 28,
                                    onPressed: (){
                                    }),
                              ),
                            ),
                            onTap: (){
                            },
                          ),
                          Divider(height: 2, color: Colors.grey,),
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: ListTile(
                                dense: true,
                                title: Text('Cadence',
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16
                                  ),
                                ),
                                trailing: IconButton(
                                    icon: Icon(_viewCadence ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                                    color: Colors.blueGrey,
                                    splashRadius: 28,
                                    onPressed: (){
                                      setState(() {
                                      });
                                    }),
                              ),
                            ),
                            onTap: (){
                              setState(() {
                              });
                            },
                          ),
                          Divider(height: 2, color: Colors.grey,),
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: ListTile(
                                dense: true,
                                title: Text('Step Data',
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16
                                  ),
                                ),
                                trailing: IconButton(
                                    icon: Icon(_viewCadence ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                                    color: Colors.blueGrey,
                                    splashRadius: 28,
                                    onPressed: (){
                                      setState(() {
                                      });
                                    }),
                              ),
                            ),
                            onTap: (){
                              setState(() {
                              });
                            },
                          ),
                          Divider(height: 2, color: Colors.grey,),
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: ListTile(
                                dense: true,
                                title: Text('Therapist Feedback',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16
                                  ),
                                ),
                                trailing: IconButton(
                                    icon: Icon(_viewFeedback ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                                    color: Colors.black,
                                    splashRadius: 28,
                                    onPressed: (){
                                      setState(() {
                                        //_viewFeedback = !_viewFeedback;
                                      });
                                    }),
                              ),
                            ),
                            onTap: (){
                              setState(() {
                                //_viewFeedback = !_viewFeedback;
                              });
                            },
                          ),
                          Divider(height: 2, color: Colors.grey,),
                        ],
                      ),
                    ),
                  ]
              );
            } else if (snapshot.hasData){
              final List<QueryDocumentSnapshot> documents = snapshot.data.docs;
              return Stack(
                  children: <Widget>[
                    Container(
                      //margin: EdgeInsets.all(5),
                      child: Column(
                        children: <Widget>[
                          Container(
                              //padding: EdgeInsets.all(3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  GestureDetector(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      child: ListTile(
                                        dense: true,
                                        title: Text('Average Step Time',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16
                                          ),
                                        ),
                                        trailing: IconButton(
                                            icon: Icon(_viewAveStepTime ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                                            color: Colors.black,
                                            splashRadius: 28,
                                            onPressed: (){
                                              setState(() {
                                                _viewAveStepTime = !_viewAveStepTime;
                                              });
                                            }),
                                      ),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        _viewAveStepTime = !_viewAveStepTime;
                                      });
                                    },
                                  ),
                                  Visibility(
                                      visible: _viewAveStepTime,
                                      child: LineChartSample1(document: documents)
                                  ),
                                  Divider(height: 2, color: Colors.grey,indent: 15,endIndent: 15,),
                                  GestureDetector(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      child: ListTile(
                                        dense: true,
                                        title: Text('Cadence',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16
                                          ),
                                        ),
                                        trailing: IconButton(
                                            icon: Icon(_viewCadence ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                                            color: Colors.black,
                                            splashRadius: 28,
                                            onPressed: (){
                                              setState(() {
                                                _viewCadence = !_viewCadence;
                                              });
                                            }),
                                      ),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        _viewCadence = !_viewCadence;
                                      });
                                    },
                                  ),
                                  Visibility(
                                      visible: _viewCadence,
                                      child: CadenceGraph(document: documents)
                                  ),
                                  Divider(height: 2, color: Colors.grey,indent: 15,endIndent: 15,),
                                  GestureDetector(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      child: ListTile(
                                        dense: true,
                                        title: Text('Step Data',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16
                                          ),
                                        ),
                                        trailing: IconButton(
                                            icon: Icon(_viewStep ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                                            color: Colors.black,
                                            splashRadius: 28,
                                            onPressed: (){
                                              setState(() {
                                                _viewStep = !_viewStep;
                                              });
                                            }),
                                      ),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        _viewStep = !_viewStep;
                                      });
                                    },
                                  ),
                                  Visibility(
                                    visible: _viewStep,
                                    child: BarChartView(document: documents),
                                  ),
                                  Divider(height: 2, color: Colors.grey,indent: 15,endIndent: 15,),
                                  GestureDetector(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      child: ListTile(
                                        dense: true,
                                        title: Text('Therapist Feedback',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16
                                          ),
                                        ),
                                        trailing: IconButton(
                                            icon: Icon(_viewFeedback ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                                            color: Colors.black,
                                            splashRadius: 28,
                                            onPressed: (){
                                              setState(() {
                                                _viewFeedback = !_viewFeedback;
                                              });
                                            }),
                                      ),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        _viewFeedback = !_viewFeedback;
                                      });
                                    },
                                  ),
                                  Visibility(
                                      visible: _viewFeedback,
                                      child: TherapistFeedback(document: documents)
                                  ),
                                  Divider(height: 2, color: Colors.grey,indent: 15,endIndent: 15,),
                                ],
                              )
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ]
              );
            }
          }
      ),

    );
  }
}
