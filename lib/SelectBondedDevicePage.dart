import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:gait_assessment/BluetoothDeviceListEntry.dart';

class SelectBondedDevicePage extends StatefulWidget {
  /// If true, on page start there is performed discovery upon the bonded devices.
  /// Then, if they are not avaliable, they would be disabled from the selection.
  final bool checkAvailability;

  const SelectBondedDevicePage({this.checkAvailability = true});

  @override
  _SelectBondedDevicePage createState() => new _SelectBondedDevicePage();
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
        title: Text('Bluetooth settings',
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
              child: Text("Connected device",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color:Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: Text("No connected devices",
                        style: TextStyle(
                          color:Colors.grey,
                        ),
                      ),
                    )
                  : ListView(children: list),
            ),
          ],
        ),
      ),

    );

  }
}
