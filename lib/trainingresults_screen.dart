import 'package:flutter/material.dart';
import 'package:gait_assessment/linegraph.dart';

class TrainingResultsScreen extends StatefulWidget {
  @override
  _TrainingResultsScreenState createState() => _TrainingResultsScreenState();
}

class _TrainingResultsScreenState extends State<TrainingResultsScreen> {

  int _dropStateTP = 0;
  double _heightTP = 0;
  bool _viewTP = false;

  int _dropStateRP = 0;
  double _heightRP = 0;
  bool _viewRP = false;

  @override
  Widget build(BuildContext context) {

    switch(_dropStateTP){
      case 0:
        _heightTP = 50;
        break;
      case 1:
        _heightTP = 400;
        break;
    }

    switch(_dropStateRP){
      case 0:
        _heightRP = 50;
        break;
      case 1:
        _heightRP = 400;
        break;
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
                child: Stack(
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
                                        if(_dropStateRP != 0){
                                          _dropStateRP = 0;
                                          _viewRP = !_viewRP;
                                        } else {
                                          _dropStateRP = 1;
                                          _viewRP = !_viewRP;
                                        }
                                      });
                                    },
                                  ),
                                  Visibility(
                                    visible: _viewRP,
                                    child: Card(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      color: Colors.white,
                                      elevation: 2,
                                      child: StepPercentage(),

                                  )
                                  ),

                                ],
                              )
                          ),
                          SizedBox(height: 15),
                          /*
                          Container(
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.all(6),
                              width: 400,
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.teal[300],
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text("RAS Parameters",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(15),
                                    width: 385,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Text("Schedule",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.teal[300],
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20
                                      ),
                                    ),

                                  ),

                                ],
                              )


                          ),

                           */
                        ],
                      ),


                    ),
                  ]
                )

              )
    );
  }
}
