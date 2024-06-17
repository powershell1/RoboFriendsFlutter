import 'dart:async';

import 'package:robo_friends/compiler_v2/blueprint.dart';

import '../../../bluetooth/bluetooth.dart';
import '../../compiler.dart';

import 'dart:isolate';

class StartEvent extends BlockFunctions {
  @override
  Future<void> init(Map<String, dynamic> node, {BlockFunctions? parent}) async {
    await super.init(node, parent: parent);
    await runCode();
  }

  @override
  Future<void> runCode() async {
    if (parentFunctions != null)
      return print('Cant\'t called from another block!');
    if (!node.containsKey('inputs')) return;
    Map<String, dynamic> blocks = node['inputs']['DO']['block'];
    BlockFunctions? blockType = await CodeCompiler.initBlock(blocks);
    if (blockType == null) return;
    await blockType.runCode();
    await super.runCode();
  }
}

class LoopEvent extends BlockFunctions {
  void sendBlueprintData(SendPort sendPort) {
    // print(BlocksBlueprint.storedVariable);
    // print(BlocksBlueprint.storedVariable);
    sendPort.send([
      BlocksBlueprint.storedVariable,
      BlocksBlueprint.storedNameVariable,
      BlocksBlueprint.storedFunctions
    ]);
  }

  @override
  Future<void> init(Map<String, dynamic> node, {BlockFunctions? parent}) async {
    await super.init(node, parent: parent);
    final receivePort = ReceivePort();
    receivePort.listen((data) {
      if (data is SendPort) {
        SendPort sendPort = data;
        sendBlueprintData(sendPort);
        BlocksBlueprint.variableStream.stream
            .listen((event) => sendBlueprintData(sendPort));
        BluetoothConnection.sensorNotify.stream
            .listen((event) => sendPort.send(BluetoothConnection.sensorValues));
        return;
      } else if (data is CompilerStreamObject) {
        BluetoothConnection.compilerStream.sink.add(data.cso);
        // print(Isolate.current.debugName);
        // print(data.cso);
        return;
      }
      // print('-----------------');
      // print(Isolate.current.debugName);
      // print(data);
      // print(data);
      BlocksBlueprint.storedVariable = data[0];
      BlocksBlueprint.storedNameVariable = data[1];
      BlocksBlueprint.storedFunctions = data[2];
      BlocksBlueprint.variableStream.sink.add(data);
    });
    CodeCompiler.compilerIsolates
        .add(await Isolate.spawn(threadSetup, receivePort.sendPort, debugName: 'LoopEvent'));
  }

  void threadSetup(SendPort sendPort) {
    final ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    BluetoothConnection.compilerStream.stream.listen((event) {
      sendPort.send(CompilerStreamObject(event));
    });
    receivePort.listen((data) {
      if (data is Map<SensorType, dynamic>) {
        // print(data);
        BluetoothConnection.sensorValues = data;
        BluetoothConnection.sensorNotify.add(data);
        return;
      }
      BlocksBlueprint.storedVariable = data[0];
      BlocksBlueprint.storedNameVariable = data[1];
      BlocksBlueprint.storedFunctions = data[2];
    });
    BlocksBlueprint.variableStream.stream.listen((event) {
      sendBlueprintData(sendPort);
    });
    runCode();
  }

  @override
  Future<void> runCode() async {
    // print(node);
    if (!node.containsKey('inputs')) return;
    Map<String, dynamic> blocks = node['inputs']['DO']['block'];
    BlockFunctions? blockType = await CodeCompiler.initBlock(blocks);
    if (blockType == null) return;
    int startMs = DateTime.now().millisecondsSinceEpoch;
    await blockType.runCode();
    await super.runCode();
    // print(node['id']);
    int timeTake = DateTime.now().millisecondsSinceEpoch - startMs;
    Future.delayed(Duration(milliseconds: timeTake < 100 ? 100 - timeTake : 0), () async {
      await runCode();
    });
    // print(ptr);
    // Pointer<Char> newPtr = Pointer<Char>.fromAddress(ptr!);
    // print(newPtr.value);
  }
}

class WaitFor extends BlockFunctions {
  @override
  void runCode([Map<String, dynamic>? storedFunc]) async {
    if (node.containsKey('inputs')) {
      // print(fieldsDecoder(node['inputs']['SECONDS']));
      num second = await (await CodeCompiler.initBlock(
        fieldsDecoder(node['inputs']['SECONDS']),
        parent: parentFunctions,
      ))!
          .runCode();
      await Future.delayed(Duration(milliseconds: (second * 1000).toInt()));
      // print(CodeCompiler.isCompiling);
    }
    await super.runCode();
  }
}
