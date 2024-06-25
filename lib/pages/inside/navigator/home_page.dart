import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robo_friends/pages/inside/scaffoldTemplate.dart';
import 'package:badges/badges.dart' as badges;

import '../../../classes/assignmentClass.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

/*
badges.Badge(
                          badgeStyle: badges.BadgeStyle(
                            shape: badges.BadgeShape.square,
                            badgeColor: Colors.blue,
                            padding: const EdgeInsets.all(5.5),
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xffEFEFEF),
                              width: 3,
                            ),
                            badgeGradient: const badges.BadgeGradient.linear(
                              colors: [Colors.purple, Colors.blueAccent],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          badgeContent: Text(
                            'NEW',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child:
 */

class _HomePageState extends State<HomePage> {
  void viewOldAssignments() {
    print('view old assignments');
    // Navigator.pushNamed(context, '/context/assignments');
  }

  @override
  Widget build(BuildContext context) {
    return InsideTemplate(
      title: 'Home',
      body: Container(
        color: const Color(0xffEFEFEF),
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 32, top: 8, right: 32),
          child: SingleChildScrollView(
            clipBehavior: Clip.none,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                StreamBuilder<List<Assignment>>(
                  stream: AssignmentList.assignList.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return buildColumn(
                        "Assignment",
                        badge: snapshot.data!.length.toString(),
                        children: <Widget>[
                          if (snapshot.data!.isNotEmpty)
                            for (Assignment assign in snapshot.data!) ...[
                              buildChild(
                                width: 200,
                                height: 100,
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/context/assignments',
                                      arguments: assign);
                                },
                                child: Center(
                                  child: Text(
                                    assign.title,
                                    style: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          if (snapshot.data!.isEmpty) ...[
                            buildChild(
                              width: MediaQuery.of(context).size.width - 64,
                              height: 125,
                              onPressed: viewOldAssignments,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 50,
                                    ),
                                    Text(
                                      'No assignment due.',
                                      style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ] else
                            buildChild(
                              width: 100,
                              height: 100,
                              onPressed: viewOldAssignments,
                              child: Center(
                                child: Text(
                                  'View All',
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
                buildColumn("Available Lessons", children: <Widget>[
                  buildChild(width: 150, height: 150),
                  const SizedBox(width: 10),
                  buildChild(width: 150, height: 150),
                ]),
                const SizedBox(height: kToolbarHeight * 1.5),
              ],
            ),
          ),
        ),
      ),
      navigationBar: ENavigationBar.home,
      actions: <Widget>[
        Container(
          width: kToolbarHeight,
          height: kToolbarHeight,
          margin: const EdgeInsets.only(right: kToolbarHeight / 1.75),
          /*
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xffA0A0A0),
              width: 2,
            ),
          ),
           */
          child: ClipOval(
            child: Image.network(
              'https://picsum.photos/250?image=9',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildChild(
      {double width = 100,
      double height = 100,
      Widget child = const SizedBox(),
      Function? onPressed}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Material(
        child: InkWell(
            onTap: onPressed as void Function()?,
            child: SizedBox(
              width: width,
              height: height,
              child: child,
            )),
      ),
    );
  }

  Widget buildColumn(String featName,
      {List<Widget> children = const [], String? badge}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: badges.Badge(
              showBadge: badge != '0' && badge != null,
              badgeAnimation: const badges.BadgeAnimation.rotation(),
              badgeContent: Text(
                badge ?? '',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text(
                featName,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Align(
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}
