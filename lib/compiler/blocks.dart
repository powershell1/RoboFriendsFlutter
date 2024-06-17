import 'blocks/functions/procedures_callnoreturn.dart';
import 'blocks/functions/procedures_defnoreturn.dart';
import 'blocks/logic/controls_if.dart';
import 'blocks/motor/rotate_motor.dart';
import 'blocks/variables/variables_set.dart';
import 'blocks/loop/controls_repeat_ext.dart';
import 'blocks/variables/math_change.dart';
import 'code_compiler.dart';

class Blocks {
  static Map<String, CodeBlock> exportBlocks = {
    'controls_if': ControlsIf(),

    'controls_repeat_ext': ControlsRepeatExt(),

    'rotate_motor': RotateMotor(),

    'variables_set': VariablesSet(),
    'math_change': MathChange(),

    'procedures_defnoreturn': proceduresDefNoReturn(),
    'procedures_callnoreturn': proceduresCallNoReturn(),
  };
}