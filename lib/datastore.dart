import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:quiver/collection.dart';
import 'model/performer.dart';
import 'model/instrument/instrument.dart';

class DataStore extends ChangeNotifier {
  final Logger logger = Logger();

  final List<Performer> _performers = [];
  final Multimap<Instrument, Performer> _performersByInstrument =
      Multimap<Instrument, Performer>();
  List<Performer> _selectedBand = [];

  void addPerformer(Performer performer) {
    logger.i('Adding performer: ${performer.name}');
    _performers.add(performer);
    _performersByInstrument.add(performer.instrument, performer);
    List<Performer> performers =
        _performersByInstrument[performer.instrument].toList();
    performers.sort((Performer a, Performer b) =>
        a.getLastPlayed().compareTo(b.getLastPlayed()));
    _performersByInstrument.removeAll(performer.instrument);
    _performersByInstrument.addValues(performer.instrument, performers);
    notifyListeners();
  }

  void removePerformer(String performerName) {
    logger.i('Removing performer: $performerName');
    _performers.removeWhere((Performer p) => p.name == performerName);
    _performersByInstrument.removeWhere(
        (Instrument instrument, Performer performer) =>
            performer.name == performerName);
    notifyListeners();
  }

  void addPerformerToSelectedBand(Performer performer) {
    logger.i('Adding performer to selected band: ${performer.name}');
    _selectedBand.add(performer);
    notifyListeners();
  }

  void removePerformerFromSelectedBand(Performer performer) {
    logger.i('Removing performer from selected band: ${performer.name}');
    _selectedBand.remove(performer);
    notifyListeners();
  }

  void clearSelectedBand() {
    logger.i('Clearing selected band');
    _selectedBand.clear();
    notifyListeners();
  }

  List<Performer> getSelectedBand() {
    return _selectedBand;
  }

  List<Performer> getPerformers() {
    return _performers;
  }

  Multimap<Instrument, Performer> getPerformersByInstrument() {
    return _performersByInstrument;
  }
}
