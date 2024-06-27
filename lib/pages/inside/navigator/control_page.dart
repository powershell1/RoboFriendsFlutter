import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:robo_friends/bluetooth/bluetooth.dart';
import 'package:robo_friends/joystick/control_pad_plus.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(BluetoothConnection.devices.valueOrNull!.isNotEmpty
                      ? Icons.bluetooth_audio
                      : Icons.bluetooth_disabled, size: kToolbarHeight / 2),
                  onPressed: () {
                    Navigator.pushNamed(context, '/context/bluetooth_devices');
                  },
                ),
              ),
              Column(
                children: [
                  JoystickView(
                    onDirectionChanged: (double degrees, double distance) {
                      //double leftMotor = cos(degrees * pi / 180);
                      //print(leftMotor-sin(degrees * pi / 180));
                    },
                  ),
                  const SizedBox(height: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(child: Container(color: Colors.red, width: 50, height: 50)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      navigationBar: ENavigationBar.control,
      // actions: <Widget>[],
    );
  }
}
