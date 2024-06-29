import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:robo_friends/classes/profileClass.dart';
import 'package:robo_friends/main.dart';
import 'package:robo_friends/pages/inside/scaffoldTemplate.dart';
import 'package:robo_friends/pages/inside/navigator/homePage.dart';
import 'package:robo_friends/pages/inside/silver_page.dart';
import 'package:rxdart/rxdart.dart';

import 'draftClass.dart';

class AuthExternal {
  static const Widget homepage = HomePage();
  static BehaviorSubject<Profile?> profileStream = BehaviorSubject<Profile?>();

  static Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      final usersRef = firestore.collection('users');
      usersRef.doc(credential.user!.uid).snapshots().listen((ref) {
        Map<String, dynamic>? user = ref.data();
        Profile profile = Profile(
          fullname: user!['fullname'],
          mail: credential.user!.email!,
          assignments: [],
          drafts: [for (Map<String, dynamic> e in user['drafts']) Draft(title: e['title']!, content: e['content']!)],
        );
        print(storage.ref('profile').child(user['image']).getData());
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        print('Wrong password provided for that user.');
      }
    }
    /*
    if (email == 'admin' && password == 'root') {

      _redirectHomePage(context);
      return Future.value(true);
    }
     */

    return true;
  }

  static void _redirectHomePage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => homepage,
      ),
      (Route<dynamic> route) => false, // this will remove all previous routes
    );
  }

  static void logout() {
    // Logout logic
  }
}
