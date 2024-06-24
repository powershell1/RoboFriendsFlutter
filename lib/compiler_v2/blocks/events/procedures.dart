import '../../blueprint.dart';
import '../../compiler.dart';

class ProceduresDefNoReturn extends BlockFunctions {
  @override
  Future<void> init(Map<String, dynamic> node, {BlockFunctions? parent}) async {
    String functionNames = node['fields']['NAME'];
    // print(node);
    BlocksBlueprint.storedFunctions[functionNames] = this;
    if (node.containsKey('extraState')) {
      node['extraState']['params'].forEach((param) {
        String paramName = param['name'];
        String paramId = param['id'];
        BlocksBlueprint.storedNameVariable[paramName] = paramId;
        BlocksBlueprint.storedVariable[paramId] = null;
      });
    }
    await super.init(node, parent: parent);
  }

  @override
  void runCode([Map<String, dynamic>? params]) async {
    params?.forEach((key, value) {
      String id = BlocksBlueprint.storedNameVariable[key];
      BlocksBlueprint.storedVariable[id] = value;
      // print(key);
      // print(value);
    });
    // if (parentFunctions == null) return print('No calling just yet');
    if (!node.containsKey('inputs')) return;
    Map<String, dynamic> blocks = node['inputs']['STACK']['block'];
    BlockFunctions? blockType = await CodeCompiler.initBlock(blocks);
    if (blockType == null) return;
    await blockType.runCode();
    await super.runCode();
  }
}

class ProceduresCallNoReturn extends BlockFunctions {
  @override
  void runCode() async {
    Map<String, dynamic> extraState = node['extraState'];
    String functionName = extraState['name'];
    if (BlocksBlueprint.storedFunctions.containsKey(functionName)) {
      Map<String, dynamic> params = {};
      if (extraState.containsKey('params')) {
        int i = 0;
        for (var param in extraState['params']) {
          params[param] = await (await CodeCompiler.initBlock(
            fieldsDecoder(node['inputs']['ARG$i']),
            parent: parentFunctions,
          ))?.runCode();
          i++;
        }
      }
      await BlocksBlueprint.storedFunctions[functionName]?.runCode(params);
    }
    await super.runCode();
  }
}