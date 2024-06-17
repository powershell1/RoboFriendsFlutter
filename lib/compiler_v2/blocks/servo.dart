import 'dart:developer';

import 'package:logger/logger.dart';
import '../../../../../../bluetooth/bluetooth.dart';

import '../blueprint.dart';
import '../compiler.dart';

class RotateServo extends BlockFunctions {
  @override
  void runCode() async {
    // print(BlocksBlueprint.storedVariable);
    if (node.containsKey('inputs')) {
      Map<String, dynamic> blocks = fieldsDecoder(node['inputs']['MOTOR']);
      BlockFunctions? blockType = await CodeCompiler.initBlock(blocks);
      if (blockType == null) return;
      dynamic returnVar = await blockType.runCode();
      if (returnVar is num) {
        BluetoothConnection.compilerStream.sink.add([0, returnVar.toInt()%180]);
        // log('Rotating servo by $returnVar degrees');
      } else {
        Logger().w('Invalid input for servo rotation ($returnVar)');
      }
    }
    await super.runCode();
  }
}