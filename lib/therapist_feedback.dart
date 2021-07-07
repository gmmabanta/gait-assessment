import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';


class TherapistFeedback extends StatefulWidget {
  var document;                                 //documents from the training query
  TherapistFeedback({this.document});

  @override
  _TherapistFeedbackState createState() => _TherapistFeedbackState();
}

class _TherapistFeedbackState extends State<TherapistFeedback> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Timestamp t;
  DateTime d;
  var xlabel;
  var session_id;
  bool _sent = false;
  List<bool> _showComment = List.generate(5000, (index) => false);
  List<bool> _editFeedback = List.generate(5000, (index) => false);

  //TextEditingController comment = TextEditingController();

  @override
  Widget build(BuildContext context) {

    var uid = widget.document[0]['user_id'];
    //var training_id = widget.document.id;
    //var session_id = widget.document[0]['session_id'];
    getCount(doc){
      return doc.length;
    }
    //var _showComment = List.generate(getCount(widget.document), (index) => false);

    Future getData() async {
      QuerySnapshot qn = await FirebaseFirestore.instance.collection("/users/" +uid +"/feedback/").orderBy('date', descending: true).get();
      return qn;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  //var _showComment = List.generate(snapshot.data.docs.length, (i) => false);
                  if(!snapshot.hasData){
                    return Text("Loading...");
                  } else if (snapshot.hasData){
                    final List<QueryDocumentSnapshot> feedback = snapshot.data.docs;

                    //print(_showComment);
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: feedback.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index){
                          TextEditingController comment = TextEditingController();
                          TextEditingController inputFeedback = TextEditingController();

                          if(feedback == null){
                            return Text("No sessions");
                          } else {
                            t = feedback[index]['date'];
                            d = t.toDate();
                            xlabel = d.format('M j, g:i A').toString();
                            return Column(
                              children: [
                                Card(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        _editFeedback[index]
                                          ? ListTile(
                                            dense: true,
                                              title: TextFormField(
                                                decoration: InputDecoration(
                                                    hintText: "Enter your feedback",
                                                    hintStyle: TextStyle(
                                                      fontSize: 14,
                                                    )
                                                ),
                                                controller: inputFeedback,
                                              ),
                                              trailing: IconButton(icon: Icon(
                                                Icons.check_rounded, color: Colors.teal[300], size: 28,),
                                                onPressed: (){
                                                  setState(() {
                                                    _editFeedback[index] = !_editFeedback[index];
                                                  });
                                                  Map <String,dynamic> updateFeedback = {
                                                    "date": DateTime.now(),
                                                    "user_id": feedback[index]['user_id'].toString(),
                                                    "therapist_id":auth.currentUser.uid,
                                                    //"user_name":,
                                                    "parent_id":feedback[index]['parent_id'].toString(),       //shows the thread sequencing
                                                    "session_id":feedback[index]['session_id'].toString(),     //shows the training session associated with
                                                    "content":inputFeedback.text,
                                                  };
                                                  FirebaseFirestore.instance.collection("users").doc(uid).collection("feedback").doc(feedback[index]['session_id'].toString()).set(updateFeedback);

                                                  inputFeedback.clear();
                                                },
                                              ),
                                            )
                                          : ListTile(
                                          leading: Icon(Icons.account_circle_rounded, size: 35),
                                          title: (xlabel == null) ? Text("Loading feedback...") : Text("${xlabel} | ${feedback[index]['therapist_name'].toString()}"),
                                          subtitle: (xlabel == null) ? Text("") : (feedback[index]['content'] == "") ? Text("Press this to check feedback") : Text("${feedback[index]['content'].toString()}"),
                                          onTap: (){
                                            setState(() {
                                              if(_showComment[index] == true){
                                                _showComment[index] = false;
                                              } else if (_showComment[index] == false){
                                                _showComment[index] = true;
                                              }
                                              //print("This is _showCOmment${index}: ${_showComment}");
                                              session_id = feedback[index]['session_id'];

                                            });
                                          },
                                          onLongPress: (){
                                            setState(() {
                                              _editFeedback[index] = !_editFeedback[index];
                                            });
                                          },
                                        ),
                                        Visibility(
                                          visible: _showComment[index],
                                            child: FutureBuilder(
                                              future: FirebaseFirestore.instance.collection("users").doc(uid).collection("feedback").doc(session_id).collection("comment").orderBy('date', descending: false).get(),
                                              builder: (context, snapshot){
                                                if(!snapshot.hasData){
                                                  return ListView(
                                                    scrollDirection: Axis.vertical,
                                                    children: [
                                                      SizedBox(height: 1,),
                                                      ListTile(
                                                        title: Text("No feedback yet"),
                                                      ),
                                                    ],
                                                  );
                                                } else if (snapshot.hasData){
                                                  var doc = snapshot.data.docs;
                                                  return ListView.builder(
                                                    scrollDirection: Axis.vertical,
                                                    itemCount: doc.length,
                                                    shrinkWrap: true,
                                                    itemBuilder: (context, index){
                                                      return Container(
                                                        margin: EdgeInsets.symmetric(horizontal: 10),
                                                        child: ListTile(
                                                          title: Text("${doc[index]['content']}"),
                                                          leading: auth.currentUser.uid == doc[index]['user_id'].toString() ? Icon(Icons.account_circle_rounded, size: 30, color: Colors.teal[300]) : Icon(Icons.account_circle_rounded, size: 30, color: Colors.grey[300]),

                                                        ),
                                                      );
                                                    }
                                                  );
                                                }
                                              }
                                            )
                                        ),
                                        Visibility(
                                          visible: _showComment[index],
                                          child: ListTile(
                                            dense: true,
                                            title: TextFormField(
                                              decoration: InputDecoration(
                                                  hintText: "Reply...",
                                                  hintStyle: TextStyle(
                                                    fontSize: 14,
                                                  )
                                              ),
                                              controller: comment,
                                            ),
                                            trailing: IconButton(icon: Icon(Icons.send_rounded, color: Colors.teal[300], size: 28,),
                                              onPressed: (){
                                                Map <String,dynamic> reply = {
                                                  "date": DateTime.now(),
                                                  "user_id": uid,
                                                  //"therapist_id":null,
                                                  //"user_name":,
                                                  "parent_id":feedback[index]['parent_id'].toString(),       //shows the thread sequencing
                                                  "session_id":feedback[index]['session_id'].toString(),     //shows the training session associated with
                                                  "content":comment.text,
                                                };
                                                FirebaseFirestore.instance.collection("users").doc(uid).collection("feedback").doc(feedback[index]['session_id'].toString()).collection("comment").add(reply);

                                                comment.clear();
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                ),
                              ],
                            );
                          }
                        }
                    );
                  }
                })
              ],
          )
        ),
    );
  }
}
