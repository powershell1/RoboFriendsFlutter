import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../bluetooth/bluetooth.dart';
// import 'package:robo_friends/bluetooth/bluetooth.dart';

class BluetoothPages extends StatefulWidget {
  const BluetoothPages({super.key});

  @override
  State<StatefulWidget> createState() => _BluetoothPagesState();
}

class _BluetoothPagesState extends State<BluetoothPages> {
  late StreamSubscription<BluetoothAdapterState> _listenSubscription;

  /*
  @override
  void dispose() {
    super.dispose();
    FlutterBluePlus.connectedDevices.forEach((device) {
      device.disconnect();
    });
    listenSubscriptionDevice.forEach((subscription) {
      subscription.cancel();
    });
    listenSubscription.cancel();
    FlutterBluePlus.stopScan();
  }

   */

  /*
  @override
  void initState() {
    super.initState();
    _listenSubscription = FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.off) {
        _dialogBuilder(context);
      }
    });
  }
   */

  @override
  void dispose() {
    // _listenSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Pages'),
      ),
      body: StreamBuilder<List<BluetoothDevice>>(
        stream: BluetoothConnection.devices.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var snapshotData = snapshot.data![index];
                return ListTile(
                  title: Text(
                    snapshotData.name,
                    style:
                        FlutterBluePlus.connectedDevices.contains(snapshotData)
                            ? const TextStyle(color: Colors.green)
                            : const TextStyle(color: Colors.grey),
                  ),
                  subtitle: Text(snapshotData.remoteId.toString()),
                  onTap: () {
                    BluetoothConnection.connectDevice(snapshotData);
                  },
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
