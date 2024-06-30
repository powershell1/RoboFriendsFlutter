import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:rxdart/rxdart.dart';
import 'package:crypto/crypto.dart';

import 'hashable.dart';

class AssignmentList {
  static final BehaviorSubject<List<Assignment>> assignList = BehaviorSubject.seeded([
    Assignment(title: 'Blink LED', instruction: 'make ROBOFriend blink for 3 times.', due: DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch + (1000 * 60 * 60))),
  ]);

  static void addAssignment(Assignment assign) {
    var old = assignList.stream.valueOrNull;
    assignList.add([...old!, assign]);
  }

  static void removeAssignment(Assignment assign) {
    var old = assignList.stream.valueOrNull;
    old!.remove(assign);
    assignList.add(old);
  }
}

class Assignment with HashableObject {
  String title;
  DateTime due;
  String instruction;

  Assignment({required this.title, required this.instruction, required this.due});

  @override
  String get hash => hex.encode(sha256.convert(utf8.encode(title + instruction + due.toString())).bytes);
}