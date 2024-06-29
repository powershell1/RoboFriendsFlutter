import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../classes/neonButton.dart';
import '../../../classes/outsideTextbox.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<Register> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  late CurvedAnimation curve;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfController = TextEditingController();

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
    curve = CurvedAnimation(parent: controller, curve: Curves.ease);
    animation = Tween<double>(begin: 0, end: 1).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void register() {
    String email = emailController.text;
    String password = passwordController.text;
    // if (password != passwordConfController.text) return;
    print(email);
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
                          OutsideTextBox(
                            controller: passwordConfController,
                            name: "Re-Password",
                            prefixIcon: Icons.key,
                            inputType: TextInputType.visiblePassword,
                            obscureText: true,
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          NeonButtonWidget(
                            text: "Register",
                            onPressed: register,
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
                                text: "Have an account? ",
                                style: const TextStyle(
                                  color:
                                  Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Login",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.pop(context),
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