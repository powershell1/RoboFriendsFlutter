import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robo_friends/external/animated_widget.dart';
import 'package:robo_friends/main.dart';
import 'package:robo_friends/pages/outside/widget/neon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key, required this.type});

  final int type;

  @override
  State<WelcomePage> createState() => _WelcomePageState(type);
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  late AnimationController looped;
  late CurvedAnimation curve;

  final int _currentPage;
  final int _totalPages = 2;

  double sinY = 0;

  _WelcomePageState(this._currentPage);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    looped = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    looped.repeat();
    looped.addListener(() {
      sinY = sin(looped.value * 2 * pi) / 20;
      setState(() {});
    });
    curve = CurvedAnimation(parent: controller, curve: Curves.ease);
    animation = Tween<double>(begin: 0, end: 1).animate(curve)
      ..addListener(() {});
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    looped.dispose();
    super.dispose();
  }

  final List<String> _btn = ['Get Started', 'Next Step'];

  final List<String> _title = ['Easy to code', 'Device friendly'];
  final List<String> _description = [
    'With your imagination,\nyou can create anything you want.',
    'Easily switch between devices\nand continue where you left off.'
  ];

  void _onPressed() {
    if (animation.value != 1.0) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setBool('welcome', true);
      });
      return;
    }
    if (_currentPage == _totalPages - 1) {
      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WelcomePage(type: _currentPage + 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    double sWidth = screen.width;
    List<double> iconSizes = [sWidth / 3, sWidth / 2];

    double animationValue = animation.value;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: App.theme.brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FractionalTranslation(
              translation: Offset(0.0, sinY - 0.2),
              child: AnimatedWidget_External(
                progress: animationValue,
                opacity: 1,
                translation: 0.1,
                child: Image.asset(
                  'assets/icons/${_currentPage == 0 ? 'idea' : _currentPage == 1 ? 'ipad_phone' : 'idea'}.png',
                  width: iconSizes[_currentPage],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AnimatedWidget_External(
              progress: animationValue,
              opacity: 7,
              child: Text(
                _title[_currentPage],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  height: 0,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AnimatedWidget_External(
              progress: animationValue,
              opacity: 8,
              child: Text(
                _description[_currentPage],
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: screen.width - kToolbarHeight * 2,
              child: AnimatedWidget_External(
                progress: animationValue,
                opacity: 19,
                child: NeonButtonWidget(
                  text: _btn[_currentPage],
                  onPressed: _onPressed,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            AnimatedWidget_External(
              progress: animationValue,
              opacity: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int i = 0; i < _totalPages; i++) ...[
                    Container(
                      height: kToolbarHeight / 6,
                      width: kToolbarHeight / 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i <= _currentPage
                            ? const Color(0xFF831EDE)
                            : App.theme.alphaColor(137),
                      ),
                    ),
                    const SizedBox(
                      width: kToolbarHeight / 12,
                    )
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
