import 'package:robo_friends/classes/assignmentClass.dart';
import 'package:rxdart/rxdart.dart';

import 'draftClass.dart';

class Profile {
  final String fullname;
  final String mail;
  final List<Draft> drafts;
  final List<Assignment> assignments;
  /*
  final List<Assignment> assignments;
  final List<Draft> drafts;

   */

  Profile({
    required this.fullname,
    required this.mail,
    required this.assignments,
    required this.drafts,
    /*
    this.assignments = const [],
    this.drafts = const [],
     */
  });
}
