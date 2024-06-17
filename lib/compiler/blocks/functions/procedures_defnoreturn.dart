import '../../code_compiler.dart';

class proceduresDefNoReturn extends CodeBlock {
  proceduresDefNoReturn();

  @override
  void compile(Map<String, dynamic> fullNode, {String? functionId}) {
    Map<String, dynamic>? fields = fullNode['fields'];
    if (fields == null || !fields.containsKey('NAME')) {
      return;
    }
    Map<String, dynamic>? inputs = fullNode['inputs'];
    if (inputs == null || !inputs.containsKey('STACK') || !inputs['STACK'].containsKey('block')) {
      return;
    }
    CodeCompiler.compiledFunctionsInputs[fields['NAME']] = {};
    Map<String, dynamic>? extraState = fullNode['extraState'];
    if (extraState != null && extraState.containsKey('params')) {
      List<dynamic> params = extraState['params'];
      for (var param in params) {
        CodeCompiler.compiledFunctionsInputs[fields['NAME']][param['name']] = null;
      }
    }
    String name = fields['NAME'];
    CodeCompiler.compiledFunctions[name] = inputs['STACK']['block'];
    /*
    if (!fullNode.containsKey('next')) return;
    CodeCompiler.runBlock(fullNode['next']['block']);
     */
  }
}
