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
      int servo = int.parse(node['fields']['SERVO']);
      BlockFunctions? blockType = await CodeCompiler.initBlock(blocks);
      if (blockType == null) return;
      dynamic returnVar = await blockType.runCode();
      if (returnVar is num) {
        BluetoothConnection.compilerStream.sink.add([servo, returnVar.toInt()%180]);
        // log('Rotating servo by $returnVar degrees');
      } else {
        Logger().w('Invalid input for servo rotation ($returnVar)');
      }
    }
    await super.runCode();
  }
}

class SetMotor extends BlockFunctions {
  @override
  void runCode() async {
    // print(BlocksBlueprint.storedVariable);
    if (node.containsKey('inputs')) {
      Map<String, dynamic> blocks = fieldsDecoder(node['inputs']['SPEED']);
      int motor = int.parse(node['fields']['MOTOR']);
      BlockFunctions? blockType = await CodeCompiler.initBlock(blocks);
      if (blockType == null) return;
      dynamic returnVar = await blockType.runCode();
      if (returnVar is num) {
        BluetoothConnection.compilerStream.sink.add([motor, returnVar.toInt()]);
        // log('Rotating servo by $returnVar degrees');
      } else {
        Logger().w('Invalid input for servo rotation ($returnVar)');
      }
    }
    await super.runCode();
  }
}

class UltrasonicGet extends BlockFunctions {
  @override
  Future<num> runCode() async {
    await super.runCode();
    // print(BluetoothConnection.sensorValues);
    return BluetoothConnection.sensorValues[SensorType.ultrasonic] ?? 0;
  }
}

class ToneSet extends BlockFunctions {
  @override
  void runCode() async {
    if (node.containsKey('inputs')) {
      Map<String, dynamic> blocks = fieldsDecoder(node['inputs']['TONE']);
      BlockFunctions? blockType = await CodeCompiler.initBlock(blocks);
      if (blockType == null) return;
      dynamic returnVar = await blockType.runCode();
      if (returnVar is num) {
        BluetoothConnection.compilerStream.sink.add([4, returnVar.toInt()]);
        // log('Setting tone to $returnVar');
      } else {
        Logger().w('Invalid input for tone setting ($returnVar)');
      }
    }
    await super.runCode();
  }
}

class LedSet extends BlockFunctions {
  @override
  void runCode() async {
    if (node.containsKey('fields')) {
      String led = node['fields']['LED'];
      BluetoothConnection.compilerStream.sink.add([7, int.parse(led)]);
    }
    await super.runCode();
  }
}