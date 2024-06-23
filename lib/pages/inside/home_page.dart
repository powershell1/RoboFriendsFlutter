import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robo_friends/pages/inside/inside_template.dart';
import 'package:badges/badges.dart' as badges;

class HomePage extends StatefulWidget {
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
  @override
  Widget build(BuildContext context) {
    List<String> assignment = ["Blink LED"];

    return InsideTemplate(
      title: 'Home',
      body: Container(
        color: const Color(0xffEFEFEF),
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 32, top: 8, right: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              buildColumn("Assignment",
                  badge: assignment.length.toString(),
                  children: <Widget>[
                    if (assignment.isNotEmpty)
                      for (String assign in assignment)
                        buildChild(
                          width: 200,
                          height: 100,
                          onPressed: () {
                            Navigator.pushNamed(context, '/context/assignments',
                                arguments: {
                                  'title': assign,
                                });
                          },
                          child: Center(
                            child: Text(
                              assign,
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    if (assignment.isEmpty)
                      Container(
                        width: MediaQuery.of(context).size.width - 64,
                        height: 125,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
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
                                'You have no assignment due.',
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    /*
                buildChild(width: 200, height: 100),
                buildChild(width: 200, height: 100),
                buildChild(width: 200, height: 100),
                buildChild(
                    width: 100,
                    height: 100,
                    onPressed: () {
                      print('hello');
                    },
                    child: Center(
                      child: Text(
                        'View All',
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
                    */
                  ]),
              buildColumn("Available Lessons", children: <Widget>[
                buildChild(width: 150, height: 150),
                buildChild(width: 150, height: 150),
              ]),
            ],
          ),
        ),
      ),
      navigationBar: ENavigationBar.home,
      actions: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: kToolbarHeight / 2, top: 5),
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
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: ClipRRect(
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
      ),
    );
  }

  Widget buildColumn(String featName,
      {List<Widget> children = const [], String? badge}) {
    Widget featWidget = Text(
      featName,
      style: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: badge != null
                ? badges.Badge(
                    badgeAnimation: const badges.BadgeAnimation.rotation(),
                    badgeContent: Text(
                      badge,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: featWidget,
                  )
                : featWidget,
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
