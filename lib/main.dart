import 'package:flutter/material.dart';
import 'bandmanager.dart';

void main() {
  runApp(const JamNight());
}

class JamNight extends StatelessWidget {
  const JamNight({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jam Night',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BandManager(title: 'Jam Night'),
    );
  }
}
