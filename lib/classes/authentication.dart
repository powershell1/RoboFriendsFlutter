import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:robo_friends/classes/profileClass.dart';
import 'package:robo_friends/loadingDialog.dart';
import 'package:robo_friends/main.dart';
import 'package:robo_friends/pages/inside/scaffoldTemplate.dart';
import 'package:robo_friends/pages/inside/navigator/homePage.dart';
import 'package:robo_friends/pages/inside/silver_page.dart';
import 'package:rxdart/rxdart.dart';

import 'draftClass.dart';

Future waitWhile(bool Function() test, [Duration pollInterval = Duration.zero]) {
  var completer = Completer();
  check() {
    if (!test()) {
      completer.complete();
    } else {
      Timer(pollInterval, check);
    }
  }
  check();
  return completer.future;
}

class AuthExternal {
  static const Widget homepage = HomePage();
  static BehaviorSubject<Profile?> profileStream = BehaviorSubject<Profile?>();
  static StreamSubscription? profileSubscription;

  static Profile? beforeUpdate;

  static Future<void> initUser(User userData) async {
    print('inited');
    final usersRef = FirebaseFirestore.instance.collection('users');
    final usersData = usersRef.doc(userData.uid);
    bool isDataExist = false;
    /*
    usersData.snapshots().listen((ref) async {
      Map<String, dynamic>? user = ref.data();
      Uint8List? image = await storage
          .ref('profile')
          .child(user!['image'])
          .getData();
      Profile profile = Profile(
        user,
        fullName: user['fullname'],
        mail: userData.email!,
        assignments: [],
        drafts: [
          for (Map<String, dynamic> e in user['drafts'])
            Draft(title: e['title']!, content: e['content']!, assignment: null)
        ],
        image: image,
      );
    });

     */
    profileSubscription = usersData.snapshots().listen((ref) async {
      Map<String, dynamic>? user = ref.data();
      Uint8List? image = await storage
          .ref('profile')
          .child(user!['image'])
          .getData();
      Profile profile = Profile(
        user,
        fullName: user['fullname'],
        mail: userData.email!,
        assignments: [],
        drafts: [
          for (Map<String, dynamic> e in user['drafts'])
            Draft(title: e['title']!, content: e['content']!, assignment: null)
        ],
        image: image,
      );
      // beforeUpdate = profile;
      profileStream.sink.add(profile);
      isDataExist = true;
    });
    await waitWhile(() => !isDataExist);
  }

  static Future<void> updateProfile(String updateName) async {
    if (updateName == 'drafts') {
      Profile profile = profileStream.stream.value!;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(profile.fullNode['uid'])
          .update({
        'drafts': [
          for (Draft e in profile.drafts)
            {
              'title': e.title,
              'content': e.content,
            }
        ]
      });
    }
    /*
    profileStream.stream.listen((event) {
      print(beforeUpdate);
      print(event!.drafts);
      if (beforeUpdate != null) {
        Function eq = const ListEquality().equals;
        if (!eq(beforeUpdate!.drafts, event!.drafts)) {
          print('update!');
        }
      }
      // beforeUpdate = event;
    });

     */
  }

  static Future<bool> login(
      String email, String password, BuildContext context) async {
    final showDialog = LoadingIndicatorDialog();
    showDialog.show(context);
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      await initUser(credential.user!);
      _redirectHomePage(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        print('Wrong password provided for that user.');
      }
    }
    showDialog.dismiss();
    return true;
  }

  static void _redirectHomePage(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  static void logout(BuildContext context) async {
    // Logout logic
    print('hello ');
    // profileSubscription?.cancel();
    await auth.signOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
          (Route<dynamic> route) => false, // this will remove all previous routes
    );
  }
}
