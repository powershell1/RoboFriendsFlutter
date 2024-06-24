import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:robo_friends/external/auth_external.dart';
import 'package:robo_friends/pages/outside/widget/neon_button.dart';

import '../../main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class TextBox extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  final IconData prefixIcon;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;

  const TextBox({
    Key? key,
    required this.controller,
    required this.name,
    required this.prefixIcon,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    required this.inputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color borderColor = App.theme.brightness == Brightness.dark
        ? const Color(0xFF4CCD99)
        : const Color(0xFF007F73);

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        enabled: true,
        controller: controller,
        textCapitalization: textCapitalization,
        maxLength: 32,
        maxLines: 1,
        obscureText: obscureText,
        keyboardType: inputType,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: App.theme.oppositeColor,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon),
          isDense: true,
          labelText: name,
          counterText: "",
          labelStyle:
              TextStyle(color: App.theme.alphaColor(137)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: App.theme.alphaColor(137)),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
    );
  }
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
          decoration: BoxDecoration(
            color: Colors.white10,
            shape: BoxShape.circle,
            border: Border.fromBorderSide(BorderSide(
              color: App.theme.oppositeColor,
              width: 1.0,
            )),
          ),
          child: ColorFiltered(
            colorFilter:
                isApple && App.theme.brightness == Brightness.dark
                    ? const ColorFilter.matrix(<double>[
                        -1.0, 0.0, 0.0, 0.0, 255.0, //
                        0.0, -1.0, 0.0, 0.0, 255.0, //
                        0.0, 0.0, -1.0, 0.0, 255.0, //
                        0.0, 0.0, 0.0, 1.0, 0.0, //
                      ])
                    : const ColorFilter.matrix(<double>[
                        1.0, 0.0, 0.0, 0.0, 0.0, //
                        0.0, 1.0, 0.0, 0.0, 0.0, //
                        0.0, 0.0, 1.0, 0.0, 0.0, //
                        0.0, 0.0, 0.0, 1.0, 0.0, //
                      ]),
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
    text: "admin",
  );
  final TextEditingController passwordController = TextEditingController(
    text: "root",
  );

  bool isAnimated = false;
  bool isClicked = false;

  Color get textColor {
    return App.theme.brightness == Brightness.dark
        ? const Color(0xFF4CCD99)
        : const Color(0xFF007F73);
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
                          TextBox(
                            controller: emailController,
                            name: "Email",
                            prefixIcon: Icons.email,
                            inputType: TextInputType.emailAddress,
                          ),
                          TextBox(
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
                                style: TextStyle(
                                  color:
                                  App.theme.oppositeColor,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Sign up",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        if (!isAnimated) return;
                                        setState(() {});
                                        if (controller.isCompleted) {
                                          controller.reverse();
                                          return;
                                        }
                                        controller.forward();
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
