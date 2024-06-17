import 'dart:math';

import 'universal.dart';

import '../code_compiler.dart';

const mathList = [
  'math_number',
  'math_arithmetic',
  'math_single',
  'math_trig',
  'math_constant',
  'math_round',
  'math_modulo',
  'math_constrain',
  'math_random_int',
  'math_random_float',
  'math_atan2'
];

double mathDecoder(Map<String, dynamic> block, String? functionId) {
  if (block['type'] == 'math_number') {
    return block['fields']['NUM'].toDouble();
  } else if (block['type'] == 'math_arithmetic') {
    return mathArithmetic(block, functionId);
  } else if (block['type'] == 'math_single') {
    return mathSingle(block, functionId);
  } else if (block['type'] == 'math_trig') {
    return mathTrigonometry(block, functionId);
  } else if (block['type'] == 'math_constant') {
    return mathConstant(block);
  } else if (block['type'] == 'math_round') {
    return mathRound(block, functionId);
  } else if (block['type'] == 'math_modulo') {
    return mathModulo(block, functionId);
  } else if (block['type'] == 'math_constrain') {
    return mathConstraints(block, functionId);
  } else if (block['type'] == 'math_random_int') {
    return mathRandomInt(block, functionId);
  } else if (block['type'] == 'math_random_float') {
    return mathRandomFloat(block);
  } else if (block['type'] == 'math_atan2') {
    return mathAtan2(block, functionId);
  } else if (block['type'] == 'ultrasonic_get') {
    return ultrasonicGet(block, functionId);
  }
  printWarning('${block['type']} not found in mathDecoder');
  return 0;
}

double ultrasonicGet(Map<String, dynamic> block, String? functionId) {
  double num1 = universalDecoder(fieldsDecoder(block['inputs']['TRIG']),
      functionId: functionId);
  double num2 = universalDecoder(fieldsDecoder(block['inputs']['ECHO']),
      functionId: functionId);
  return num1 + num2;
}

double mathAtan2(Map<String, dynamic> block, String? functionId) {
  double num1 = universalDecoder(fieldsDecoder(block['inputs']['X']),
      functionId: functionId);
  double num2 = universalDecoder(fieldsDecoder(block['inputs']['Y']),
      functionId: functionId);
  return atan2(num1, num2);
}

double mathRandomFloat(Map<String, dynamic> block) {
  return Random().nextDouble();
}

double mathRandomInt(Map<String, dynamic> block, String? functionId) {
  double min = universalDecoder(fieldsDecoder(block['inputs']['FROM']),
      functionId: functionId);
  double max = universalDecoder(fieldsDecoder(block['inputs']['TO']),
      functionId: functionId);
  return Random().nextInt(max.toInt() - min.toInt()) + min;
}

double mathConstraints(Map<String, dynamic> block, String? functionId) {
  double num1 = universalDecoder(fieldsDecoder(block['inputs']['VALUE']),
      functionId: functionId);
  double min = universalDecoder(fieldsDecoder(block['inputs']['LOW']),
      functionId: functionId);
  double max = universalDecoder(fieldsDecoder(block['inputs']['HIGH']),
      functionId: functionId);
  return num1.clamp(min, max);
}

double mathModulo(Map<String, dynamic> block, String? functionId) {
  double num1 = universalDecoder(fieldsDecoder(block['inputs']['DIVIDEND']),
      functionId: functionId);
  double num2 = universalDecoder(fieldsDecoder(block['inputs']['DIVISOR']),
      functionId: functionId);
  return num1 % num2;
}

double mathRound(Map<String, dynamic> block, String? functionId) {
  double num1 = universalDecoder(fieldsDecoder(block['inputs']['NUM']),
      functionId: functionId);
  String operation = block['fields']['OP'];
  switch (operation) {
    case 'ROUND':
      return num1.roundToDouble();
    case 'ROUNDUP':
      return num1.ceilToDouble();
    case 'ROUNDDOWN':
      return num1.floorToDouble();
    default:
      return 0;
  }
}

double mathConstant(Map<String, dynamic> block) {
  String operation = block['fields']['CONSTANT'];
  switch (operation) {
    case 'PI':
      return pi;
    case 'E':
      return e;
    case 'GOLDEN_RATIO':
      return (1 + sqrt(5)) / 2;
    case 'SQRT2':
      return sqrt(2);
    case 'SQRT1_2':
      return sqrt(1 / 2);
    case 'INFINITY':
      return double.maxFinite;
    default:
      return 0;
  }
}

double mathTrigonometry(Map<String, dynamic> block, String? functionId) {
  String operation = block['fields']['OP'];
  double num1 = universalDecoder(fieldsDecoder(block['inputs']['NUM']),
      functionId: functionId);
  switch (operation) {
    case 'SIN':
      return sin(num1);
    case 'COS':
      return cos(num1);
    case 'TAN':
      return tan(num1);
    case 'ASIN':
      return asin(num1);
    case 'ACOS':
      return acos(num1);
    case 'ATAN':
      return atan(num1);
    default:
      return 0;
  }
}

double mathSingle(Map<String, dynamic> block, String? functionId) {
  String operation = block['fields']['OP'];
  double num1 = universalDecoder(fieldsDecoder(block['inputs']['NUM']),
      functionId: functionId);
  switch (operation) {
    case 'ROOT':
      return sqrt(num1);
    case 'ABS':
      return num1.abs();
    case 'NEG':
      return -num1;
    case 'LN':
      return log(num1);
    case 'LOG10':
      return log(num1) / log(10);
    case 'EXP':
      return exp(num1);
    case 'POW10':
      return pow(10, num1) as double;
    default:
      return 0;
  }
}

double mathArithmetic(Map<String, dynamic> block, String? functionId) {
  String operation = block['fields']['OP'];
  double num1 = universalDecoder(fieldsDecoder(block['inputs']['A']),
      functionId: functionId);
  double num2 = universalDecoder(fieldsDecoder(block['inputs']['B']),
      functionId: functionId);
  switch (operation) {
    case 'ADD':
      return num1 + num2;
    case 'MINUS':
      return num1 - num2;
    case 'MULTIPLY':
      return num1 * num2;
    case 'DIVIDE':
      return num1 / num2 == double.infinity ? 0 : num1 / num2;
    case 'POWER':
      return pow(num1, num2) as double;
    default:
      return 0;
  }
}
