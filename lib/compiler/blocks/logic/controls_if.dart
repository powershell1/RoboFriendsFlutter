import '../../code_compiler.dart';
import '../../types/universal.dart';

class ControlsIf extends CodeBlock {
  ControlsIf();

  @override
  void compile(Map<String, dynamic> fullNode, {String? functionId}) {
    Map<String, dynamic>? inputs = fullNode['inputs'];
    if (inputs != null || inputs!.isNotEmpty) {
      bool isElse = fullNode.containsKey('extraState') &&
          fullNode['extraState'].containsKey('hasElse');
      bool hasFinal = true;
      for (int i = 0; i < inputs.length; i++) {
        String key = 'IF$i';
        if (inputs.containsKey(key)) {
          double inputIF = universalDecoder(fieldsDecoder(inputs[key]), functionId: functionId);
          if (inputIF == 0) continue;
          String doKey = 'DO$i';
          if (!inputs.containsKey(doKey)) continue;
          print(inputs[doKey]['block']);
          CodeCompiler.runBlock(inputs[doKey]['block'], functionId: functionId);
          hasFinal = false;
          break;
        }
      }
      if (isElse && hasFinal && inputs.containsKey('ELSE')) {
        CodeCompiler.runBlock(inputs['ELSE']['block'], functionId: functionId);
      }
    }
    if (!fullNode.containsKey('next')) return;
    CodeCompiler.runBlock(fullNode['next']['block'], functionId: functionId);
  }
}
