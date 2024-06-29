import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robo_friends/pages/inside/scaffoldTemplate.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<StatefulWidget> createState() => _TestPageState();
}

enum ETestDifficulty {
  pre,
  post,
  end,
}

class _TestPageState extends State<TestPage> {
  Widget craftChildList(ETestDifficulty difficulty, {Function? onTap}) {
    Color bgColor = difficulty == ETestDifficulty.pre
        ? const Color(0xff00C34E)
        : difficulty == ETestDifficulty.post
            ? const Color(0xffDD8500)
            : const Color(0xffDD0000);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Material(
          child: InkWell(
            highlightColor: Colors.white,
            onTap: onTap as void Function()?,
            child: Container(
              height: 100,
              color: const Color(0xff272727),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Transform.rotate(
                      angle: -pi / 2,
                      child: SvgPicture.asset(
                        difficulty != ETestDifficulty.pre
                            ? 'assets/post_stage.svg'
                            : 'assets/school_stage.svg',
                        placeholderBuilder: (context) => const SizedBox(),
                        color: bgColor,
                        height: 65,
                        width: 65,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Transform.rotate(
                      angle: pi / 2,
                      child: SvgPicture.asset(
                        difficulty == ETestDifficulty.end
                            ? 'assets/post_stage.svg'
                            : 'assets/school_stage.svg',
                        placeholderBuilder: (context) => const SizedBox(),
                        color: bgColor,
                        height: 65,
                        width: 65,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Stack(
                      children: [
                        Text(
                          'Pre Basic Control',
                          style: GoogleFonts.inter(
                            color: bgColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                        ),
                        if (difficulty != ETestDifficulty.pre)
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'required for grading',
                              style: GoogleFonts.inter(
                                color: Colors.white.withAlpha(150),
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InsideTemplate(
      title: 'Tests',
      body: Container(
        color: const Color(0xffEFEFEF),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: <Widget>[
              craftChildList(ETestDifficulty.pre, onTap: () {
                Navigator.pushNamed(context, '/context/test',
                    arguments: {'id': 0});
              }),
            ],
          ),
        ),
      ),
      navigationBar: ENavigationBar.test,
      // actions: <Widget>[],
    );
  }
}
