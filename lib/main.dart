import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'homepage.dart';
import 'performer.dart';
import 'performermanager.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (BuildContext context) => DataStore(),
    child: const JamNight(),
  ));
}

class DataStore extends ChangeNotifier {
  final Logger logger = Logger();

  List<Performer> _performers = [];

  List<Performer> get data => _performers;

  void addPerformer(Performer performer) {
    logger.i("Adding performer: ${performer.name}");
    _performers.add(performer);
    notifyListeners();
  }

  void removePerformer(String performerName) {
    logger.i("Removing performer: $performerName");
    _performers.removeWhere((Performer p) => p.name == performerName);
    notifyListeners();
  }
}

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
            const HomePage(title: "Jam Night Home Page"),
        '/performermanager': (BuildContext context) => PerformerManager(
              onPerformerCreated: dataStore.addPerformer,
              onPerformerRemoved: dataStore.removePerformer,
            )
      },
    );
  }
}
