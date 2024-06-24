import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      size: active ? 30 : 25,
      color: active ? Colors.white : Colors.grey[200],
    );
  }
}

class InsideTemplate extends StatelessWidget {
  final Widget body;
  final String title;
  final List<Widget> actions;
  final ENavigationBar? navigationBar;

  const InsideTemplate(
      {super.key,
      required this.body,
      required this.title,
      this.actions = const [],
      this.navigationBar});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double lowestFrame = width < height ? width : height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight * 2),
        // here the desired height
        child: AppBar(
          toolbarHeight: kToolbarHeight * 2,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF007F73),
                  Color(0xFF4CCD99),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          centerTitle: false,
          title: Transform(
            // you can forcefully translate values left side using Transform
            transform: Matrix4.translationValues(
                kToolbarHeight / 4, kToolbarHeight / 2, 0),
            child: Text(
              title,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w800,
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
        ),
      ),
      body: Stack(
        children: <Widget>[
          body,
          if (navigationBar != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Container(
                  height: kToolbarHeight,
                  width: lowestFrame,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFF4CCD99),
                    /*
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF4CCD99),
                        Color(0xFF007F73),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),

                     */
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const SizedBox(width: 25),
                      IconButton(
                        icon: CustomIcon(
                            icon: Icons.home,
                            unIcon: Icons.home_outlined,
                            active: navigationBar == ENavigationBar.home),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, "/context/home");
                        },
                      ),
                      IconButton(
                        icon: CustomIcon(
                            icon: Icons.drafts,
                            unIcon: Icons.drafts_outlined,
                            active: navigationBar == ENavigationBar.draft),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, "/context/draft");
                        },
                      ),
                      IconButton(
                        icon: CustomIcon(
                            icon: Icons.control_camera,
                            unIcon: Icons.control_camera_outlined,
                            active: navigationBar == ENavigationBar.control),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, "/context/control");
                        },
                      ),
                      IconButton(
                        icon: CustomIcon(
                            icon: Icons.assignment,
                            unIcon: Icons.assessment_outlined,
                            active: navigationBar == ENavigationBar.test),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, "/context/test");
                        },
                      ),
                      const SizedBox(width: 25),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      /*
      bottomNavigationBar: navigationBar == null
          ? null
          : Container(
              height: kToolbarHeight * 1.5,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gradient: LinearGradient(
                  colors: [
                    Colors.greenAccent,
                    Colors.green,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const SizedBox(width: 10),
                    IconButton(
                      icon: CustomIcon(
                          icon: Icons.home,
                          unIcon: Icons.home_outlined,
                          active: navigationBar == ENavigationBar.home),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, "/context/home");
                      },
                    ),
                    IconButton(
                      icon: CustomIcon(
                          icon: Icons.drafts,
                          unIcon: Icons.drafts_outlined,
                          active: navigationBar == ENavigationBar.draft),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, "/context/draft");
                      },
                    ),
                    IconButton(
                      icon: CustomIcon(
                          icon: Icons.control_camera,
                          unIcon: Icons.control_camera_outlined,
                          active: navigationBar == ENavigationBar.control),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, "/context/control");
                      },
                    ),
                    IconButton(
                      icon: CustomIcon(
                          icon: Icons.assignment,
                          unIcon: Icons.assessment_outlined,
                          active: navigationBar == ENavigationBar.test),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, "/context/test");
                      },
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
       */
    );
  }
}
