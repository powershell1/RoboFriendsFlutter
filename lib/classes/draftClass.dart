import 'package:robo_friends/classes/assignmentClass.dart';
import 'package:robo_friends/classes/authentication.dart';
import 'package:rxdart/rxdart.dart';

class DraftList {
  static void addDraft(Draft draft) {
    var profile = AuthExternal.profileStream.stream.valueOrNull!..drafts.add(draft);
    print(profile.drafts);
    /*
    final old = AuthExternal.profileStream.stream.valueOrNull!.drafts;
    old.add(draft);
    AuthExternal.profileStream.sink.add(AuthExternal.profileStream.stream.valueOrNull!);
     */
  }

  static void removeDraft(Draft draft) {
    var old = AuthExternal.profileStream.stream.valueOrNull!.drafts;
    old.remove(draft);
  }
}

class Draft {
  String title;
  String content;
  Assignment? assignment;

  Draft({required this.title, required this.content, this.assignment});
}