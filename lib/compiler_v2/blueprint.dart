import 'dart:async';
import 'dart:developer';

import 'package:robo_friends/compiler_v2/blocks/dynamic/logic.dart';

import 'blocks/dynamic/math.dart';

import 'blocks/dynamic/variables.dart';
import 'blocks/events/events.dart';
import 'blocks/events/procedures.dart';
import 'blocks/sensors.dart';
import 'compiler.dart';

class BlocksBlueprint {
  static Map<String, dynamic> storedFunctions = {};
  static Map<String, dynamic> storedVariable = {};
  static Map<String, dynamic> storedNameVariable = {};

  static StreamController<dynamic> variableStream =
      StreamController<dynamic>.broadcast();

  static final List<String> firstClassBlocks = [
    'start_event',
    'loop_event',
    'procedures_defnoreturn',
    'procedures_defreturn',
  ];

  static BlockFunctions? blocksFactory(Map<String, dynamic> block) {
    String blockType = block['type'];
    switch (blockType) {
      case 'procedures_defnoreturn':
        return ProceduresDefNoReturn();
      case 'procedures_callnoreturn':
        return ProceduresCallNoReturn();
      case 'controls_if':
        return ControlIf();
      case 'variables_get':
        return VariablesGet();
      case 'variables_set':
        return VariablesSet();
      case 'math_change':
        return MathChange();
      case 'start_event':
        return StartEvent();
      case 'loop_event':
        return LoopEvent();
      case 'wait_for':
        return WaitFor();
      case 'rotate_servo':
        return RotateServo();
      case 'ultrasonic_get':
        return UltrasonicGet();
      case 'buzzer_set':
        return ToneSet();
      case 'motor_set':
        return SetMotor();
      case 'led_set':
        return LedSet();
      case 'math_number':
        return MathNumber();
      case 'math_arithmetic':
        return MathArithmetic();
      case 'math_single':
        return MathSingle();
      case 'math_trig':
        return MathTrig();
      case 'math_constant':
        return MathConstant();
      case 'math_round':
        return MathRound();
      case 'math_modulo':
        return MathModulo();
      case 'math_constrain':
        return MathConstrain();
      case 'math_random_int':
        return MathRandomInt();
      case 'math_random_float':
        return MathRandomFloat();
      case 'math_atan2':
        return MathAtan2();
      default:
        return null;
    }
  }
}

Map<String, dynamic> fieldsDecoder(Map<String, dynamic> fields) {
  return fields.containsKey('block') ? fields['block'] : fields['shadow'];
}

dynamic printError = (String message) => log('[❌ Compiler] Error: $message');
