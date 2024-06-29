import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoadingIndicatorDialog {
  static final LoadingIndicatorDialog _instance = LoadingIndicatorDialog._internal();
  late BuildContext _context;
  bool isDisplayed = false;

  factory LoadingIndicatorDialog() {
    return _instance;
  }
  LoadingIndicatorDialog._internal();

  show(BuildContext context) {
    isDisplayed = true;
    _context = context;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff55AD9B)),
          ),
        );
      },
    );
  }

  dismiss() {
    if (isDisplayed && Navigator.of(_context).canPop()) {
      Navigator.of(_context).pop();
      isDisplayed = false;
    }
  }
}