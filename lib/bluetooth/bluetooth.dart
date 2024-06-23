import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logger/logger.dart';
import 'package:robo_friends/compiler_v2/compiler.dart';
import 'package:rxdart/rxdart.dart';

enum SensorType {
  none,
  ultrasonic,
  infrared,
  temperature,
  humidity,
  light,
  sound,
}

class CompilerStreamObject {
  final dynamic cso;
  CompilerStreamObject(this.cso);
}

class BluetoothConnection {
  BluetoothConnection();

  static BehaviorSubject<List<BluetoothDevice>> devices =
      BehaviorSubject.seeded([]);
  static List<BluetoothCharacteristic> characteristicsList = [];
  static var listenSubscription;
  static Map<SensorType, dynamic> sensorValues = {};
  static StreamController<Map<SensorType, dynamic>> sensorNotify = StreamController.broadcast();

  static StreamController<List<int>> compilerStream = StreamController.broadcast();

  // static var listenSubscriptionDevice = [];

  static void connectDevice(BluetoothDevice device) async {
    if (FlutterBluePlus.connectedDevices.contains(device)) {
      device.disconnect();
      return;
    } else if (FlutterBluePlus.connectedDevices.isNotEmpty) {
      for (var device in FlutterBluePlus.connectedDevices) {
        device.disconnect();
      }
    }

    var subscription =
        device.connectionState.listen((BluetoothConnectionState state) async {
      if (state == BluetoothConnectionState.disconnected) {
        if (CodeCompiler.isCompiling) {
          CodeCompiler.killCompiler();
        }
        // print("${device.disconnectReason?.code} ${device.disconnectReason?.description}");
        devices.add(FlutterBluePlus.connectedDevices.toList());
      }
    });

    device.cancelWhenDisconnected(subscription, delayed: true, next: true);

    await device.connect();
    devices.add(FlutterBluePlus.connectedDevices.toList());

    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      // print(service.uuid);
      List<BluetoothCharacteristic> characteristics =
          await service.characteristics;
      characteristicsList = characteristics;
      for (BluetoothCharacteristic characteristic in characteristics) {
        // print('----------------');
        // print(characteristic.uuid);
        // print(characteristic.properties);
        if (characteristic.properties.read) {
          // print(characteristic.properties);
          var valueSub = characteristic.lastValueStream.listen((value) {
            if (value.isEmpty) return;
            sensorValues[SensorType.values[value[0]]] = value[1];
            sensorNotify.add(sensorValues);
          });
          device.cancelWhenDisconnected(valueSub, delayed: true, next: true);
          if (!device.isDisconnected) {
            await characteristic.setNotifyValue(true);
          }
        } else if (characteristic.properties.write) {
          var btc = BluetoothConnection.compilerStream.stream.listen((data) {
            characteristic.write(data);
          });
          device.cancelWhenDisconnected(btc, delayed: true, next: true);
        };
        // when characteristic is changed
        // characteristic.write([0x12, 0x34]);
        // await characteristic.write([0x12, 0x34]);
      }
    }
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Bluetooth is off'),
          content: const Text(
            'Make sure that you allow bluetooth permission and turn on bluetooth\n'
                'Then restart the app.',
          ),
          actions: <Widget>[
            CupertinoButton(
              child: const Text(
                'ok',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void adapterStateListener(BluetoothAdapterState state) async {
  }

  static void startScans() async {
    FlutterBluePlus.setLogLevel(LogLevel.none, color: false);
    if (listenSubscription != null) {
      print("Already scanning...");
      return;
    }
    FlutterBluePlus.startScan(
      continuousUpdates: true,
      removeIfGone: const Duration(seconds: 3),
    );
    FlutterBluePlus.adapterState.listen((state) async {
      if (state == BluetoothAdapterState.off) {
        if (CodeCompiler.isCompiling) {
          CodeCompiler.killCompiler();
        }
        listenSubscription.cancel();
        listenSubscription = null;
        await Future.delayed(const Duration(seconds: 2));
        Logger().t('Trying to restart scan');
        startScans();
      }
    });
    listenSubscription =
        FlutterBluePlus.scanResults.listen((List<ScanResult> results) {
      // print(results);
      devices.add(results.map((result) => result.device).toList());
    });
  }
}
