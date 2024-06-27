// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:collection';
import 'dart:math' as _math;

import 'package:flutter/material.dart';

import '../models/gestures.dart';
import '../models/pad_button_item.dart';
import 'circle_view.dart';

typedef PadButtonPressedCallback = void Function(
    int buttonIndex, Gestures gesture);

class PadbuttonsView extends StatelessWidget {
  /// [size]: optional; space for background circle of all pad buttons.
  /// Will be recalculated for pad button sizes.
  ///
  /// Default value calculated according to screen size.
  final double? size;

  /// List of pad buttons, default contains 4
  final List<PadButtonItem>? buttons;

  /// [padButtonPressedCallback]: contains information which button (index)
  /// was used by user
  final PadButtonPressedCallback? padButtonPressedCallback;

  /// [buttonsStateMap] contains current colors of each button.
  final Map<int, Color>? buttonsStateMap = HashMap<int, Color>();

  /// [buttonsPadding]: optional; adds paddings to buttons
  final double? buttonsPadding;

  /// [backgroundPadButtonsColor]: optional; shows circle when set
  final Color? backgroundPadButtonsColor;

  PadbuttonsView({
    super.key,
    this.size,
    this.buttons = const [
      PadButtonItem(index: 0, buttonText: 'A'),
      PadButtonItem(index: 1, buttonText: 'B', pressedColor: Colors.red),
      PadButtonItem(index: 2, buttonText: 'C', pressedColor: Colors.green),
      PadButtonItem(index: 3, buttonText: 'D', pressedColor: Colors.yellow),
    ],
    this.padButtonPressedCallback,
    this.buttonsPadding = 0,
    this.backgroundPadButtonsColor = Colors.transparent,
  }) : assert(buttons != null && buttons.isNotEmpty) {
    // ignore: avoid_function_literals_in_foreach_calls
    buttons!.forEach(
        (button) => buttonsStateMap![button.index!] = button.backgroundColor!);
  }

  @override
  Widget build(BuildContext context) {
    double? actualSize = size ??
        _math.min(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height) *
            0.5;
    double? innerCircleSize = actualSize / 3;

    return Center(
        child: Stack(children: createButtons(innerCircleSize, actualSize)));
  }

  List<Widget> createButtons(double innerCircleSize, double actualSize) {
    /// [list] uses the literal instead of constructor due to null-safety
    List<Widget>? list = [];
    list.add(CircleView.padBackgroundCircle(
        actualSize,
        backgroundPadButtonsColor,
        backgroundPadButtonsColor != Colors.transparent
            ? Colors.black45
            : Colors.transparent,
        backgroundPadButtonsColor != Colors.transparent
            ? Colors.black12
            : Colors.transparent));

    for (var i = 0; i < buttons!.length; i++) {
      var padButton = buttons![i];
      list.add(createPositionedButtons(
        padButton,
        actualSize,
        i,
        innerCircleSize,
      ));
    }
    return list;
  }

  Positioned createPositionedButtons(PadButtonItem padButton, double actualSize,
      int index, double innerCircleSize) {
    return Positioned(
      top: _calculatePositionYOfButton(index, innerCircleSize, actualSize),
      left: _calculatePositionXOfButton(index, innerCircleSize, actualSize),
      child: StatefulBuilder(builder: (context, setState) {
        return GestureDetector(
          onTap: () {
            _processGesture(padButton, Gestures.tap);
          },
          onTapUp: (details) {
            _processGesture(padButton, Gestures.tapUp);
            Future.delayed(const Duration(milliseconds: 50), () {
              setState(() => buttonsStateMap![padButton.index!] =
                  padButton.backgroundColor!);
            });
          },
          onTapDown: (details) {
            _processGesture(padButton, Gestures.tapDown);

            setState(() =>
                buttonsStateMap![padButton.index!] = padButton.pressedColor!);
          },
          onTapCancel: () {
            _processGesture(padButton, Gestures.tapCancel);

            setState(() => buttonsStateMap![padButton.index!] =
                padButton.backgroundColor!);
          },
          onLongPress: () {
            _processGesture(padButton, Gestures.longPress);
          },
          onLongPressStart: (details) {
            _processGesture(padButton, Gestures.longPressStart);

            setState(() =>
                buttonsStateMap![padButton.index!] = padButton.pressedColor!);
          },
          onLongPressUp: () {
            _processGesture(padButton, Gestures.longPressUp);

            setState(() => buttonsStateMap![padButton.index!] =
                padButton.backgroundColor!);
          },
          child: Padding(
            padding: EdgeInsets.all(buttonsPadding!),
            child: CircleView.padButtonCircle(
                innerCircleSize,
                buttonsStateMap![padButton.index]!,
                padButton.buttonImage!,
                padButton.buttonIcon!,
                padButton.buttonText!),
          ),
        );
      }),
    );
  }

  void _processGesture(PadButtonItem button, Gestures gesture) {
    if (padButtonPressedCallback != null &&
        button.supportedGestures.contains(gesture)) {
      padButtonPressedCallback!(button.index!, gesture);
      debugPrint('$gesture padbutton id = ${[button.index]}');
    }
  }

  double _calculatePositionXOfButton(
      int index, double innerCircleSize, double actualSize) {
    double? degrees = 360 / buttons!.length * index;
    double? lastAngleRadians = (degrees) * (_math.pi / 180.0);

    var rBig = actualSize / 2;
    var rSmall = (innerCircleSize + 2 * buttonsPadding!) / 2;

    return (rBig - rSmall) + (rBig - rSmall) * _math.cos(lastAngleRadians);
  }

  double _calculatePositionYOfButton(
      int index, double innerCircleSize, double actualSize) {
    double? degrees = 360 / buttons!.length * index;
    double? lastAngleRadians = (degrees) * (_math.pi / 180.0);
    var rBig = actualSize / 2;
    var rSmall = (innerCircleSize + 2 * buttonsPadding!) / 2;

    return (rBig - rSmall) + (rBig - rSmall) * _math.sin(lastAngleRadians);
  }
}
