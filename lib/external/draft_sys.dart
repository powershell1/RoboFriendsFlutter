import 'package:rxdart/rxdart.dart';

class DraftList {
  static final BehaviorSubject<List<Draft>> draftList = BehaviorSubject.seeded([
    Draft(title: 'Untitled 1', content: '{}', date: DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch + (1000 * 60 * 60))),
  ]);

  static void addDraft(Draft draft) {
    var old = draftList.stream.valueOrNull;
    draftList.add([...old!, draft]);
  }
}

class Draft {
  String title;
  DateTime? date;
  String content;

  Draft({required this.title, required this.content, this.date});
}