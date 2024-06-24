import 'package:rxdart/rxdart.dart';

class AssignmentList {
  static final BehaviorSubject<List<Assignment>> assignList = BehaviorSubject.seeded([
    Assignment(title: 'Blink LED', content: '{}', date: DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch + (1000 * 60 * 60))),
  ]);

  static void addAssignment(Assignment assign) {
    var old = assignList.stream.valueOrNull;
    assignList.add([...old!, assign]);
  }
}

class Assignment {
  String title;
  DateTime? date;
  String content;

  Assignment({required this.title, required this.content, this.date});
}