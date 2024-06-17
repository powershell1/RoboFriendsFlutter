import '../../code_compiler.dart';
import '../../types/universal.dart';

class VariablesSet extends CodeBlock {
  VariablesSet();

  @override
  void compile(Map<String, dynamic> fullNode, {String? functionId}) {
    Map<String, dynamic>? inputs = fullNode['inputs'];
    if (inputs != null) {
      Map<String, dynamic> fields = fullNode['fields'];
      String varId = fields['VAR']['id'];
      if (functionId != null) {
        String varName = CodeCompiler.idToName[varId]!;
        CodeCompiler.compiledFunctionsInputs[functionId][varName] =
            universalDecoder(fieldsDecoder(inputs['VALUE']));
      } else {
        CodeCompiler.compiledVariables[varId] = universalDecoder(
            fieldsDecoder(inputs['VALUE']),
            functionId: functionId);
      }
    }
    // print(CodeCompiler.compiledVariables);
    if (!fullNode.containsKey('next')) return;
    CodeCompiler.runBlock(fullNode['next']['block'], functionId: functionId);
  }
}
