import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'model/performer.dart';

class DataStore extends ChangeNotifier {
  final Logger logger = Logger();

  final List<Performer> _performers = [];

  void addPerformer(Performer performer) {
    logger.i('Adding performer: ${performer.name}');
    _performers.add(performer);
    notifyListeners();
  }

  void removePerformer(String performerName) {
    logger.i('Removing performer: $performerName');
    _performers.removeWhere((Performer p) => p.name == performerName);
    notifyListeners();
  }

  List<Performer> getPerformers() {
    return _performers;
  }
}
