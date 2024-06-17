import '../../code_compiler.dart';
import '../../types/universal.dart';

class ControlsRepeatExt extends CodeBlock {
  ControlsRepeatExt();

  @override
  void compile(Map<String, dynamic> fullNode, {String? functionId}) {
    Map<String, dynamic>? inputs = fullNode['inputs'];
    Map<String, dynamic> inputBlocks = inputs!['TIMES'];
    int times = universalDecoder(fieldsDecoder(inputBlocks), functionId: functionId).round();
    for (int i = 0; i < times; i++) {
      if (!inputs.containsKey('DO')) break;
      CodeCompiler.runBlock(inputs['DO']['block'], functionId: functionId);
    }
    if (!fullNode.containsKey('next')) return;
    CodeCompiler.runBlock(fullNode['next']['block'], functionId: functionId);
  }
}
