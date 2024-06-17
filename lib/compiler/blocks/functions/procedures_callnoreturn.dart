import '../../code_compiler.dart';
import '../../types/universal.dart';

class proceduresCallNoReturn extends CodeBlock {
  proceduresCallNoReturn();

  @override
  void compile(Map<String, dynamic> fullNode, {String? functionId}) {
    Map<String, dynamic> extraState = fullNode['extraState'];
    String functionName = extraState['name'];
    if (!CodeCompiler.compiledFunctions.containsKey(functionName)) {
      printWarning('Function $functionName not found');
      return;
    }
    if (extraState.containsKey('params')) {
      Map<String, dynamic> inputs = fullNode['inputs'];
      List<dynamic> params = extraState['params'];
      int i = 0;
      for (var param in params) {
        CodeCompiler.compiledFunctionsInputs[functionName][param] =
            universalDecoder(fieldsDecoder(inputs['ARG$i']),
                functionId: functionId);
        i++;
      }
    }
    // return;
    // print(CodeCompiler.compiledFunctions[functionName]);
    // print(functionName);
    CodeCompiler.runBlock(CodeCompiler.compiledFunctions[functionName],
        functionId: functionName);
    if (!fullNode.containsKey('next')) return;
    CodeCompiler.runBlock(fullNode['next']['block'], functionId: functionId);
  }
}
