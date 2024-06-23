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

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return InsideTemplate(
      title: 'Home',
      body: Container(
        color: Color(0xffEFEFEF),
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 32, top: 8, right: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              buildColumn("Assignment", badge: "3", children: <Widget>[
                buildChild(width: 200, height: 100),
                buildChild(width: 200, height: 100),
                buildChild(width: 200, height: 100),
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

  Widget buildChild({double width = 100, double height = 100}) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
