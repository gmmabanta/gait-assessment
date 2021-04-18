import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gait_assessment/mainscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gait_assessment/login_screen.dart';


//void main() async {
void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Main Menu',
      theme: ThemeData(
        primaryColor: Colors.teal[400],
        accentColor: Colors.grey[200],
      ),
      home: LandingScreen(),
    );
  }
}


class LandingScreen extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot){
        if(snapshot.hasError){
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

        if(snapshot.connectionState == ConnectionState.done){
          return StreamBuilder (
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.active){
                //User user = snapshot.data;

                if(!snapshot.hasData){
                  //Provider.of<UserData>(context).currentUserId = snapshot.data.uid;
                  //signup and login
                  return LoginScreen();
                } else {
                  //authenticated and logged in already
                    return MainScreen();
                }
              }
              return Scaffold(
                body: Center(
                  child: Text("Checking authentication..."),
                ),
              );
            }
          );
        }

        return Scaffold(
          body: Center(
            child: Text("Connecting to the app..."),
          ),
        );
      },
    );
  }
}
