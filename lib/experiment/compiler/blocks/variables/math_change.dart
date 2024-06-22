import '../../code_compiler.dart';
import '../../types/universal.dart';

class MathChange extends CodeBlock {
  MathChange();

  @override
  void compile(Map<String, dynamic> fullNode, {String? functionId}) {
    Map<String, dynamic>? inputs = fullNode['inputs'];
    if (inputs != null) {
      Map<String, dynamic> fields = fullNode['fields'];
      String varId = fields['VAR']['id'];
      dynamic value = universalDecoder(fieldsDecoder(inputs['DELTA']), functionId: functionId);
      if (value is! double) return;
      if (functionId != null) {
        String varName = CodeCompiler.idToName[varId]!;
        CodeCompiler.compiledFunctionsInputs[functionId][varName] += value;
      } else {
        CodeCompiler.compiledVariables[varId] += value;
      }
      /*
      String varId = fields['VAR']['id'];
      CodeCompiler.compiledVariables[varId] = universalDecoder(fieldsDecoder(inputs['VALUE']));
       */
    }
    // print(CodeCompiler.compiledVariables);
    if (!fullNode.containsKey('next')) return;
    CodeCompiler.runBlock(fullNode['next']['block'], functionId: functionId);
  }
}