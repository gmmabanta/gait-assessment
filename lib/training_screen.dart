//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:date_time_format/date_time_format.dart';
import 'dart:math';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
//import 'package:gait_assessment/SelectBondedDevicePage.dart';
//import 'package:gait_assessment/SelectBondedDevicePage.dart' as options;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:gait_assessment/bt_dataentry.dart';
import 'package:gait_assessment/BluetoothDeviceListEntry.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

Random random = new Random();
final FirebaseAuth auth = FirebaseAuth.instance;
user_id(){
  final User user = auth.currentUser;
  final uid = user.uid;
  print(uid);
  return uid;
}

var _bpmChoice = 49;
var _trainingDuration = 10;

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
  int total_steps = random.nextInt(100), correct_steps = random.nextInt(70), wrong_steps = random.nextInt(30);
  int cadence = random.nextInt(100), ave_step_time = random.nextInt(60);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            /*
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
             */
            SizedBox(height: 10),
            /*FlatButton(
              onPressed: (){
                Map <String,dynamic> training_data= {
                  "date": DateTime.now(),
                  "user_id": user_id(),
                  "total_steps":total_steps.toInt(),
                  "correct_steps":correct_steps.toInt(),
                  "wrong_steps":wrong_steps.toInt(),
                  "cadence":cadence.toInt(),
                  "ave_step_time":ave_step_time.toInt(),
                };
                FirebaseFirestore.instance.collection("users").doc(user_id()).collection("training").add(training_data);
              },
              child: Text("Submit"),
              color: Colors.blueAccent,
            ),*/
            FlatButton(
              onPressed: () async{
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> ListTraining() ));
                },
              child: Text("Results"),
              color: Colors.blueAccent,
            )
          ],
        ),
      ),

    );
  }
}

class ListTraining extends StatefulWidget {
  @override
  _ListTrainingState createState() => _ListTrainingState();
}

class _ListTrainingState extends State<ListTraining> {

  Future getData() async {
    QuerySnapshot qn = await FirebaseFirestore.instance.collection("/users/" +user_id() +"/training/").get();
    return qn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF1EEEE),
      appBar: AppBar(
        title: Text("Training Results",
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
      body: FutureBuilder(
        future: getData(),
        builder: (_,snapshot){
        if(!snapshot.hasData){
          return Text("no data");
        }else{
          final documents = snapshot.data.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index){
            Timestamp t = documents[index]['date'];
            DateTime d = t.toDate();
              return Container(
                margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                padding: EdgeInsets.only(top: 20, bottom: 20, right: 25, left: 25),
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                     //Text(document["user_id"].toString()),
                    Text(d.format('F j'),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(d.format('g:i A')),




                  ],
                ),
              );
            },
          );

        }

      }),
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

class TrainingProgress extends StatefulWidget {
  //final BluetoothDevice server;

  @override
  _TrainingProgressState createState() => _TrainingProgressState();
}

enum _DeviceAvailability {
  no,
  maybe,
  yes,
}

class _DeviceWithAvailability extends BluetoothDevice {
  BluetoothDevice device;
  _DeviceAvailability availability;
  int rssi;

  _DeviceWithAvailability(this.device, this.availability, [this.rssi]);
}

class _TrainingProgressState extends State<TrainingProgress> {

  //Audio Player Variables
  Duration _duration = Duration(seconds: 1);
  Duration _position = Duration();
  AudioPlayer advancedPlayer;
  AudioCache audioCache;

  //Bluetooth Variables
  static final clientID = 0;
  BluetoothConnection connection;
  BluetoothDevice selectedDevice;

  String _messageBuffer = '';
  bool _getResults = false;

  final TextEditingController textEditingController = new TextEditingController();

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;

  var jsonData;


  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  void initPlayer(){
    advancedPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: advancedPlayer);

    advancedPlayer.durationHandler = (d) => setState((){
      _duration = d;
    });

    advancedPlayer.positionHandler = (p) => setState((){
      _position = p;
    });
  }

  @override
  void initBluetooth(){
    BluetoothConnection.toAddress(selectedDevice.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
      connection.input.listen((event) {
        var decoded = utf8.decode(event);
        print(decoded);
      }).onData((data) {
        print("RAW DATA:");
        print(utf8.decode(data));
        var dataDecode = utf8.decode(data);
        for(var i=0; i<dataDecode.length;i++){
          print(dataDecode[i]);
          if(dataDecode[i] == '\r'){
            break;
          } else {
            //keep appending
            if(dataDecode[i] == '{' ){
              _getResults = true;
            }
            if(_getResults){
              _messageBuffer = _messageBuffer + dataDecode[i];
            }
          }
        }
        if(_getResults){
          print("This is the message: ${_messageBuffer}");
          jsonData = jsonDecode(_messageBuffer);
          _getResults = false;
          _messageBuffer = '';
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  String localFilePath;
  bool _endTraining = false;
  bool _sendChecker = false;

  signalEndTraining(){
    if(_position.inSeconds.ceil() == 0){
      _endTraining = false;
    }
    else if(_position.inSeconds.ceil() >= _duration.inSeconds.ceil() - 3 ){
      _endTraining = true;
    } else{
      _endTraining = false;
    }
    return _position.inSeconds.toDouble();
  }

  bool _play = true;

  //Step Parameters Variables
  int total_steps = random.nextInt(100), correct_steps = random.nextInt(70), wrong_steps = random.nextInt(30);
  int cadence = random.nextInt(100), ave_step_time = random.nextInt(60);

  //Bluetooth Variables
  List<_DeviceWithAvailability> devices = List<_DeviceWithAvailability>();

  void _startChat(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ChatPage(server: server);
        },
      ),
    );
  }


  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;
    print("this is the buffer data:");
    print(buffer);

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        /*messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );

         */
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }


  }

  void _sendMessage(String text, BluetoothDevice device) async {
    print("This is the device withint _sendMessage:");
    print(device);
    //Send
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        var printMessage = utf8.encode(text);
        print(printMessage); //shows in utf8
        print(connection.toString()); //null
        connection.output.add(printMessage);
        await connection.output.allSent;

      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }

  Future<String> getDocId(DocumentReference value) async {

  }

  @override
  Widget build(BuildContext context) {
    var insert_data;
    var countdown = "";

    training_id (DocumentReference doc){
      insert_data = doc.id.toString();
      return insert_data;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Training",
          style: TextStyle(color: Colors.teal[300],),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.info_outline_rounded),
              onPressed: () async {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>Instructions()),
                );
                /*selectedDevice =
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          //List page
                          return SelectBondedDevicePage(checkAvailability: false);
                        },
                      ),
                    );*/
                //if what the list page returns is null, it doesnt go to the page
                //if (selectedDevice != null) {
                //  print('Connect -> selected ' + selectedDevice.address);
                //  _startChat(context, selectedDevice);
                //} else {
                //  print('Connect -> no device selected');
                //}
            }
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
            color: Colors.teal[300]
        ),
      ),
      backgroundColor: Color(0xFFFF1EEEE),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left:60, right:60, bottom: 40),
            child: Stack(
              children: <Widget>[
                SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 0,
                      maximum: _duration.inSeconds.toDouble(),
                      showLabels: false,
                      showTicks: false,
                      startAngle: 270,
                      endAngle: 270,
                      axisLineStyle: AxisLineStyle(
                        thickness: 0.15,
                        cornerStyle: CornerStyle.bothFlat,
                        color: Color(0xFFBCFD8DC),
                        thicknessUnit: GaugeSizeUnit.factor,
                      ),
                      pointers: <GaugePointer>[
                        RangePointer(
                            value: signalEndTraining(),
                            cornerStyle: CornerStyle.bothFlat,
                            width: 0.15,
                            sizeUnit: GaugeSizeUnit.factor,
                            color: Colors.teal[300]
                        )
                      ],
                    ),
                  ],

                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 107),
                    child: IconButton(
                      icon: Icon(isConnecting
                          ? Icons.bluetooth_connected
                          : _play
                            ? Icons.play_arrow_rounded
                            : _endTraining
                              ? Icons.check_circle_rounded
                              : Icons.stop_rounded),
                      onPressed: (){
                        setState(() {
                          if(isConnecting){
                            if( selectedDevice == null ){
                              //insert sending data code
                              print("There is none connected");
                              return showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("You're not connected"),
                                  content: Text("Connect your device to your phone."),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        selectedDevice =
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return SelectBondedDevicePage(checkAvailability: false);
                                            },
                                          ),
                                        );
                                      },
                                      child: Text("Settings",
                                        style: TextStyle(color: Colors.teal[300]),),
                                    ),
                                  ],
                                ),
                              );
                            }

                            print(selectedDevice.name);
                            initBluetooth();
                            //print(_bpmChoice);
                          }

                          if (isConnected){
                            print(selectedDevice.name);
                            //print(_bpmChoice);
                            //insert sending data code

                            if(_play){
                              //insert sending data code

                                countdown = "3";
                                Future.delayed(const Duration(seconds: 1), (){
                                  // count 3
                                  countdown = "2";
                                  Future.delayed(const Duration(seconds: 1), (){
                                    // count 3
                                    countdown = "1";
                                    Future.delayed(const Duration(seconds: 1), (){
                                      //audioCache.play('${_bpmChoice}'+'bpm_'+'${_trainingDuration}'+'min.mp3');
                                      //count Start
                                      countdown = "START!";
                                      _sendMessage('1/${_bpmChoice}/${_trainingDuration}', selectedDevice);
                                      Future.delayed(const Duration(milliseconds: 536), (){
                                        //count Start
                                        countdown = " ";
                                        audioCache.play('${_bpmChoice}'+'bpm_'+'${_trainingDuration}'+'min.mp3');
                                        _play = false;
                                      });
                                    });
                                  });
                                });



                            } else {
                                if(_endTraining){
                                  _sendMessage("2", selectedDevice);
                                  var uid = user_id();
                                  _sendChecker = true;

                                  if(jsonData != null){
                                    return showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Finished training"),
                                        content: Text("Here are your results:\nTotal Steps:${jsonData['total_steps'].toInt()}\nCorrect Steps:${jsonData['correct_steps'].toInt()}\nWrong Steps:${jsonData['wrong_steps'].toInt()}\nCadence: ${jsonData['cadence']}"),
                                        //content: Text("Here are your results:\nTotal Steps:${jsonData['total_steps'].toInt()}\nCorrect Steps:${jsonData['correct_steps'].toInt()}\nWrong Steps:${jsonData['wrong_steps'].toInt()}\nCadence: ${jsonData['cadence']}\nAve Step Time: ${jsonData['ave_step_time']}"),

                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () async {
                                              //Navigator.of(context).pop();
                                              //selectedDevice =
                                              //await Navigator.of(context).push(
                                                //MaterialPageRoute(
                                                  //builder: (context) {


                                                    Map <String,dynamic> training_data= {
                                                      "date": DateTime.now(),
                                                      "user_id": uid,
                                                      "total_steps":jsonData['total_steps'].toInt(),
                                                      "correct_steps":jsonData['correct_steps'].toInt(),
                                                      "wrong_steps":jsonData['wrong_steps'].toInt(),
                                                      "cadence":jsonData['cadence'],
                                                      //"ave_step_time":jsonData['ave_step_time'].toInt(),
                                                      "bpm":_bpmChoice,
                                                      "duration":_trainingDuration
                                                    };

                                                    var training = FirebaseFirestore.instance.collection("users").doc(uid).collection("training");
                                                    training.add(training_data).then((value) async {
                                                      //print("This is the data ${value.path}");
                                                      Map <String,dynamic> feedback = {
                                                        "date": DateTime.now(),
                                                        "patient_id": uid,
                                                        "therapist_id":"",
                                                        "therapist_name":"",
                                                        "parent_id":value.id,       //shows the thread sequencing
                                                        "session_id":value.id,                 //shows the training session associated with
                                                        "content":"",
                                                      };
                                                      FirebaseFirestore.instance.collection("users").doc(uid).collection("feedback").doc(value.id).set(feedback);

                                                      //print("SCHED DOC: ${docSched}");
                                                      Map <String,dynamic> updatedData = {
                                                        "date_completed": DateTime.now(),
                                                        "bpm": _bpmChoice,      //shows the thread sequencing
                                                        //"therapist_id": auth.currentUser.uid,
                                                        "done": true
                                                      };

                                                      var reference = docSched.toString();
                                                      var path = "";
                                                      print("REFERENCE: ${reference}");
                                                      //DocumentReference(schedule/9wHBm4kVpsBFRc1lZQqA)

                                                      for(var i=27; i<reference.length-1; i++){
                                                        path = path + reference[i].toString();
                                                      }
                                                      print('PATH: ${path}');

                                                      FirebaseFirestore.instance.collection("schedule").doc(path).set(updatedData);

                                                    });

                                                    //FirebaseFirestore.instance.runTransaction((Transaction myTransaction)  {
                                                    //  myTransaction.update(docSched, updatedData);
                                                    //});


                                                    Future.delayed(const Duration(seconds: 1), () {
                                                      jsonData = null;
                                                      Navigator.of(context).pop();
                                                      _sendChecker = false;

                                                    });
                                                  //},
                                                //),
                                              //);
                                            },
                                            child: Text("Finish",
                                              style: TextStyle(color: Colors.teal[300]),),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }

                                /*if(_endTraining){
                                  _sendMessage("2", selectedDevice);
                                  var uid = user_id();
                                  Future.delayed(const Duration(seconds: 2), (){

                                    return showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Here are your results"),
                                        content: (jsonData != null)
                                            ? Text("BPM:${jsonData['bpm'].toInt()}\nTotal Steps:${jsonData['total_steps'].toInt()}\nCorrect Steps:${jsonData['correct_steps'].toInt()}\nWrong Steps:${jsonData['wrong_steps'].toInt()}\nCadence: ${jsonData['cadence'].toDouble()}\nAve Step Time: ${jsonData['ave_step_time'].toDouble()}")
                                            : Text("BPM: 0\nTotal Steps: 0\nCorrect Steps: 0\nWrong Steps: 0 \nCadence: 0\nAve Step Time: 0"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text("Finish",
                                              style: TextStyle(color: Colors.teal[300]),),
                                            onPressed: () async {
                                              Map <String, dynamic> training_data = {
                                                "date": DateTime.now(),
                                                "user_id": uid,
                                                "total_steps": jsonData['total_steps'].toInt(),
                                                "correct_steps": jsonData['correct_steps'].toInt(),
                                                "wrong_steps": jsonData['wrong_steps'].toInt(),
                                                "cadence": jsonData['cadence'].toDouble(),
                                                "ave_step_time": jsonData['ave_step_time'].toDouble(),
                                                "bpm": jsonData['bpm'].toInt(),
                                              };
                                              var training = FirebaseFirestore
                                                  .instance.collection(
                                                  "users")
                                                  .doc(uid)
                                                  .collection("training");

                                              training.add(training_data).then((value) async {
                                                //print("This is the data ${value.path}");
                                                Map <String,
                                                    dynamic> feedback = {
                                                  "date": DateTime.now(),
                                                  "patient_id": uid,
                                                  "therapist_id": "",
                                                  "therapist_name": "",
                                                  "parent_id": value.id,
                                                  //shows the thread sequencing
                                                  "session_id": value.id,
                                                  //shows the training session associated with
                                                  "content": "",
                                                };
                                                FirebaseFirestore.instance
                                                    .collection("users").doc(
                                                    uid).collection(
                                                    "feedback")
                                                    .doc(value.id)
                                                    .set(feedback);

                                                //print("SCHED DOC: ${docSched}");
                                                Map <String,
                                                    dynamic> updatedData = {
                                                  "date_completed": DateTime
                                                      .now(),
                                                  "bpm": _bpmChoice,
                                                  //shows the thread sequencing
                                                  //"therapist_id": auth.currentUser.uid,
                                                  "done": true
                                                };

                                                  var reference = docSched
                                                      .toString();
                                                  var path = "";
                                                  print(
                                                      "REFERENCE: ${reference}");
                                                  //DocumentReference(schedule/9wHBm4kVpsBFRc1lZQqA)

                                                  for (var i = 27; i <
                                                      reference.length -
                                                          1; i++) {
                                                    path = path +
                                                        reference[i].toString();
                                                  }
                                                  print('PATH: ${path}');

                                                  FirebaseFirestore.instance
                                                      .collection("schedule")
                                                      .doc(path)
                                                      .set(updatedData);
                                                  jsonData = '';
                                                  Navigator.of(context).pop();


                                                });

                                                //Navigator.of(context).pop();

                                            }
                                          ),
                                        ],
                                      ),
                                    );
                                  });


                                }
                                */
                                else {
                                  advancedPlayer.stop();
                                  _play = true;
                                  _sendMessage("3", selectedDevice);
                                }
                            }
                          }
                        });
                      },
                      //icon: Icon(_play? Icons.play_arrow_rounded : Icons.pause_rounded),
                      color: Colors.teal[300],
                      iconSize: 120,
                    ),
                  )
                ),

              ],
            )
          ),
          SizedBox(height: 50,),
          Center(
            child: Text(countdown,
              style: TextStyle(color: Colors.teal[300],  fontSize: 30, fontWeight: FontWeight.w500)
            )
          ),
          SizedBox(height: 50,),
          Center(child: ((selectedDevice != null)
            ? isConnecting
              ? Text('Connecting to ' + selectedDevice.name + '...',
                style: TextStyle(color: Colors.grey[500]))
              : isConnected
                ? _endTraining
                  ? Text('Completed session',
                    style: TextStyle(color: Colors.grey[500]))
                  : (_sendChecker)
                    ? Text('Receiving data...\nPlease press the check button after 2 seconds.',
                      style: TextStyle(color: Colors.grey[500]))
                    :  Text('Ongoing session',
                      style: TextStyle(color: Colors.grey[500]))

              : Text('Disconnected from device',
                style: TextStyle(color: Colors.grey[500]))
            : Text('Disconnected',
              style: TextStyle(color: Colors.grey[500]))
          )),

        ],

      ),
    );
  }
}



//from SelectBondedDevicePage

class SelectBondedDevicePage extends StatefulWidget {
  /// If true, on page start there is performed discovery upon the bonded devices.
  /// Then, if they are not avaliable, they would be disabled from the selection.
  final bool checkAvailability;
  const SelectBondedDevicePage({this.checkAvailability = true});

  @override
  _SelectBondedDevicePage createState() => new _SelectBondedDevicePage();
}
//modal
//var _bpmChoice;
//var _trainingDuration;
var docSched;
class _SelectBondedDevicePage extends State<SelectBondedDevicePage> with WidgetsBindingObserver {
  List<_DeviceWithAvailability> devices = List<_DeviceWithAvailability>();

  // Availability
  StreamSubscription<BluetoothDiscoveryResult> _discoveryStreamSubscription;
  bool _isDiscovering;

  _SelectBondedDevicePage();

  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  @override

  @override
  void initState() {
    super.initState();
    ///
    WidgetsBinding.instance.addObserver(this);
    _getBTState();
    _stateChangeListener();

    ///
    _isDiscovering = widget.checkAvailability;

    if (_isDiscovering) {
      _startDiscovery();
    }

    // Setup a list of the bonded devices
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        devices = bondedDevices
            .map(
              (device) => _DeviceWithAvailability(
            device,
            widget.checkAvailability
                ? _DeviceAvailability.maybe
                : _DeviceAvailability.yes,
          ),
        ).toList();
      });
    });




  }

  _getBTState(){
    FlutterBluetoothSerial.instance.state.then((state){
      _bluetoothState = state;
      if(_bluetoothState.isEnabled){
        _listBondedDevices();
      }
      setState(() {

      });
    });
  }

  _stateChangeListener(){
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state){
      _bluetoothState = state;
      if(_bluetoothState.isEnabled){
        _listBondedDevices();
      } else {
        devices.clear();
      }
      print("State isEnabled: ${state.isEnabled}");
      setState(() {

      });
    });
  }

  _listBondedDevices(){
    FlutterBluetoothSerial.instance.getBondedDevices().then((List<BluetoothDevice> bondedDevices){
      devices = bondedDevices;
      setState(() {

      });
    });
  }

  void _restartDiscovery() {
    setState(() {
      _isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _discoveryStreamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
          setState(() {
            Iterator i = devices.iterator;
            while (i.moveNext()) {
              var _device = i.current;
              if (_device.device == r.device) {
                _device.availability = _DeviceAvailability.yes;
                _device.rssi = r.rssi;
              }
            }
          });
        });

    _discoveryStreamSubscription.onDone(() {
      setState(() {
        _isDiscovering = false;
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _discoveryStreamSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BluetoothDeviceListEntry> list = devices
        .map((_device) => BluetoothDeviceListEntry(
      device: _device.device,
      rssi: _device.rssi,
      enabled: _device.availability == _DeviceAvailability.yes,
      onTap: () {
        Navigator.of(context).pop(_device.device);
      },
    ))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Training settings',
          style: TextStyle(color: Colors.teal[300],),),
        actions: <Widget>[
          _isDiscovering
              ? FittedBox(
            child: Container(
              margin: new EdgeInsets.all(16.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.teal[300],
                ),
              ),
            ),
          )
              : IconButton(
            icon: Icon(Icons.replay),
            onPressed: _restartDiscovery,
            color: Colors.teal[300],
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
            color: Colors.teal[300]
        ),
      ),
      backgroundColor: Color(0xFFFF1EEEE),
      body: Container(
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text("BPM setting",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color:Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ListTile(
              title: const Text('49 BPM'),
              leading: Radio(
                value: 49,
                groupValue: _bpmChoice,
                onChanged: (value) {
                  setState(() {
                    _bpmChoice = value;
                    print(_bpmChoice);
                  });
                },
                activeColor: Colors.teal[300],
              ),
              onTap: (){
                setState(() {
                  _bpmChoice = 49;
                });
              },
            ),
            ListTile(
              title: const Text('55 BPM'),
              leading: Radio(
                value: 55,
                groupValue: _bpmChoice,
                onChanged: (value) {
                  setState(() {
                    _bpmChoice = value;
                    print(_bpmChoice);
                  });
                },
                activeColor: Colors.teal[300],
              ),
              onTap: (){
                setState(() {
                  _bpmChoice = 55;
                });
              },
            ),
            ListTile(
              title: const Text('60 BPM'),
              leading: Radio(
                value: 60,
                groupValue: _bpmChoice,
                onChanged: (value) {
                  setState(() {
                    _bpmChoice = value;
                    print(_bpmChoice);
                  });
                },
                activeColor: Colors.teal[300],
              ),
              onTap: (){
                setState(() {
                  _bpmChoice = 60;
                });
              },
            ),
            Divider(thickness: 1, color: Colors.grey[300], indent: 15,endIndent: 15,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text("Duration setting",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color:Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ListTile(
              title: const Text('1 minute (for testing)'),
              leading: Radio(
                value: 1,
                groupValue: _trainingDuration,
                onChanged: (value) {
                  setState(() {
                    _trainingDuration = value;
                    print(_trainingDuration);
                  });
                },
                activeColor: Colors.teal[300],
              ),
              onTap: (){
                setState(() {
                  _trainingDuration = 1;
                });
              },
            ),
            ListTile(
              title: const Text('10 minutes'),
              leading: Radio(
                value: 10,
                groupValue: _trainingDuration,
                onChanged: (value) {
                  setState(() {
                    _trainingDuration = value;
                    print(_trainingDuration);
                  });
                },
                activeColor: Colors.teal[300],
              ),
              onTap: (){
                setState(() {
                  _trainingDuration = 10;
                });
              },
            ),
            ListTile(
              title: const Text('15 minutes'),
              leading: Radio(
                value: 15,
                groupValue: _trainingDuration,
                onChanged: (value) {
                  setState(() {
                    _trainingDuration = value;
                    print(_trainingDuration);
                  });
                },
                activeColor: Colors.teal[300],
              ),
              onTap: (){
                setState(() {
                  _trainingDuration = 15;
                });
              },
            ),
            ListTile(
              title: const Text('20 minutes'),
              leading: Radio(
                value: 20,
                groupValue: _trainingDuration,
                onChanged: (value) {
                  setState(() {
                    _trainingDuration = value;
                    print(_trainingDuration);
                  });
                },
                activeColor: Colors.teal[300],
              ),
              onTap: (){
                setState(() {
                  _trainingDuration = 20;
                });
              },
            ),
            Divider(thickness: 1, color: Colors.grey[300], indent: 15,endIndent: 15,),
            SwitchListTile(
                title: Text("Enable Bluetooth"),
                value: _bluetoothState.isEnabled,
                onChanged: (bool value){
                  future() async{
                    if(value){
                      await FlutterBluetoothSerial.instance.requestEnable();
                    } else{
                      await FlutterBluetoothSerial.instance.requestDisable();
                    }
                    future().then((_){
                      setState(() {

                      });
                    });
                  }
                }
            ),
            ListTile(
              title: Text("Bluetooth Status"),
              subtitle: Text(_bluetoothState.toString()),
              trailing: IconButton(
                color: Colors.grey,
                icon: Icon(Icons.settings),
                onPressed: (){
                  FlutterBluetoothSerial.instance.openSettings();
                },
              ),
            ),
            //VerticalDivider(thickness: 2,color: Colors.black,),
            Divider(thickness: 1, color: Colors.grey[300], indent: 15,endIndent: 15,),

            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text("Select your device",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color:Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              child: list.isEmpty
                  ? Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Text("No connected devices",
                  style: TextStyle(
                    color:Colors.grey,
                  ),
                ),
              )
                  : Column(children: list),
            ),
            SizedBox(height: 100)
          ],
        ),
      ),
    );
  }
}



////////////////////////////////////

class Instructions extends StatefulWidget {
  @override
  _InstructionsState createState() => _InstructionsState();
}

class _InstructionsState extends State<Instructions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Training Instructions",
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
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Text("1. Connect Bluetooth",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color:Colors.blueGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                title: const Text('Press the Bluetooth button on the training screen. Connect by pressing Settings on the pop up.'),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Text("2. Select your training options (BPM and Duration)",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color:Colors.blueGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                title: const Text('Choose from the options for BPM and Duration. Default options are 49 BPM and 10 minutes'),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Text("3. Select the insole device 'HC-06'",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color:Colors.blueGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                title: const Text('You will be redirected back to the mainscreen. Wait for status to be Connected.'),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Text("4. Start walking",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color:Colors.blueGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                title: const Text('Start after the countdown'),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Text("5. End training by pressing the check",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color:Colors.blueGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                title: const Text("You will see your training results on a popup. Press 'Finish' to go back to the mainscreen."),
              ),
            ],
          ),
        )

    );
  }
}
