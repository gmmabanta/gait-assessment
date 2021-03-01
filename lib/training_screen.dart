import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gait_assessment/mainscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class TrainingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Training",
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

      body: Container(
        margin: EdgeInsets.all(60),
        child: ListPage(),
        //GestureDetector(
        //  child: Container(
        //    decoration: BoxDecoration(
        //        color: Colors.pink
        //    ),
        //    child: Text("This is a training screen"),

        //  ),
        //  onTap: () {
        //    Navigator.push(context,
        //      MaterialPageRoute(builder: (context)=>MainScreen()),
        //    );
        //  },
        ),
        
      //),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  TextEditingController sampledata1 = new TextEditingController();
  TextEditingController sampledata2 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            TextFormField(
              controller: sampledata1,
              decoration: InputDecoration(
                hintText: "sample data 1"
              ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: sampledata2,
              decoration: InputDecoration(
                  hintText: "sample data 1"
              ),
            ),
            SizedBox(height: 10,),
            FlatButton(
              onPressed: (){
                Map <String,dynamic> data= {"field1":sampledata1.text, "field2":sampledata2.text};
                FirebaseFirestore.instance.collection("posts").add(data);
              },
              child: Text("Submit"),
              color: Colors.blueAccent,
            ),
            FlatButton(
              onPressed: () async{
                DocumentSnapshot variable = await FirebaseFirestore.instance.collection("posts").doc("post1").get();

                print(variable['field1']);
              },
              child: Text("get data"),
              color: Colors.blueAccent,
            ),
            FlatButton(
              onPressed: () async{
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> alldata() ));
                },
              child: Text("get all data"),
              color: Colors.blueAccent,
            )
          ],
        ),
      ),

    );
  }
}

class alldata extends StatefulWidget {
  @override
  _alldataState createState() => _alldataState();
}

class _alldataState extends State<alldata> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("all data"),

      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Text("no value");

          }
          return Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: ListView(
                children: snapshot.data.docs.map((document){
                  return Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(30),
                      width: 400,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Text(document["field1"])
                  );

                }).toList(),
              )
          );
        },
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

