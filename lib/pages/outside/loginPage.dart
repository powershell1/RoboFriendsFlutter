import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:robo_friends/classes/authentication.dart';
import 'package:robo_friends/classes/neonButton.dart';

import '../../classes/outsideTextbox.dart';
import '../../main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class SignInWith extends StatelessWidget {
  const SignInWith({
    super.key,
    required this.image,
    required this.animation,
    required this.progress,
  });

  final String image;
  final int animation;
  final double progress;

  bool get isApple => image == "assets/icons/companies/apple.png";

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: Offset(0.0, (1 - progress) * -(animation - (animation - 1))),
      child: Opacity(
        opacity: max(progress * animation - (animation - 1), 0),
        child: Container(
          height: kToolbarHeight,
          width: kToolbarHeight,
          decoration: const BoxDecoration(
            color: Colors.white10,
            shape: BoxShape.circle,
            border: Border.fromBorderSide(BorderSide(
              color: Colors.black,
              width: 1.0,
            )),
          ),
          child: ColorFiltered(
            colorFilter:
                isApple ? const ColorFilter.matrix(<double>[
                        1.0, 0.0, 0.0, 0.0, 0.0, //
                        0.0, 1.0, 0.0, 0.0, 0.0, //
                        0.0, 0.0, 1.0, 0.0, 0.0, //
                        0.0, 0.0, 0.0, 1.0, 0.0, //
                      ]) : const ColorFilter.mode(
                        Colors.transparent,
                        BlendMode.srcIn,
                      ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Image.asset(
                image,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  late CurvedAnimation curve;

  final TextEditingController emailController = TextEditingController(
    text: "pummiphach@hotmail.com",
  );
  final TextEditingController passwordController = TextEditingController(
    text: "1010_vV200",
  );

  bool isAnimated = false;
  bool isClicked = false;

  Color get textColor {
    return const Color(0xFF007F73);
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    curve = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    animation = Tween<double>(begin: 0, end: 1).animate(curve)
      ..addListener(() {
        if (animation.value == 1) {
          isAnimated = true;
        }
        setState(() {});
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void login() {
    AuthExternal.login(
      emailController.text,
      passwordController.text,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: screen.width - kToolbarHeight * 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          const Text(
                            "Welcome back!",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          OutsideTextBox(
                            controller: emailController,
                            name: "Email",
                            prefixIcon: Icons.email,
                            inputType: TextInputType.emailAddress,
                          ),
                          OutsideTextBox(
                            controller: passwordController,
                            name: "Password",
                            prefixIcon: Icons.key,
                            inputType: TextInputType.visiblePassword,
                            obscureText: true,
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          NeonButtonWidget(
                            text: "Login",
                            onPressed: login,
                            gradientStart: const Color(0xFF4CCD99),
                            gradientEnd: const Color(0xFF007F73),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Opacity(
                            opacity: max(animation.value * 4 - 3, 0),
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: const TextStyle(
                                  color:
                                  Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Sign up",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(context, '/register');
                                      },
                                    style: TextStyle(
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      /*
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SignInWith(
                            progress: animation.value,
                            animation: 7,
                            image: "assets/icons/companies/google.png",
                          ),
                          const SizedBox(
                            width: 14.0,
                          ),
                          SignInWith(
                            progress: animation.value,
                            animation: 10,
                            image: "assets/icons/companies/microsoft.png",
                          ),
                          const SizedBox(
                            width: 14.0,
                          ),
                          SignInWith(
                            progress: animation.value,
                            animation: 13,
                            image: "assets/icons/companies/apple.png",
                          ),
                        ],
                      ),
                       */
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
