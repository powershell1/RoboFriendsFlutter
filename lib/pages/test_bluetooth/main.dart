import 'package:flutter/material.dart';

class TestBluetooth extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestBluetoothState();
}

class _TestBluetoothState extends State<TestBluetooth> {
  void toCodeIDE() {
    Navigator.pushNamed(context, '/context/code_ide');
  }

  void toBluetoothDevices() {
    Navigator.pushNamed(context, '/context/bluetooth_devices');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(onPressed: toCodeIDE, child: const Text('To Code IDE')),
            TextButton(onPressed: toBluetoothDevices, child: const Text('To Bluetooth Devices')),
          ],
        ),
      ),
    );
  }
}