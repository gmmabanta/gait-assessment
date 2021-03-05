import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

enum BestTutorSite { javatpoint, w3schools, tutorialandexample }

class _SettingsScreenState extends State<SettingsScreen> {
  BestTutorSite _site = BestTutorSite.javatpoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
            color: Colors.teal[300]
        ),
        title: Text("Settings",
          style: TextStyle(color: Colors.teal[300],),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),

      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.only(top:20, bottom:20, right: 20),
            width: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: <Widget>[
                Text("Some setting"),
                ListTile(
                  title: const Text('www.javatpoint.com'),
                  leading: Radio(
                    value: BestTutorSite.javatpoint,
                    groupValue: _site,
                    onChanged: (BestTutorSite value) {
                      setState(() {
                        _site = value;
                      });
                    },
                    activeColor: Colors.teal[300],
                  ),

                ),
                ListTile(
                  title: const Text('www.w3school.com'),
                  leading: Radio(
                    value: BestTutorSite.w3schools,
                    groupValue: _site,
                    onChanged: (BestTutorSite value) {
                      setState(() {
                      _site = value;
                      });
                    },
                    activeColor: Colors.teal[300],
                  ),
                ),
                ListTile(
                  title: const Text('www.tutorialandexample.com'),
                  leading: Radio(
                    value: BestTutorSite.tutorialandexample,
                    groupValue: _site,
                    onChanged: (BestTutorSite value) {
                      setState(() {
                        _site = value;
                      });
                    },
                    activeColor: Colors.teal[300],

                  ),
                ),
              ]
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.only(top:20, bottom:20, right: 20),
            width: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
                children: <Widget>[
                  ListTile(
                    title: const Text('www.javatpoint.com'),
                    leading: Radio(
                      value: BestTutorSite.javatpoint,
                      groupValue: _site,
                      onChanged: (BestTutorSite value) {
                        setState(() {
                          _site = value;
                        });
                      },
                      activeColor: Colors.teal[300],
                    ),

                  ),
                  ListTile(
                    title: const Text('www.w3school.com'),
                    leading: Radio(
                      value: BestTutorSite.w3schools,
                      groupValue: _site,
                      onChanged: (BestTutorSite value) {
                        setState(() {
                          _site = value;
                        });
                      },
                      activeColor: Colors.teal[300],
                    ),
                  ),
                  ListTile(
                    title: const Text('www.tutorialandexample.com'),
                    leading: Radio(
                      value: BestTutorSite.tutorialandexample,
                      groupValue: _site,
                      onChanged: (BestTutorSite value) {
                        setState(() {
                          _site = value;
                        });
                      },
                      activeColor: Colors.teal[300],

                    ),
                  ),
                ]
            ),
          ),

        ],
      ),
    );
  }
}
