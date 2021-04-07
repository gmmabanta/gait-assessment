import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:gait_assessment/BluetoothDeviceListEntry.dart';
import 'package:gait_assessment/bt_dataentry.dart';
import 'package:gait_assessment/SelectBondedDevicePage.dart';

class BluetoothApp extends StatefulWidget {
  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> with WidgetsBindingObserver {

  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  List<BluetoothDevice> devices = List<BluetoothDevice>();

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getBTState();
    _stateChangeListener();
    //_listBondedDevices();
  }

  @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    if(state.index == 0){
      //resume
      if(_bluetoothState.isEnabled){
        _listBondedDevices();
      }

    }
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

  void _startChat(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ChatPage(server: server);
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bluetooth WORK"),),
      body: Container(
        child: Column(
          children: <Widget>[
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
              title: Text("Bluetooth STATUS"),
              subtitle: Text(_bluetoothState.toString()),
              trailing: RaisedButton(
                child: Text("Settings"),
                onPressed: (){
                  //opens Bluetooth Settings on the app
                  //used for pairing with devices
                  FlutterBluetoothSerial.instance.openSettings();
                },
              ),
            ),
            Expanded(
              child: ListView(
                children: devices.map((_device) => BluetoothDeviceListEntry(
                    device: _device,
                    enabled: true,
                    onTap: (){
                      print("Item");
                    },
                )).toList(),
              ),
            ),
            ListTile(
              title: RaisedButton(
                child: const Text('Connect to paired device to chat'),
                onPressed: () async {
                  final BluetoothDevice selectedDevice =
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return SelectBondedDevicePage(checkAvailability: false);
                      },
                    ),
                  );

                  if (selectedDevice != null) {
                    print('Connect -> selected ' + selectedDevice.address);
                    _startChat(context, selectedDevice);
                  } else {
                    print('Connect -> no device selected');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
