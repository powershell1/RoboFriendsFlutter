import 'package:flutter/material.dart';

class ThemeTemplate {
  late Brightness brightness = Brightness.light;

  Color get oppositeColor {
    return brightness == Brightness.light ? Colors.black : Colors.white;
  }
  
  Color alphaColor(int alpha) {
    return oppositeColor.withAlpha(alpha);
  }

  final Color btnWelcome1 = const Color(0xFF597AFB);
  final Color btnWelcome2 = const Color(0xFF831EDE);
}
