import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bluetooth/bluetooth.dart';
import '../inside/scaffoldTemplate.dart';

class BluetoothDevicesList extends StatefulWidget {
  const BluetoothDevicesList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BluetoothDevicesList();
}

enum EDeviceType {
  primary,
  middle,
  high,
}

class EmulatedDevices extends BluetoothDevice {
  final String emuPlatformName;

  EmulatedDevices(this.emuPlatformName, {required super.remoteId});

  @override
  String get platformName => emuPlatformName;
}

class _BluetoothDevicesList extends State<BluetoothDevicesList> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  int craftedChild = 0;

  @override
  void initState() {
    super.initState();
    // double oldValue = 0;
    controller = AnimationController(
      duration: const Duration(seconds: 20000),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: pi*10000).animate(controller)
      ..addListener(() {
        /*
        if (oldValue > animation.value) {
          craftedChild = 0;
          // print('hell');
        }
        oldValue = animation.value;

         */
        // print(animation.value);
        setState(() {
          craftedChild = 0;
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget craftChildList(bool isConnect, EDeviceType type,
      {void Function()? onTap}) {
    craftedChild++;
    String enumString = type.toString();
    TextStyle spanStyle =
    GoogleFonts.inter(fontWeight: FontWeight.w500, height: 0);
    Color deviceEColor = type == EDeviceType.primary
        ? const Color(0xff00C34E)
        : (type == EDeviceType.middle
        ? const Color(0xffDD8500)
        : (type == EDeviceType.high
        ? const Color(0xffDD0000)
        : Colors.black));
    String deviceName = enumString.substring(enumString.indexOf('.') + 1);
    deviceName = deviceName[0].toUpperCase() + deviceName.substring(1);
    // print(enumString.substring(enumString.indexOf('.') + 1));
    // print((craftedChild*pi/4));
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Material(
          child: InkWell(
            highlightColor: Colors.white,
            onTap: onTap,
            child: Container(
              height: 100,
              color: const Color(0xff272727),
              child: Stack(
                children: [
                  Positioned(
                      top: 12,
                      left: 15,
                      child: RichText(
                        text: TextSpan(
                          text: 'Robo Friends\n',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                            height: 0,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: '(', style: spanStyle),
                            TextSpan(
                              text: deviceName,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                  color: deviceEColor),
                            ),
                            TextSpan(text: ')\n', style: spanStyle),
                            if (isConnect)
                              TextSpan(
                                  text: 'Connected',
                                  style: GoogleFonts.inter(
                                      fontSize: 17.5,
                                      fontWeight: FontWeight.normal,
                                      color: const Color(0xff008836))),
                          ],
                        ),
                      )),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SvgPicture.asset(
                      'assets/school_stage.svg',
                      placeholderBuilder: (context) => const SizedBox(),
                      color: deviceEColor.withAlpha(((sin(animation.value+(craftedChild*pi/4))+2)/3*255).toInt()),
                      height: 65,
                      width: 65,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InsideTemplate(
      title: 'Devices',
      body: ColoredBox(
        color: const Color(0xffEFEFEF),
        child: StreamBuilder<List<BluetoothDevice>>(
          stream: BluetoothConnection.devices.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<BluetoothDevice> devices = snapshot.data!;
              devices = devices
                  .where((element) =>
                      element.platformName.startsWith('RoboFriend#'))
                  .toList();
              List<BluetoothDevice> deviceConnected = FlutterBluePlus
                  .connectedDevices
                  .where((element) => !devices.contains(element))
                  .toList();
              devices.addAll(deviceConnected);
              /*
              devices.add(
                EmulatedDevices(
                  'RoboFriend#1',
                  remoteId: const DeviceIdentifier('emu1'),
                ),
              );
              devices.add(
                EmulatedDevices(
                  'RoboFriend#2',
                  remoteId: const DeviceIdentifier('emu2'),
                ),
              );
              devices.add(
                EmulatedDevices(
                  'RoboFriend#3',
                  remoteId: const DeviceIdentifier('emu3'),
                ),
              );
               */
              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: ListView.builder(
                  clipBehavior: Clip.none,
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    var snapshotData = devices[index];
                    int deviceTypeIndex = int.parse(snapshotData.platformName[
                            snapshotData.platformName.length - 1]) -
                        1;
                    return craftChildList(
                        FlutterBluePlus.connectedDevices.contains(snapshotData),
                        EDeviceType.values[deviceTypeIndex], onTap: () {
                      BluetoothConnection.connectDevice(snapshotData);
                    });
                  },
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      actions: const [],
    );
  }
}
