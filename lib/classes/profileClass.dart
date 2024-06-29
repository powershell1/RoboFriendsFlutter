import 'dart:typed_data';

import 'package:robo_friends/classes/assignmentClass.dart';
import 'package:rxdart/rxdart.dart';

import 'draftClass.dart';

class Profile {
  final Map<String, dynamic> fullNode;

  final String fullName;
  final String mail;
  final List<Draft> drafts;
  final List<Assignment> assignments;
  final Uint8List? image;
  /*
  final List<Assignment> assignments;
  final List<Draft> drafts;

   */

  Profile(this.fullNode, {
    required this.fullName,
    required this.mail,
    required this.assignments,
    required this.drafts,
    required this.image,
    /*
    this.assignments = const [],
    this.drafts = const [],
     */
  });
}
