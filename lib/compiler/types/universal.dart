import 'package:robo_friends/compiler/code_compiler.dart';

import 'logic.dart';
import 'math.dart';

dynamic universalDecoder(Map<String, dynamic> block, {String? functionId}) {
  String type = block['type'];
  if (logicList.contains(type)) {
    return logicDecoder(block, functionId);
  } else if (mathList.contains(type)) {
    return mathDecoder(block, functionId);
  } else if (type == "variables_get") {
    String id = block['fields']['VAR']['id'];
    if (functionId != null && CodeCompiler.compiledFunctionsInputs.containsKey(functionId)) {
      String varName = CodeCompiler.idToName[id]!;
      // print(varName);
      if (CodeCompiler.compiledFunctionsInputs[functionId].containsKey(varName)) {
        return CodeCompiler.compiledFunctionsInputs[functionId][varName];
      }
      printWarning('Unable to use function inputs as variables');
      return 0;
    }
    return CodeCompiler.compiledVariables[id];
  }

  printWarning('$type not found in universalDecoder');
  printWarning('Use null safety checks avoid the errors');
  return 0;
}