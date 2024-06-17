import 'package:flutter/material.dart';
import 'package:robo_friends/pages/inside/home_template.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return HomeTemplate(
      title: 'Home',
      body: Center(
        child: Text('Home Page'),
      ),
      navigationBar: ENavigationBar.home,
      actions: <Widget>[
        Container(
          width: kToolbarHeight / 1.25,
          height: kToolbarHeight / 1.25,
          margin: const EdgeInsets.only(right: kToolbarHeight / 2, top: 5),
          /*
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0x7fffffff),
              width: 3,
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

}