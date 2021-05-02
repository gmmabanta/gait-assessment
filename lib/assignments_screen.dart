import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AssignmentScreen extends StatefulWidget {
  var uid;
  AssignmentScreen({this.uid});
  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {

  Future getData() async {
    QuerySnapshot qn = await FirebaseFirestore.instance.collection("/users/" + widget.uid +"/assignment/").get();
    return qn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Therapists Assignment",
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
                  return Text("Loading data...");
                } else if (snapshot.hasData){
                  final List<QueryDocumentSnapshot> documents = snapshot.data.docs;
                  return SingleChildScrollView(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: documents.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index){
                            return ListTile(
                              title: Text("${documents[index]['patient_id'].toString()}"),
                              subtitle: FutureBuilder(
                                future: FirebaseFirestore.instance.collection("users").where('role', isEqualTo: 'patient').get(),
                                builder: (context, snapshot){
                                  final List<QueryDocumentSnapshot> patient_doc = snapshot.data.docs;
                                  if(!snapshot.hasData){
                                    return Text("No existing data");
                                  }else if(snapshot.hasData){
                                    String f_name = "";
                                    String l_name = "";
                                    String u_id = "";
                                    for(var i=0; i<patient_doc.length; i++){
                                      if(documents[index]['patient_id'] == patient_doc[i]['user_id']){
                                        f_name = patient_doc[index]['first_name'];
                                        l_name = patient_doc[index]['last_name'];
                                        u_id = patient_doc[i]['user_id'];
                                        break;
                                      }
                                    }
                                    return Text("${f_name} ${l_name}");

                                  }
                                },
                              ),
                             // title: Text("${documents[index]['patient_id'].toString()}"),
                            );
                          })
                  );
                }
              }
          )
      ),
    );
  }
}

class ListAssignments extends StatefulWidget {
  var reference;
  ListAssignments({this.reference});
  @override
  _ListAssignmentsState createState() => _ListAssignmentsState();
}

class _ListAssignmentsState extends State<ListAssignments> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
