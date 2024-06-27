import 'package:robo_friends/classes/assignmentClass.dart';
import 'package:rxdart/rxdart.dart';

class DraftList {
  static final BehaviorSubject<List<Draft>> draftList = BehaviorSubject.seeded([
    Draft(title: 'Untitled 1', content: '{}'),
    Draft(title: 'Untitled 2', content: '{}', assignment: AssignmentList.assignList.stream.valueOrNull![0]),
  ]);

  static void addDraft(Draft draft) {
    var old = draftList.stream.valueOrNull;
    draftList.add([...old!, draft]);
  }

  static void removeDraft(Draft draft) {
    var old = draftList.stream.valueOrNull;
    old!.remove(draft);
    draftList.add(old);
  }
}

class Draft {
  String title;
  String content;
  Assignment? assignment;

  Draft({required this.title, required this.content, this.assignment});
}