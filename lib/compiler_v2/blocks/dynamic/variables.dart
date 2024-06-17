import '../../blueprint.dart';
import '../../compiler.dart';

class VariablesGet extends BlockFunctions {
  @override
  num runCode() {
    String id = node['fields']['VAR']['id'];
    return BlocksBlueprint.storedVariable[id] ?? 0;
  }
}

class VariablesSet extends BlockFunctions {
  @override
  Future<void> runCode() async {
    String id = node['fields']['VAR']['id'];
    dynamic value = await (await CodeCompiler.initBlock(
            fieldsDecoder(node['inputs']['VALUE'])))
        ?.runCode();
    BlocksBlueprint.storedVariable[id] = value;
    BlocksBlueprint.variableStream.sink.add(value);
    await super.runCode();
  }
}

class MathChange extends BlockFunctions {
  @override
  Future<void> runCode() async {
    String id = node['fields']['VAR']['id'];
    dynamic value = await (await CodeCompiler.initBlock(
            fieldsDecoder(node['inputs']['DELTA'])))
        ?.runCode();
    BlocksBlueprint.storedVariable[id] =
        (BlocksBlueprint.storedVariable[id] ?? 0) + value;
    BlocksBlueprint.variableStream.sink.add(value);
    await super.runCode();
  }
}
