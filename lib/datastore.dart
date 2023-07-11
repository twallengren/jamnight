import 'package:flutter/material.dart';
import 'package:jamnight/bandmanager/bandselector.dart';
import 'package:logger/logger.dart';
import 'package:quiver/collection.dart';
import 'model/performer/performer.dart';
import 'model/instrument/instrument.dart';
import 'model/performer/performerstatus.dart';

class DataStore extends ChangeNotifier {
  final Logger logger = Logger();

  final List<Performer> _performers = [];
  final Multimap<Instrument, Performer> _performersByInstrument =
      Multimap<Instrument, Performer>();
  List<Performer> _recommendedPerformers = [];
  final List<Performer> _selectedPerformers = [];

  void addPerformer(Performer performer) {
    logger.i('Adding performer: ${performer.name}');

    // list of all performers
    _performers.add(performer);

    // multimap of performers by instrument
    _performersByInstrument.add(performer.instrument, performer);
    _sortPerformersByInstrument();

    // update recommended performers
    _updateRecommendedPerformers();

    notifyListeners();
  }

  void removePerformer(Performer performer) {
    logger.i('Removing performer: ${performer.name}');
    _performers.remove(performer);
    _performersByInstrument
        .removeWhere((Instrument instrument, Performer p) => p == performer);
    _selectedPerformers.remove(performer);
    _updateRecommendedPerformers();
    notifyListeners();
  }

  void movePerformerFromRecommendedToSelected(int rowIndex) {
    logger.i('Moving performer from recommended to selected: $rowIndex');
    Performer performer = _recommendedPerformers[rowIndex];
    performer.setPerformerStatus(PerformerStatus.selected);
    _selectedPerformers.add(_recommendedPerformers[rowIndex]);
    _recommendedPerformers.removeAt(rowIndex);
    _updateRecommendedPerformers();
    notifyListeners();
  }

  void removePerformerFromSelectedPerformers(int rowIndex) {
    logger.i('Removing performer from selected: $rowIndex');
    Performer performer = _selectedPerformers[rowIndex];
    performer.setPerformerStatus(PerformerStatus.present);
    _selectedPerformers.removeAt(rowIndex);
    _updateRecommendedPerformers();
    notifyListeners();
  }

  void finalizeSelectedBand() {
    logger.i('Finalizing selected band');
    for (Performer performer in _selectedPerformers) {
      performer.setPerformerStatus(PerformerStatus.present);
      performer.setLastPlayed(DateTime.now());
    }
    _selectedPerformers.clear();
    _sortPerformersByInstrument();
    _updateRecommendedPerformers();
    notifyListeners();
  }

  void _updateRecommendedPerformers() {
    _recommendedPerformers = BandSelector.getRecommendedPerformers(this);
  }

  void _sortPerformersByInstrument() {
    for (Instrument instrument in Instrument.values) {
      List<Performer> performersForInstrument =
          _performersByInstrument[instrument].toList();
      performersForInstrument.sort((Performer a, Performer b) =>
          a.getLastPlayed().compareTo(b.getLastPlayed()));
      _performersByInstrument.removeAll(instrument);
      _performersByInstrument.addValues(instrument, performersForInstrument);
    }
  }

  List<Performer> getRecommendedPerformers() {
    return _recommendedPerformers;
  }

  List<Performer> getSelectedPerformers() {
    return _selectedPerformers;
  }

  List<Performer> getPerformers() {
    return _performers;
  }

  Multimap<Instrument, Performer> getPerformersByInstrument() {
    return _performersByInstrument;
  }
}
