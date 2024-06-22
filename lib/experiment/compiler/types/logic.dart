import 'universal.dart';

import '../code_compiler.dart';

const logicList = [
  'logic_boolean',
  'logic_compare',
  'logic_operation',
  'logic_negate',
  'math_number_property'
];

double logicDecoder(Map<String, dynamic> block, String? functionId) {
  if (block['type'] == 'logic_boolean') {
    return block['fields']['BOOL'] == 'TRUE' ? 1.0 : 0.0;
  } else if (block['type'] == 'logic_compare') {
    return logicCompare(block, functionId);
  } else if (block['type'] == 'logic_operation') {
    return logicOperation(block, functionId);
  } else if (block['type'] == 'logic_negate') {
    return logicNegate(block, functionId);
  } else if (block['type'] == 'math_number_property') {
    return mathNumberProperty(block, functionId);
  }
  printWarning('${block['type']} not found in logicDecoder');
  return 0;
}

double mathNumberProperty(Map<String, dynamic> block, String? functionId) {
  double num1 = universalDecoder(
      fieldsDecoder(block['inputs']['NUMBER_TO_CHECK']),
      functionId: functionId);
  int property = block['fields']['PROPERTY'] == 'EVEN' ? 0 : 1;
  return num1 % 2 == property ? 1 : 0;
}

double logicNegate(Map<String, dynamic> block, String? functionId) {
  if (!block.containsKey('inputs')) return 0;
  Map<String, dynamic> inputs = block['inputs'];
  double bool = inputs.containsKey('BOOL')
      ? universalDecoder(fieldsDecoder(inputs['BOOL']), functionId: functionId)
      : 0;
  return bool == 1 ? 0 : 1;
}

double logicOperation(Map<String, dynamic> block, String? functionId) {
  if (!block.containsKey('inputs')) return 0;
  Map<String, dynamic> inputs = block['inputs'];
  double A =
  inputs.containsKey('A') ? universalDecoder(fieldsDecoder(inputs['A']),
      functionId: functionId) : 0;
  double B =
  inputs.containsKey('B') ? universalDecoder(fieldsDecoder(inputs['B']),
      functionId: functionId) : 0;
  String operator = block['fields']['OP'];
  switch (operator) {
    case 'AND':
      return A == 1 && B == 1 ? 1 : 0;
    case 'OR':
      return A == 1 || B == 1 ? 1 : 0;
    default:
      printWarning('Operator $operator not found in logicOperation');
      return 0;
  }
}

double logicCompare(Map<String, dynamic> block, String? functionId) {
  if (!block.containsKey('inputs')) return 0;
  Map<String, dynamic> inputs = block['inputs'];
  double A =
  inputs.containsKey('A') ? universalDecoder(fieldsDecoder(inputs['A']),
      functionId: functionId) : 0;
  double B =
  inputs.containsKey('B') ? universalDecoder(fieldsDecoder(inputs['B']),
      functionId: functionId) : 0;
  String operator = block['fields']['OP'];
  switch (operator) {
    case 'EQ':
      return A == B ? 1 : 0;
    case 'NEQ':
      return A != B ? 1 : 0;
    case 'LT':
      return A < B ? 1 : 0;
    case 'LTE':
      return A <= B ? 1 : 0;
    case 'GT':
      return A > B ? 1 : 0;
    case 'GTE':
      return A >= B ? 1 : 0;
    default:
      printWarning('Operator $operator not found in logicCompare');
      return 0;
  }
}
