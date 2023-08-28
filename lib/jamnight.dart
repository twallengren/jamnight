import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'bandmanager/bandmanager.dart';
import 'data/datastore.dart';
import 'homepage/homepage.dart';
import 'performermanager/performermanager.dart';
import 'performermanager/performermanagermodel.dart';

class JamNight extends StatelessWidget {
  JamNight({super.key, required this.title, required this.dataStore});

  final String title;
  final DataStore dataStore;

  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => const HomePage(),
        '/performermanager': (BuildContext context) =>
            ChangeNotifierProvider<PerformerManagerModel>(
                create: (BuildContext context) => PerformerManagerModel(dataStore),
                child: const PerformerManager()),
        '/bandmanager': (BuildContext context) => const BandManager(),
      },
    );
  }
}
