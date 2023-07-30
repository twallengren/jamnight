import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'bandmanager/bandmanager.dart';
import 'homepage/homepage.dart';
import 'performermanager/performermanager.dart';

class JamNight extends StatefulWidget {
  const JamNight({super.key, required this.title});

  final String title;

  @override
  State<JamNight> createState() => _JamNightState();
}

class _JamNightState extends State<JamNight> {
  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => const HomePage(),
        '/performermanager': (BuildContext context) => const PerformerManager(),
        '/bandmanager': (BuildContext context) => const BandManager(),
      },
    );
  }
}
