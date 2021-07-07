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

  //bool _viewAveStepTime = false;
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
                          /*GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: ListTile(
                                dense: true,
                                title: Text('Average Step Time (s)',
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
                                    }),
                              ),
                            ),
                            onTap: (){
                            },
                          ),
                          Divider(height: 2, color: Colors.grey,),*/
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
                                    icon: Icon(_viewCadence ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                                    color: Colors.black,
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
                                title: Text('Cadence (steps/min)',
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
                                  /*GestureDetector(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      child: ListTile(
                                        dense: true,
                                        title: Text('Average Step Time (s)',
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
                                      child: Column(
                                        children: [
                                          LineChartSample1(document: documents),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Column(
                                                children: [
                                                  Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                                      child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: <Widget>[
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: <Widget>[
                                                                Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text("Ideal Step Time:",
                                                                        style: TextStyle(
                                                                            color: Colors.black87,
                                                                            fontWeight: FontWeight.w400,
                                                                            fontSize: 10
                                                                        ),
                                                                      ),
                                                                      Text("49 BPM: 1.224s",
                                                                        style: TextStyle(
                                                                            color: Colors.black87,
                                                                            fontWeight: FontWeight.w400,
                                                                            fontSize: 10
                                                                        ),
                                                                      ),
                                                                      Text("55 BPM: 1.09s",
                                                                        style: TextStyle(
                                                                            color: Colors.black87,
                                                                            fontWeight: FontWeight.w400,
                                                                            fontSize: 10
                                                                        ),
                                                                      ),
                                                                      Text("60 BPM: 1s",
                                                                        style: TextStyle(
                                                                            color: Colors.black87,
                                                                            fontWeight: FontWeight.w400,
                                                                            fontSize: 10
                                                                        ),
                                                                      ),
                                                                    ]
                                                                ),
                                                                SizedBox(width: 100),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                  children: <Widget>[
                                                                    Row(
                                                                      children: <Widget>[
                                                                        Text("Ave Step Time",
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
                                                                        Text("Ideal Step Time",
                                                                          style: TextStyle(
                                                                              color: Colors.black87,
                                                                              fontWeight: FontWeight.w400,
                                                                              fontSize: 10
                                                                          ),
                                                                        ),
                                                                        const SizedBox(width: 5),
                                                                        Icon(Icons.circle,
                                                                            size: 10,
                                                                            color: Colors.blueGrey.shade300

                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            const SizedBox(height: 10),
                                                          ]
                                                      )
                                                  )

                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                  ),
                                  Divider(height: 2, color: Colors.grey,indent: 15,endIndent: 15,),*/
                                  GestureDetector(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      child: ListTile(
                                        dense: true,
                                        title: Text('Step Percentage (%)',
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
                                        title: Text('Cadence (steps/min)',
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
