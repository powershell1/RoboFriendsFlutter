import 'package:flutter/material.dart';
import 'package:robo_friends/classes/profileClass.dart';
import 'package:robo_friends/pages/inside/scaffoldTemplate.dart';
import 'package:robo_friends/pages/inside/navigator/home_page.dart';
import 'package:robo_friends/pages/inside/silver_page.dart';

class AuthExternal {
  static Profile? profile;
  static final Widget homepage = HomePage();

  static Future<bool> login(String username, String password, BuildContext context) {
    if (username == 'admin' && password == 'root') {
      _redirectHomePage(context);
      return Future.value(true);
    }

    return Future.value(false);
  }

  static void _redirectHomePage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => homepage,
      ),
          (Route<dynamic> route) =>
      false, // this will remove all previous routes
    );
  }

  static void logout() {
    // Logout logic
  }
}