import 'dart:convert';

import 'package:robo_friends/classes/assignmentClass.dart';
import 'package:robo_friends/classes/authentication.dart';
import 'package:robo_friends/classes/profileClass.dart';
import 'package:rxdart/rxdart.dart';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';

import 'hashable.dart';

class DraftList {
  static void addDraft(Draft draft) {
    Profile profile = AuthExternal.profileStream.stream.valueOrNull!;
    profile.drafts.add(draft);
    AuthExternal.updateProfile('drafts');
  }

  static void removeDraft(Draft draft) {
    Profile profile = AuthExternal.profileStream.stream.valueOrNull!;
    profile.drafts.remove(draft);
    AuthExternal.updateProfile('drafts');
  }
}

class Draft with HashableObject {
  String title;
  String content;
  Assignment? assignment;


  Draft({required this.title, required this.content, this.assignment});

  @override
  String get hash => hex.encode(sha256.convert(utf8.encode(title + content + (assignment?.hash ?? ""))).bytes);
}