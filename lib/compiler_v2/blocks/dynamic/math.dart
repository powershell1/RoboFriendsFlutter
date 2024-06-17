import 'dart:math';

import '../../blueprint.dart';
import '../../compiler.dart';

class MathNumber extends BlockFunctions {
  @override
  num runCode() {
    if (node.containsKey('fields')) {
      num number = node['fields']['NUM'];
      return number;
    }
    return 0;
  }
}

class MathArithmetic extends BlockFunctions {
  @override
  Future<num> runCode() async {
    BlockFunctions? aType = await CodeCompiler.initBlock(
      fieldsDecoder(node['inputs']['A']),
      parent: parentFunctions,
    );
    BlockFunctions? bType = await CodeCompiler.initBlock(
      fieldsDecoder(node['inputs']['B']),
      parent: parentFunctions,
    );
    if (aType == null || bType == null) return 0;
    num a = await aType.runCode();
    num b = await bType.runCode();
    String op = node['fields']['OP'];
    if (op == 'ADD') {
      return a + b;
    } else if (op == 'MINUS') {
      return a - b;
    } else if (op == 'MULTIPLY') {
      return a * b;
    } else if (op == 'DIVIDE') {
      return a ~/ b;
    } else if (op == 'POWER') {
      return pow(a, b);
    }
    return 0;
  }
}

class MathSingle extends BlockFunctions {
  @override
  Future<num> runCode() async {
    BlockFunctions? aType = await CodeCompiler.initBlock(
      fieldsDecoder(node['inputs']['NUM']),
      parent: parentFunctions,
    );
    if (aType == null) return 0;
    num a = await aType.runCode();
    String op = node['fields']['OP'];
    if (op == 'ROOT') {
      return sqrt(a);
    } else if (op == 'ABS') {
      return a.abs();
    } else if (op == 'NEG') {
      return -a;
    } else if (op == 'LN') {
      return log(a);
    } else if (op == 'LOG10') {
      return log(a) / log(10);
    } else if (op == 'EXP') {
      return exp(a);
    } else if (op == 'POW10') {
      return pow(10, a);
    }
    return 0;
  }
}

class MathTrig extends BlockFunctions {
  @override
  Future<num> runCode() async {
    BlockFunctions? aType = await CodeCompiler.initBlock(
      fieldsDecoder(node['inputs']['NUM']),
      parent: parentFunctions,
    );
    if (aType == null) return 0;
    num a = await aType.runCode();
    String op = node['fields']['OP'];
    if (op == 'SIN') {
      return sin(a);
    } else if (op == 'COS') {
      return cos(a);
    } else if (op == 'TAN') {
      return tan(a);
    } else if (op == 'ASIN') {
      return asin(a);
    } else if (op == 'ACOS') {
      return acos(a);
    } else if (op == 'ATAN') {
      return atan(a);
    }
    return 0;
  }
}

class MathConstant extends BlockFunctions {
  @override
  Future<num> runCode() async {
    String op = node['fields']['CONSTANT'];
    if (op == 'PI') {
      return pi;
    } else if (op == 'E') {
      return e;
    } else if (op == 'GOLDEN_RATIO') {
      return (1 + sqrt(5)) / 2;
    } else if (op == 'SQRT2') {
      return sqrt(2);
    } else if (op == 'SQRT1_2') {
      return 1 / sqrt(2);
    } else if (op == 'INFINITY') {
      return double.maxFinite as num;
    }
    return 0;
  }
}

class MathRound extends BlockFunctions {
  @override
  Future<num> runCode() async {
    BlockFunctions? aType = await CodeCompiler.initBlock(
      fieldsDecoder(node['inputs']['NUM']),
      parent: parentFunctions,
    );
    if (aType == null) return 0;
    num a = await aType.runCode();
    String op = node['fields']['OP'];
    if (op == 'ROUND') {
      return a.round();
    } else if (op == 'ROUNDUP') {
      return a.ceil();
    } else if (op == 'ROUNDDOWN') {
      return a.floor();
    }
    return 0;
  }
}

class MathModulo extends BlockFunctions {
  @override
  Future<num> runCode() async {
    BlockFunctions? aType = await CodeCompiler.initBlock(
      fieldsDecoder(node['inputs']['DIVIDEND']),
      parent: parentFunctions,
    );
    BlockFunctions? bType = await CodeCompiler.initBlock(
      fieldsDecoder(node['inputs']['DIVISOR']),
      parent: parentFunctions,
    );
    if (aType == null || bType == null) return 0;
    num a = await aType.runCode();
    num b = await bType.runCode();
    return a % b;
  }
}

class MathConstrain extends BlockFunctions {
  @override
  Future<num> runCode() async {
    BlockFunctions? aType = await CodeCompiler.initBlock(
      fieldsDecoder(node['inputs']['VALUE']),
      parent: parentFunctions,
    );
    BlockFunctions? bType = await CodeCompiler.initBlock(
      fieldsDecoder(node['inputs']['LOW']),
      parent: parentFunctions,
    );
    BlockFunctions? cType = await CodeCompiler.initBlock(
      fieldsDecoder(node['inputs']['HIGH']),
      parent: parentFunctions,
    );
    if (aType == null || bType == null || cType == null) return 0;
    num a = await aType.runCode();
    num b = await bType.runCode();
    num c = await cType.runCode();
    return a.clamp(b, c);
  }
}

class MathRandomInt extends BlockFunctions {
  @override
  Future<num> runCode() async {
    BlockFunctions? aType = await CodeCompiler.initBlock(
      fieldsDecoder(node['inputs']['FROM']),
      parent: parentFunctions,
    );
    BlockFunctions? bType = await CodeCompiler.initBlock(
      fieldsDecoder(node['inputs']['TO']),
      parent: parentFunctions,
    );
    if (aType == null || bType == null) return 0;
    num a = await aType.runCode();
    num b = await bType.runCode();
    return Random().nextInt(b.toInt() - a.toInt()) + a.toInt();
  }
}

class MathRandomFloat extends BlockFunctions {
  @override
  num runCode() => Random().nextDouble();
}

class MathAtan2 extends BlockFunctions {
  @override
  Future<num> runCode() async {
    BlockFunctions? aType = await CodeCompiler.initBlock(
      fieldsDecoder(node['inputs']['X']),
      parent: parentFunctions,
    );
    BlockFunctions? bType = await CodeCompiler.initBlock(
      fieldsDecoder(node['inputs']['Y']),
      parent: parentFunctions,
    );
    if (aType == null || bType == null) return 0;
    num a = await aType.runCode();
    num b = await bType.runCode();
    return atan2(a, b);
  }
}