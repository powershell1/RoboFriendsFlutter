import 'package:logger/logger.dart';

import '../../../../../../bluetooth/bluetooth.dart';
import '../../compiler.dart';
import '../../blueprint.dart';

class ControlIf extends BlockFunctions {
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