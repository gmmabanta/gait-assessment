import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'mainscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gait_assessment/main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String _email;
  String _password;

  Future<void> _createUser() async{
    try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password
      );
      print("User: $userCredential");
    } on FirebaseAuthException catch(e) {
      print("Error: ${e}");
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
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
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFF1EEEE),
        body: Container(

          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Login",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.teal[300],
                    fontWeight: FontWeight.w500,
                    fontSize: 20
                ),
              ),
              Container(
                  padding: EdgeInsets.all(30),
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20
                        ),
                      ),
                      /*
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                      ),
                      */
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          onChanged: (value) {
                            _email = value;
                          },
                          decoration: InputDecoration(
                              hintText: "Email"
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          onChanged: (value) {
                          _password = value;
                          },
                          decoration: InputDecoration(
                              hintText: "Password"
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                width: 80,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    border: Border.all(color: Colors.teal[300])

                                ),
                                child: Text("Sign up",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.teal[300]
                                  ),
                                )
                            ),
                            onTap: _createUser
                          ),

                          GestureDetector(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                width: 80,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.teal[300],
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                ),
                                child: Text("Login",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                )
                            ),
                            onTap: _login
                          ),

                        ],

                      ),

                    ],
                  )

              ),


            ],

          ),
        )

    );
  }
}


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFF1EEEE),
        body: Container(

          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Sign Up",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.teal[300],
                    fontWeight: FontWeight.w500,
                    fontSize: 20
                ),
              ),
              Container(
                  padding: EdgeInsets.all(30),
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Sign up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                width: 80,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    border: Border.all(color: Colors.teal[300])

                                ),
                                child: Text("Login",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.teal[300]
                                  ),
                                )
                            ),
                            onTap: () {
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>MainScreen()),
                              );
                            },
                          ),

                          GestureDetector(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                width: 80,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.teal[300],
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                ),
                                child: Text("Sign up",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                )
                            ),
                            onTap: () {
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>LoginScreen()),
                              );
                            },
                          ),

                        ],

                      ),

                    ],
                  )

              ),


            ],

          ),



        )

    );
  }
}
