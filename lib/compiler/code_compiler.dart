import 'dart:convert';
import 'types/universal.dart';
import 'dart:developer';

import 'blocks.dart';

import 'package:http/http.dart' as http;

void printWarning(Object? text) {
  print('⚠️ $text');
}

abstract class CodeBlock {
  void compile(Map<String, dynamic> fullNode, {String? functionId});

  CodeBlock();
}

Map<String, dynamic> fieldsDecoder(Map<String, dynamic> block) {
  return block.containsKey('block') ? block['block'] : block['shadow'];
}

class CodeCompiler {
  static Map<String, String> idToName = {};

  static Map<String, dynamic> compiledVariables = {};

  static Map<String, dynamic> compiledFunctions = {};
  static Map<String, dynamic> compiledFunctionsInputs = {};

  static bool isCompiling = false;

  static CodeBlock? runBlock(dynamic block, {String? functionId}) {
    CodeBlock? blockInstance = Blocks.exportBlocks[block['type']];
    if (blockInstance == null) {
      printWarning('Block not found for type: ${block['type']}');
      return null;
    }
    // blockInstance.compile(block['inputs']);
    blockInstance.compile(block, functionId: functionId);
    return blockInstance;
  }

  static void compile(String jsonCode) {
    int start = DateTime.now().millisecondsSinceEpoch;
    // print(universalDecoder({"type": "variables_get", "fields": {"VAR": {"id": "a"}}}, functionId: "a"));
    if (isCompiling) return print("Already compiling!");
    isCompiling = true;
    compiledVariables = {};
    final code = json.decode(jsonCode);
    List<dynamic> blocks = code['blocks']['blocks'];
    for (var variable in code['variables'] ?? []) {
      compiledVariables[variable['id']] = null;
      idToName[variable['id']] = variable['name'];
    }
    // print(code['variables']);
    for (var block in blocks) {
      if (runBlock(block, functionId: null) == null) continue;
    }
    print("--------------------");
    print(compiledVariables);
    isCompiling = false;
    print("Finished compiling!");
    int end = DateTime.now().millisecondsSinceEpoch;
    print('Estimated time: ${end - start}ms');
  }
}