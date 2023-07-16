import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'bandmanager/bandmanager.dart';
import 'datastore.dart';
import 'homepage/homepage.dart';
import 'performermanager/performermanager.dart';

class JamNight extends StatefulWidget {
  const JamNight({super.key});

  @override
  State<JamNight> createState() => _JamNightState();
}

class _JamNightState extends State<JamNight> {
  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    var dataStore = Provider.of<DataStore>(context, listen: false);
    return MaterialApp(
      title: 'Jam Night',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) =>
            const HomePage(title: 'Jam Night Home Page'),
        '/performermanager': (BuildContext context) =>
            PerformerManager(onPerformerCreated: dataStore.addPerformer),
        '/bandmanager': (BuildContext context) =>
            const BandManager(title: 'Band Manager'),
      },
    );
  }
}
