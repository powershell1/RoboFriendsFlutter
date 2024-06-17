import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:logger/logger.dart';
import 'package:robo_friends/bluetooth/bluetooth.dart';

import 'blueprint.dart';

import 'package:http/http.dart' as http;

abstract class BlockFunctions {
  late Map<String, dynamic> node; // predefined

  BlockFunctions? parentFunctions;
  BlockFunctions? nextFunctions;

  Future<void> init(Map<String, dynamic> node, {BlockFunctions? parent}) async {
    this.node = node;
    parentFunctions = parent;
    if (!node.containsKey('next')) return;
    nextFunctions = await CodeCompiler.initBlock(fieldsDecoder(node['next']));
  }

  dynamic runCode() async {
    if (nextFunctions == null) return;
    await nextFunctions?.runCode();
  }
}



class CodeCompiler {
  static StreamController<bool> compilerStream = StreamController<bool>.broadcast();

  static Isolate? compilerThread;
  static SendPort? compilerSendPort;
  static bool isCompiling = false;
  static List<Isolate> compilerIsolates = [];
  static int milisecondsEpoch = 0;

  static Future<BlockFunctions?> initBlock(Map<String, dynamic> block, {BlockFunctions? parent}) async {
    BlockFunctions? blockType = BlocksBlueprint.blocksFactory(block);
    if (blockType == null) {
      Logger().w('Block not found for type: ${block['type']}');
      return null;
    }
    await blockType.init(block, parent: parent);
    return blockType;
  }

  static dynamic compile(String code) async {
    if (isCompiling) return printError('Still compiling!');
    isCompiling = true;
    compilerStream.sink.add(true);
    final ReceivePort receivePort = ReceivePort();
    milisecondsEpoch = DateTime.now().millisecondsSinceEpoch;
    compilerThread = await Isolate.spawn((sendPort) async {
      final jsonCode = json.decode(code);
      final ReceivePort receivePortThread = ReceivePort();
      sendPort.send(receivePortThread.sendPort);
      BluetoothConnection.compilerStream.stream.listen((data) {
        sendPort.send(CompilerStreamObject(data));
      });
      receivePortThread.listen((message) {
        if (message == 'kill') {
          for (var isolate in compilerIsolates) {
            isolate.kill();
          }
          receivePortThread.close();
          return;
        }
        if (message is Map<SensorType, dynamic>) {
          // message = message as Map<String, dynamic>;
          BluetoothConnection.sensorValues = message;
          BluetoothConnection.sensorNotify.add(message);
          // print('yes');
        }
      });
      print('--------------------');
      print('Compiling...');
      if (jsonCode.containsKey('blocks')) {
        List<dynamic> blocks = jsonCode['blocks']['blocks'];
        List<dynamic>? sortedBlocks = [];
        print('Sorting blocks...');
        for (var block in blocks) {
          if (block['type'] == 'procedures_defnoreturn' ||
              block['type'] == 'procedures_defreturn') {
            sortedBlocks.insert(0, block);
          } else {
            sortedBlocks.add(block);
          }
        }
        blocks = sortedBlocks;
        sortedBlocks = null;
        // print('Blocks running...');
        bool containIsolate = false;
        for (var block in blocks) {
          if (!BlocksBlueprint.firstClassBlocks.contains(block['type'])) continue;
          if (block['type'] == 'loop_event') {
            containIsolate = true;
          }
          await initBlock(block);
        }
        if (containIsolate) return;
        sendPort.send('done');
      }
    }, receivePort.sendPort);
    receivePort.listen((data) {
      if (data is SendPort) {
        compilerSendPort = data;
        BluetoothConnection.sensorNotify.stream.listen((dataNotify) {
          data.send(dataNotify);
        });
      } else if (data is CompilerStreamObject) {
        BluetoothConnection.compilerStream.sink.add(data.cso);
      } else if (data == 'done') {
        killCompiler();
      }
    });
  }

  static void killCompiler() {
    compilerSendPort?.send('kill');
    compilerThread?.kill();
    print('Finished compiling!');
    int end = DateTime.now().millisecondsSinceEpoch;
    Logger().i('Estimated time: ${(end - milisecondsEpoch)/1000}s');
    isCompiling = false;
    compilerStream.sink.add(false);
  }
}

void main() {
  String fetchCode = 'http://localhost:3000/get';
  http.get(Uri.parse(fetchCode)).then((response) async {
    if (response.statusCode != 200) return printError('Failed to fetch code');
    await CodeCompiler.compile(response.body);
  });
}