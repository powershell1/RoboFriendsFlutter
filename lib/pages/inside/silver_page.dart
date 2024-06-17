import 'package:flutter/material.dart';

class SilverPage extends StatefulWidget {
  const SilverPage({super.key});

  @override
  State<SilverPage> createState() => _SilverPageState();
}

class _SilverPageState extends State<SilverPage> {
  _SilverPageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 160.0,
            stretchTriggerOffset: 300.0,
            pinned: true,
            backgroundColor: Colors.blueGrey[900],
            leading: IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(bottom: 20.0),
              title: const Text('How?'),
              background: Image.network(
                'https://picsum.photos/2048',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(
                  title: Text('Item #$index'),
                );
              },
              childCount: 1000,
            ),
          ),
        ],
      ),
    );
  }
}
