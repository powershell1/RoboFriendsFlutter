import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../../bluetooth/bluetooth.dart';
import '../../code_compiler.dart';
import '../../types/universal.dart';

class RotateMotor extends CodeBlock {
  RotateMotor();

  @override
  void compile(Map<String, dynamic> fullNode, {String? functionId}) async {
    Map<String, dynamic>? inputs = fullNode['inputs'];
    if (inputs == null || !inputs.containsKey('MOTOR')) {
      return;
    }
    dynamic rotation = universalDecoder(inputs['MOTOR']['block'], functionId: functionId);
    for (BluetoothCharacteristic characteristic in BluetoothConnection.characteristicsList) {
      // print(characteristic.uuid);
      if (!characteristic.properties.write) continue;
      await characteristic.write([0x00, rotation.toInt()]);
    }
    print("Rotated motor $rotation degrees");
    if (!fullNode.containsKey('next')) return;
    CodeCompiler.runBlock(fullNode['next']['block'], functionId: functionId);
  }
}