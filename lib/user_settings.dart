import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/widgets.dart';
import 'package:gait_assessment/assignments_screen.dart';
import 'package:gait_assessment/mainscreen.dart';
import 'package:gait_assessment/view_patientresults.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
final FirebaseAuth auth = FirebaseAuth.instance;

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  var user_id = auth.currentUser.uid;
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
                  child: Text("Users",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('users').where('user_id', isNotEqualTo: user_id).snapshots(),
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
                              var role = documents[index]['role'].toString();
                              var user_id = documents[index]['user_id'].toString();
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
                                    subtitle: Text("${capitalize(role)} | ${email}",
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),),
                                    onTap: () {
                                      Navigator.push(context,
                                          //add parameters
                                          MaterialPageRoute(builder: (context) => DetailUser(detail_doc: documents[index])
                                          ));
                                    }),
                                /*Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.account_circle_rounded,
                                  color: Colors.grey,
                                  size: 38),
                              title: Text("${fname} ${lname}"),
                              subtitle: Text("${email}",
                                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),),
                              onTap: (){

                              },
                            ),

                          ],
                        ),

                         */
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

class DetailUser extends StatefulWidget {
  final DocumentSnapshot detail_doc;
  DetailUser({this.detail_doc});

  @override
  _DetailUserState createState() => _DetailUserState();
}

class _DetailUserState extends State<DetailUser> {
  var ave_step_time, cadence, total_steps, correct_steps, wrong_steps;
  var _showGraph = true;
  var _showAssignments = true;
  double _textSize = 15;

  bool editUserInfo = false;
  String roleUpdate;
  String firstName;
  String lastName;
  List<String> roles = ['patient', 'therapist'];

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
            /*actions: [
              IconButton(
               icon: Icon(Icons.delete_outline_rounded, color: Colors.teal[300]),
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Are you sure?"),
                      content: Text("All user data will be deleted."),
                      actions: <Widget>[
                        TextButton(
                          onPressed: ()  {
                            Navigator.of(context).pop();
                          },
                          child: Text("Back",
                            style: TextStyle(color: Colors.grey[500]),),
                        ),
                        TextButton(
                          onPressed: ()  {
                            //FirebaseUser user = await FirebaseAuth.instance.
                            FirebaseFirestore.instance.collection("users").doc(uid).delete().then((_){
                              // delete account on authentication after user data on database is deleted

                            });
                            /*Navigator.of(context).pop();
                            selectedDevice =
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return SelectBondedDevicePage(checkAvailability: false);
                                },
                              ),
                            );*/
                          },
                          child: Text("Delete",
                            style: TextStyle(color: Colors.teal[300]),),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],

             */
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
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: editUserInfo
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text("User Information",
                              style: TextStyle(fontSize: 16,color: Colors.grey, fontWeight: FontWeight.w500)),
                          Row(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.save),
                                  onPressed: (){
                                    Map <String,dynamic> updatedUserInfo = {
                                      "role": (roleUpdate == null) ? widget.detail_doc['role'].toString() : roleUpdate,
                                      "first_name": (firstName == null) ? widget.detail_doc['first_name'].toString() : firstName,      //shows the thread sequencing
                                      "last_name": (lastName == null) ? widget.detail_doc['last_name'].toString() : lastName
                                    };

                                    FirebaseFirestore.instance.collection("users").doc(uid).set(updatedUserInfo, SetOptions(merge: true));
                                    setState(() {
                                      editUserInfo = !editUserInfo;
                                    });
                                  }
                              ),
                              IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: (){
                                    setState(() {
                                      editUserInfo = !editUserInfo;
                                    });

                                  }
                              ),
                            ],
                          ),

                        ],
                      )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("User Information",
                            style: TextStyle(fontSize: 16,color: Colors.grey, fontWeight: FontWeight.w500)),
                        IconButton(
                            icon: Icon(Icons.edit_rounded),
                            onPressed: (){
                              setState(() {
                                editUserInfo = !editUserInfo;
                              });
                            }
                        )
                      ],
                    )
              ),
              Visibility(
                visible: !editUserInfo,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Name",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
                      Text("${widget.detail_doc['first_name'].toString()} ${widget.detail_doc['last_name'].toString()}",
                          style: TextStyle(color: Colors.black, fontSize: _textSize)),
                      SizedBox(height: 13,),
                      Text("Role",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
                      Text("${widget.detail_doc['role'].toString()}",
                          style: TextStyle(color: Colors.black, fontSize: _textSize)
                      ),
                      SizedBox(height: 13,),
                      Text("User ID",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
                      Text("${widget.detail_doc['user_id'].toString()}",
                          style: TextStyle(color: Colors.black, fontSize: _textSize)
                      ),
                    ],
                  ),
                )
              ),
              Visibility(
                  visible: editUserInfo,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("First Name",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
                        TextFormField(
                          //controller: firstName,
                          initialValue: widget.detail_doc['first_name'].toString(),
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 14,
                              )
                          ),
                          onChanged: (value){
                            firstName = value;
                          },
                        ),
                        SizedBox(height: 13,),
                        Text("Last Name",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
                        TextFormField(
                          //controller: lastName,
                          initialValue: widget.detail_doc['last_name'].toString(),
                        ),
                        SizedBox(height: 13,),
                        Text("Role",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
                        DropdownButtonFormField(
                          hint: Text("${widget.detail_doc['role'].toString()}"),
                          value: roleUpdate,
                          items: roles.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              roleUpdate = val;
                            });
                          },
                        ),

                        SizedBox(height: 13,),
                        Text("User ID",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
                        SizedBox(height: 13,),
                        Text("${widget.detail_doc['user_id'].toString()}",
                            style: TextStyle(color: Colors.black, fontSize: _textSize)
                        ),
                      ],
                    ),
                  )
              ),
              Visibility(
                visible: (widget.detail_doc['role'].toString() == 'patient') ? true : false,
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_showGraph ? "Session Logs" : "Summary",
                          style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),),
                        IconButton(icon: Icon(_showGraph ? Icons.show_chart_rounded : Icons.wysiwyg_rounded, size: 30,), onPressed: (){
                          setState(() {
                            _showGraph = !_showGraph;
                          });
                        })
                      ],
                    )
                ),
              ),
              Visibility(
                visible: !_showGraph,
                child: Container (
                    child: ViewPatientResults(uid: uid),
                ),
              ),
              Visibility(
                  visible: (widget.detail_doc['role'].toString() == 'patient') ? _showGraph : false,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('/users/'+uid+'/training/').orderBy('date', descending: true).snapshots(),
                      builder: (context, snapshot){
                        if(!snapshot.hasData){
                          return Text("Loading data...");
                        } else if  (snapshot.hasData){
                          final documents = snapshot.data.docs;
                          return ListView.builder(
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
                          );
                        }
                      }
                  )
              ),
              Visibility(
                visible: (widget.detail_doc['role'].toString() == 'therapist') ? _showAssignments : false,
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height: 13,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Therapist Assignments",
                                style: TextStyle(fontSize: 16,color: Colors.grey, fontWeight: FontWeight.w500)),
                            /*IconButton(
                                icon: Icon(Icons.edit_rounded),
                                onPressed: (){
                                  setState(() {
                                    //_showAssignments = !_showAssignments;
                                  });
                                }
                            )*/
                          ],
                        ),
                        //Screen(uid: uid),
                      ],
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: ListAssignments(uid: uid),
              )

            ],
          )


      ),
    );
  }
}
