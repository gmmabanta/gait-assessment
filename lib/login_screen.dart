import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email;
  String _password;
  String _password1;
  String _fname;
  String _lname;
  String _errAlert = "";
  bool _error = false;
  String _role = "patient";


  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  user_id(){
    user = auth.currentUser;
    final uid = user.uid;
    print(uid);
    return uid;
  }

  Future<void> _createUser() async{
    try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password
      );

      Map <String,dynamic> user_data = {
        "email": _email,
        "first_name": _fname,
        "last_name": _lname,
        "user_id": user_id(),
        "role": _role,
      };

      //Map <String,dynamic> training_settings = {
      //  "bpm": 55,
      //  "duration": 10,
      //};

      FirebaseFirestore.instance.collection("users").doc(user_id()).set(user_data);
      //FirebaseFirestore.instance.collection("users").doc(user_id()).collection("training_settings").doc().set(training_settings);

      print("User: $userCredential");
    } on FirebaseAuthException catch(e) {
      print("Error: ${e}");
      if (e.code == 'weak-password') {
        setState(() {
          _errAlert = "The password provided is too weak.";
          _error = true;
        });
        print('The password provided is too weak.');

      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        setState(() {
          _errAlert = "The account already exists for that email.";
          _error = true;
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _login() async{
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email,
          password: _password
      );
      print("User: $userCredential");
    } on FirebaseAuthException catch(e) {
      print("Error: ${e}");
      setState(() {
        _errAlert = "Wrong username or password";
        _error = true;
      });
    } catch (e) {
      setState(() {
        _errAlert = "Wrong username or password";
        _error = true;
      });
    }
  }

  var _pageState = 0;
  Color _backgroundColor = Color(0xFFFF1EEEE);
  Color _primaryColor = Colors.teal[300];
  Color _pageHeader = Colors.teal[300];
  var _headerText;
  var _height;
  var _isObscurePW1 = true;
  var _isObscurePW2 = true;

  @override
  Widget build(BuildContext context) {
    switch(_pageState){
      case 0:
        _primaryColor = Colors.teal[300];
        _backgroundColor = Color(0xFFFF1EEEE);
        _pageHeader = Colors.teal[300];
        _headerText = "Login";
        _height = MediaQuery.of(context).size.height*0.45;
        break;
      case 1:
        _primaryColor = Colors.teal[300];
        _backgroundColor = Colors.teal[300];
        _pageHeader = Colors.white;
        _headerText = "Sign Up";
        _height = MediaQuery.of(context).size.height*0.70;
        break;
      case 2:
        _primaryColor = Colors.blueGrey;
        _backgroundColor = Colors.blueGrey;
        _pageHeader = Colors.white;
        _headerText = "Therapist Sign Up";
        _height = MediaQuery.of(context).size.height*0.70;
        break;
    }

    return Scaffold(
        backgroundColor: _backgroundColor,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height:80),
                Text(_headerText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: _pageHeader,
                      fontWeight: FontWeight.w500,
                      fontSize: 20
                  ),
                ),
                SizedBox(height: 20,),
                Center(
                  child: Container(
                      padding: EdgeInsets.all(30),
                      height: _height,
                      width: MediaQuery.of(context).size.width*0.88,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(_headerText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20
                            ),
                          ),
                          Visibility(
                            visible: (_pageState == 1) | (_pageState == 2) ? true: false,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                setState(() {
                                  _fname = value;
                                });
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.account_box, color: _primaryColor),
                                  labelText: 'First Name'
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (_pageState == 1) | (_pageState == 2) ? true: false,
                            child: TextFormField(
                              //controller: _lname,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                setState(() {
                                  _lname = value;

                                });
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.account_box, color: _primaryColor),
                                  labelText: 'Last Name'
                              ),
                            ),
                          ),
                          TextFormField(
                            //controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              setState(() {
                                _email = value;
                              });
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email_rounded, color: _primaryColor),
                              labelText: 'Email',
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              setState(() {
                                _password = value;
                                if(value == ""){
                                  _error = false;
                                }
                              });
                            },
                            obscureText: _isObscurePW1,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_rounded, color: _primaryColor),
                              labelText: 'Password',
                              suffixIcon: IconButton(icon: Icon(
                                  _isObscurePW1? Icons.visibility : Icons.visibility_off),
                                onPressed: (){
                                  setState(() {
                                    _isObscurePW1 = !_isObscurePW1;
                                  });
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (_pageState == 1) | (_pageState == 2) ? true: false,
                            child: TextFormField(
                              //controller: _password1,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                setState(() {
                                  _password1 = value;
                                  if(value == ""){
                                    _error = false;
                                  }
                                });
                              },
                              obscureText: _isObscurePW2,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_rounded, color: _primaryColor),
                                labelText: 'Confirm Password',
                                suffixIcon: IconButton(icon: Icon(
                                    _isObscurePW2? Icons.visibility : Icons.visibility_off),
                                  onPressed: (){
                                    setState(() {
                                      _isObscurePW2 = !_isObscurePW2;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (_pageState == 1) ? true : false,
                            child: TextButton(
                              child: Text("Sign up for therapists", style: TextStyle(color: Colors.grey),),
                              onPressed: (){
                                setState(() {
                                  _pageState = 2;
                                  _role = "therapist";
                                });
                              },
                            )
                          ),
                          Visibility(
                              visible: (_pageState == 2) ? true : false,
                              child: TextButton(
                                child: Text("Sign up for patients", style: TextStyle(color: Colors.grey),),
                                onPressed: (){
                                  setState(() {
                                    _pageState = 1;
                                    _role = "patient";
                                  });
                                },
                              )
                          ),
                          Visibility(
                            visible: _error ? true : false,
                            child: Text(_errAlert),
                          ),
                          SizedBox(height: 2,),
                          Visibility(
                            visible: (_pageState == 0) ? true : false,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ElevatedButton(
                                    onPressed: (){
                                      setState(() {
                                        _pageState = 1;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: new RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(30.0)),
                                      side: BorderSide(color: _primaryColor, width: 1.5),
                                      primary: Colors.white,
                                      elevation: 1.5,
                                      minimumSize: Size(120, 40),
                                    ),
                                    child: Text(
                                      "Sign up",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.teal[300]),
                                    )
                                ),
                                ElevatedButton(
                                    onPressed: _login,
                                    style: ElevatedButton.styleFrom(
                                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),),
                                        primary: _primaryColor,
                                        elevation: 1.5,
                                        minimumSize: Size(120, 40)
                                    ),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                    )
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: (_pageState == 1) | (_pageState == 2) ? true: false,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ElevatedButton(
                                    onPressed: (){
                                      setState(() {
                                        _pageState = 0;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: new RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(30.0)),
                                      side: BorderSide(color: _primaryColor, width: 1.5),
                                      primary: Colors.white,
                                      elevation: 1.5,
                                      minimumSize: Size(120, 40),
                                    ),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: _primaryColor),
                                    )
                                ),
                                ElevatedButton(
                                    onPressed: _createUser,
                                    style: ElevatedButton.styleFrom(
                                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),),
                                        primary: _primaryColor,
                                        elevation: 1.5,
                                        minimumSize: Size(120, 40)
                                    ),
                                    child: Text(
                                      "Sign up",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                    )
                                ),
                              ],

                            ),
                          ),
                        ],
                      )
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
