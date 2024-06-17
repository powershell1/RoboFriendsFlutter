import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NeonButtonWidget extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final Color gradientStart;
  final Color gradientEnd;

  const NeonButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradientStart = const Color(0xFF597AFB),
    this.gradientEnd = const Color(0xFF831EDE),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        height: kToolbarHeight / 1.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: LinearGradient(
            colors: [
              gradientStart,
              gradientEnd,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: gradientStart.withOpacity(0.6),
              spreadRadius: 1.0,
              blurRadius: 12.0,
              offset: const Offset(-2, 0),
            ),
            BoxShadow(
              color: gradientEnd.withOpacity(0.6),
              spreadRadius: 1.0,
              blurRadius: 12.0,
              offset: const Offset(2, 0),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }
}
