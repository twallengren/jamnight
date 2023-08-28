import 'package:flutter/material.dart';

import 'recommendedperformerswidget.dart';
import 'selectedperformerswidget.dart';

class BandManager extends StatefulWidget {
  const BandManager({super.key});

  @override
  State<BandManager> createState() => _BandManagerState();
}

class _BandManagerState extends State<BandManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Band Manager'),
      ),
      body: Center(
          child: ListView(
        children: const <Widget>[
          RecommendedPerformersWidget(),
          SelectedPerformersWidget(),
        ],
      )),
    );
  }
}
