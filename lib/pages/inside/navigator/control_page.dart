import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:robo_friends/bluetooth/bluetooth.dart';
import 'package:robo_friends/pages/inside/scaffoldTemplate.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<StatefulWidget> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  @override
  Widget build(BuildContext context) {
    return InsideTemplate(
      title: 'Control',
      body: Container(
        color: const Color(0xffEFEFEF),
        child: Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: Icon(BluetoothConnection.devices.valueOrNull!.isNotEmpty
                ? Icons.bluetooth_audio
                : Icons.bluetooth_disabled),
            onPressed: () {
              Navigator.pushNamed(context, '/context/bluetooth_devices');
            },
          ),
        ),
      ),
      navigationBar: ENavigationBar.control,
      // actions: <Widget>[],
    );
  }
}
