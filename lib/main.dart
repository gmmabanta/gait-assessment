import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'mainscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Main Menu',
      theme: ThemeData(
        primaryColor: Colors.teal[400],
        accentColor: Colors.grey[200],
      ),
    //  home: MainScreen(),
      home: LoginScreen(),

    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                    Text("Sign in",
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
                              child: Text("Sign up",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.teal[300]
                                ),
                              )
                          ),
                          onTap: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context)=>SignUpScreen()),
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
                              child: Text("Sign in",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              )
                          ),
                          onTap: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context)=>MainScreen()),
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
                      Text("Sign in",
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
                                child: Text("Sign in",
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
