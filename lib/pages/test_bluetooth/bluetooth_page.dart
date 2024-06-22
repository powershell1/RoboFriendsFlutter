import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../pages/inside/inside_template.dart';

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

Widget craftChildList(bool isConnect, EDeviceType type) {
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
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 90,
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
                color: deviceEColor,
                height: 60,
                width: 60,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _BluetoothDevicesList extends State<BluetoothDevicesList> {
  static const List<EDeviceType> devices = [
    EDeviceType.primary,
    EDeviceType.middle,
    EDeviceType.high,
  ];

  @override
  Widget build(BuildContext context) {
    return InsideTemplate(
      title: 'Devices',
      body: ColoredBox(
        color: const Color(0xffEFEFEF),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: ListView.builder(
            clipBehavior: Clip.none,
            itemCount: devices.length,
            itemBuilder: (context, index) {
              return craftChildList(index == 0, devices[index]);
            },
          ),
        ),
      ),
      actions: const [],
    );
  }
}
