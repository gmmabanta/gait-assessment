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
      home: AuthenticationWrapper(),

    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class RegisterEmailSection extends StatefulWidget {
  final String title = 'Registration';

  @override
  _RegisterEmailSectionState createState() => _RegisterEmailSectionState();
}

class _RegisterEmailSectionState extends State<RegisterEmailSection> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
