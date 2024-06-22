import 'dart:math';
import 'package:flutter/material.dart';

enum ENavigationBar { home, draft, control, test }

class CustomIcon extends StatelessWidget {
  final IconData icon;
  final IconData unIcon;
  final bool active;

  const CustomIcon({
    super.key,
    required this.icon,
    required this.active,
    required this.unIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      active ? icon : unIcon,
      color: active ? Colors.white : Colors.grey,
    );
  }
}

class HomeTemplate extends StatelessWidget {
  final Widget body;
  final String title;
  final List<Widget> actions;
  final ENavigationBar navigationBar;

  const HomeTemplate(
      {super.key,
      required this.body,
      required this.title,
      required this.actions,
      required this.navigationBar});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight * 1.5),
        // here the desired height
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: AppBar(
            centerTitle: false,
            title: Transform(
              // you can forcefully translate values left side using Transform
              transform: Matrix4.translationValues(
                  kToolbarHeight / 4, kToolbarHeight / 8, 0),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: kToolbarHeight / 1.75,
                ),
              ),
            ),
            actions: actions,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: SizedBox(
                width: width - 40,
                child: const Divider(
                  color: Colors.white,
                  thickness: 1.0,
                ),
              ),
            ),
            backgroundColor: const Color(0xff131314),
          ),
        ),
      ),
      body: body,
      bottomNavigationBar: Container(
        height: kToolbarHeight * 1.5,
        color: const Color(0xff131314),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: CustomIcon(
                    icon: Icons.home,
                    unIcon: Icons.home_outlined,
                    active: navigationBar == ENavigationBar.home),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/context/home");
                },
              ),
              IconButton(
                icon: CustomIcon(
                    icon: Icons.drafts,
                    unIcon: Icons.drafts_outlined,
                    active: navigationBar == ENavigationBar.draft),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/context/draft");
                },
              ),
              IconButton(
                icon: CustomIcon(
                    icon: Icons.control_camera,
                    unIcon: Icons.control_camera_outlined,
                    active: navigationBar == ENavigationBar.control),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/context/control");
                  },
              ),
              IconButton(
                icon: CustomIcon(
                    icon: Icons.assignment,
                    unIcon: Icons.assessment_outlined,
                    active: navigationBar == ENavigationBar.test),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/context/test");
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
