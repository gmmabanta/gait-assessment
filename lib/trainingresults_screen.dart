import 'package:flutter/material.dart';
import 'package:gait_assessment/linegraph.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gait_assessment/cadence_graph.dart';

class TrainingResultsScreen extends StatefulWidget {
  @override
  _TrainingResultsScreenState createState() => _TrainingResultsScreenState();
}

class _TrainingResultsScreenState extends State<TrainingResultsScreen> {

  //int _dropStateTP = 0;
  //double _heightTP = 0;
  //bool _viewTP = false;

  //int _dropStateRP = 0;
  //double _heightRP = 0;
  //bool _viewRP = false;


  bool _viewAveStepTime = false;
  bool _viewCadence = false;
  bool _viewTotal = false;
  //bool _viewCadence = false;

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
        ),
        backgroundColor: Color(0xFFFF1EEEE),
        body: SingleChildScrollView(
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
                                    /*
                          Container(
                            height: _heightTP,
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.teal[300],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.all(11),
                                    child: Text('Temporal Parameters',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17
                                      ),
                                    ),
                                  ),
                                  onTap: (){
                                    setState(() {
                                      if(_dropStateTP != 0){
                                        _dropStateTP = 0;
                                        _viewTP = !_viewTP;
                                      } else {
                                        _dropStateTP = 1;
                                        _viewTP = !_viewTP;
                                      }
                                    });
                                  },
                                ),
                                Visibility(
                                  visible: _viewTP,
                                  child: Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    color: Colors.white,
                                    elevation: 2,
                                    child: BarChartView()
                                ),
                                )
                              ],
                            )
                          ),*/
                                    SizedBox(height: 15),
                                    Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          color: Colors.teal[300],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            GestureDetector(
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                child: Text('RAS Parameters',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 17
                                                  ),
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
                                                child: Card(
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                  color: Colors.white,
                                                  elevation: 2,
                                                  //child: StepPercentage(),
                                                  child: Container(),
                                                )
                                            ),
                                          ],
                                        )
                                    ),
                                    SizedBox(height: 15),
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
                                margin: EdgeInsets.all(5),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(3),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          mainAxisAlignment: MainAxisAlignment.start,
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
                                                //child: Card(
                                                //  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                //  color: Colors.white,
                                                //  elevation: 0,
                                                  //child: StepPercentage(),
                                                //  child: LineChartSample1(document: documents),
                                                //)
                                            ),
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
                                              //child: Card(
                                              //  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                              //  color: Colors.white,
                                              //  elevation: 0,
                                              //child: StepPercentage(),
                                              //  child: LineChartSample1(document: documents),
                                              //)
                                            ),
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

              )
    );
  }
}
