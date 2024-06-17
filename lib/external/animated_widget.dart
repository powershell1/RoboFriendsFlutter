import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedWidget_External extends StatelessWidget {
  AnimatedWidget_External({
    super.key,
    required this.progress,
    required this.child,
    required this.opacity,
    this.translation,
  });

  final double progress;
  final double opacity;
  double? translation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget opacityWidget = Opacity(
      opacity: max((progress * opacity) - (opacity - 1), 0),
      child: child,
    );
    return translation == null
        ? opacityWidget
        : FractionalTranslation(
      translation: Offset(0.0, progress * translation!),
      child: opacityWidget,
    );
  }
}