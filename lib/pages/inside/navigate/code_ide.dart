import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:robo_friends/compiler_v2/compiler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../bluetooth/bluetooth.dart';

class CodeIDE extends StatefulWidget {
  late String title;
  late String? codeJson;
  late String uri;

  CodeIDE(
      {super.key,
      required this.title,
      this.codeJson,
      required this.uri});

  @override
  State<StatefulWidget> createState() => _CodeIDEState();
}

enum ESaveBtnState { Save, Saving, Saved }

class _CodeIDEState extends State<CodeIDE> {
  late WebViewController _controller;

  late int _progress = 0;

  late ESaveBtnState saveBtnState = ESaveBtnState.Saved;

  void saveJson() async {
    if (saveBtnState == ESaveBtnState.Saving) return;
    saveBtnState = ESaveBtnState.Saving;
    String json = await getJSON();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('savedCode', json);
    // print(json);
    setState(() {
      saveBtnState = ESaveBtnState.Saved;
    });
  }

  Future<void> _bluetoothWarning(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Bluetooth is off'),
          content: const Text(
            'Please make sure that you enable bluetooth.'
          ),
          actions: <Widget>[
            CupertinoButton(
              child: const Text(
                'ok',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> getJSON() async {
    String json = await _controller.runJavaScriptReturningResult('''
    (function() {
      return window.blockJSON || false;
    })();
    ''') as String;
    if (Platform.isAndroid) {
      json = json.replaceAll('\\', '');
      // print(json);
      json = json.substring(1, json.length - 1);
      // print(json);
    }
    // print(json);
    return json;
  }

  void runCode() async {
    String code = await getJSON();
    if (FlutterBluePlus.adapterStateNow != BluetoothAdapterState.on) {
      _bluetoothWarning(context);
      return;
    }
    if (CodeCompiler.isCompiling) {
      CodeCompiler.killCompiler();
      return;
    }
    CodeCompiler.compile(code);
  }



  @override
  void initState() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(widget.uri))
      ..addJavaScriptChannel('BlockChanged', onMessageReceived: (instance) {
        setState(() {
          saveBtnState = ESaveBtnState.Save;
        });
        // print('Message: ${instance.message}');
      })
      ..addJavaScriptChannel('Debug', onMessageReceived: (instance) {
        print('${instance.message}');
      });
    _controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) async {
          setState(() {
            _progress = progress;
          });
          if (_progress != 100) return;
          String? savedCode = widget.codeJson;
          if (savedCode == null) {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            savedCode = prefs.getString('savedCode');
            if (savedCode == null) return;
          }
          // print(savedCode);
          _controller.runJavaScript('''window.loadJSON('$savedCode');''');
        },
      ),
    );
    super.initState();
  }

  void _refreshWeb() {
    if (saveBtnState == ESaveBtnState.Save) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('You have unsaved changes!'),
            content: const Text('Are you sure you want to refresh the IDE?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  _controller.reload();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }
    _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight * 1.25),
        child: AppBar(
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 0),
              child: GestureDetector(
                onTap: saveJson,
                child: Text(
                  saveBtnState.name,
                  style: TextStyle(
                      color: saveBtnState == ESaveBtnState.Saved
                          ? const Color(0x7f82c3ff)
                          : const Color(0xff82c3ff),
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: _refreshWeb,
              ),
            ),
          ],
          backgroundColor: const Color(0xff131314),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
          title: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButton: _progress >= 100
          ? StreamBuilder(
              stream: CodeCompiler.compilerStream.stream,
              builder: (context, snapshot) {
                return FloatingActionButton(
                  onPressed: runCode,
                  child: Icon(
                      CodeCompiler.isCompiling ? Icons.stop : Icons.play_arrow),
                );
              })
          : null,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: WebViewWidget(controller: _controller),
          ),
          if (_progress < 100) ...[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Please wait while we loading IDE...'),
                  const SizedBox(height: 20),
                  CircularProgressIndicator(
                    value: _progress / 100,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
