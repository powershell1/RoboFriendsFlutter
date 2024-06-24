import 'package:logger/logger.dart';

import '../../../../../../bluetooth/bluetooth.dart';
import '../../compiler.dart';
import '../../blueprint.dart';

class ControlIf extends BlockFunctions {
  @override
  void runCode() async {
    // print(BlocksBlueprint.storedVariable);
    Map<String, dynamic>? inputs = node['inputs'];
    if (inputs != null && inputs.isNotEmpty) {
      Map<String, dynamic>? extraState = node['extraState'];
      bool hasElse = extraState?.containsKey('hasElse') ?? false;
      int elseIfCount = extraState?['elseIfCount'] ?? 0;

      print(node);
    }
    await super.runCode();
  }
}