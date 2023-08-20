import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:quiver/collection.dart';

import '../model/instrument/instrument.dart';
import '../model/performer/performer.dart';
import '../model/performer/performerstatus.dart';
import 'datastoreevent.dart';
import 'jamnightdao.dart';

class DataStore extends ChangeNotifier {
  final Logger logger = Logger();
  final List<Performer> _allPerformers = [];
  final List<Performer> _currentJamPerformers = [];
  final Multimap<Instrument, Performer> _performersByInstrument =
      Multimap<Instrument, Performer>();
  final List<Performer> _recommendedPerformers = [];
  final List<Performer> _selectedPerformers = [];
  late JamNightDAO _jamNightDAO;
  final _eventController = StreamController<DataStoreEvent>.broadcast();

  List<Performer> get allPerformers => _allPerformers;
  List<Performer> get currentJamPerformers => _currentJamPerformers;
  Multimap<Instrument, Performer> get performersByInstrument =>
      _performersByInstrument;
  List<Performer> get recommendedPerformers => _recommendedPerformers;
  List<Performer> get selectedPerformers => _selectedPerformers;
  Stream<DataStoreEvent> get events => _eventController.stream;

  DataStore(JamNightDAO jamNightDAO) {
    _jamNightDAO = jamNightDAO;
    _jamNightDAO.getPerformers().then((List<Performer> performers) {
      for (Performer performer in performers) {
        _allPerformers.add(performer);
        if (performer.status != PerformerStatus.away) {
          _currentJamPerformers.add(performer);
          _performersByInstrument.add(performer.instrument, performer);
        }
        if (performer.status == PerformerStatus.selected) {
          _selectedPerformers.add(performer);
        }
      }
      _updateRecommendedPerformers();
      notifyListeners();
    });
  }

  // PERFORMER MANAGER METHODS

  void addPerformerToCurrentJam(Performer performer) {
    if (_currentJamPerformers.contains(performer)) {
      logger.i('Performer already in current jam: ${performer.name}');
      return;
    }

    logger.i('Adding performer: ${performer.name}');
    performer.status = PerformerStatus.present;
    performer.lastPlayed = DateTime.now();
    performer.numberOfTimesPlayed = 0;

    if (!_allPerformers.contains(performer)) {
      _allPerformers.add(performer);
      _jamNightDAO.insertPerformer(performer);
    } else {
      _jamNightDAO.updatePerformer(performer);
    }

    _currentJamPerformers.add(performer);
    _performersByInstrument.add(performer.instrument, performer);
    _updateRecommendedPerformers();
    _eventController.add(DataStoreEvent.performerAddedToCurrentJam);
    notifyListeners();
  }

  void removePerformerFromCurrentJam(Performer performer) {
    logger.i('Removing performer: $performer');
    _currentJamPerformers.remove(performer);
    _performersByInstrument
        .removeWhere((Instrument instrument, Performer p) => p == performer);
    _selectedPerformers.remove(performer);

    if (!performer.isJamRegular) {
      _allPerformers.remove(performer);
      _jamNightDAO.deletePerformer(performer.name);
    } else {
      performer.status = PerformerStatus.away;
      _jamNightDAO.updatePerformer(performer);
    }
    _updateRecommendedPerformers();
    notifyListeners();
  }

  void savePerformerAsJamRegular(Performer performer) {
    if (performer.isJamRegular) {
      logger.i('Performer already saved: ${performer.name}');
      return;
    }

    logger.i('Saving performer: ${performer.name}');
    performer.isJamRegular = true;
    _jamNightDAO.updatePerformer(performer);
    notifyListeners();
  }

  // BAND MANAGER METHODS

  void movePerformerFromRecommendedToSelected(int rowIndex) {
    logger.i('Moving performer from recommended to selected: $rowIndex');
    Performer performer = _recommendedPerformers[rowIndex];
    performer.selectPerformer();
    _selectedPerformers.add(performer);
    _recommendedPerformers.removeAt(rowIndex);
    _jamNightDAO.updatePerformer(performer);
    _updateRecommendedPerformers();
    notifyListeners();
  }

  void removePerformerFromSelectedPerformers(int rowIndex) {
    logger.i('Removing performer from selected: $rowIndex');
    Performer performer = _selectedPerformers[rowIndex];
    performer.unselectPerformer();
    _selectedPerformers.removeAt(rowIndex);
    _jamNightDAO.updatePerformer(performer);
    _updateRecommendedPerformers();
    notifyListeners();
  }

  void finalizeSelectedBand() {
    logger.i('Finalizing selected band');
    for (Performer performer in _selectedPerformers) {
      performer.finalizePerformer();
      _jamNightDAO.updatePerformer(performer);
    }
    _selectedPerformers.clear();
    _updateRecommendedPerformers();
    notifyListeners();
  }

  void _updateRecommendedPerformers() {
    _recommendedPerformers.clear();
    _recommendedPerformers.addAll(_getRecommendedPerformers());
  }

  Future<List<Performer>> getJamNightRegularsNotInCurrentJam() {
    return sortPerformersByName(
        _jamNightDAO.getJamNightRegularsNotInCurrentJam());
  }

  Future<List<Performer>> sortPerformersByName(
      Future<List<Performer>> performersFuture) async {
    var performers = await performersFuture;
    performers.sort((a, b) => a.name.compareTo(b.name));
    return performers;
  }

  List<Performer> _getRecommendedPerformers() {
    List<Performer> recommendedPerformers = [];
    List<Performer> nonPriorityPlayers = [];

    for (Instrument instrument in Instrument.values) {
      List<Performer> performersForInstrument =
          _performersByInstrument[instrument].toList();
      performersForInstrument.sort();
      bool priorityPlayerNotFound = true;
      for (Performer performer in performersForInstrument) {
        if (priorityPlayerNotFound &&
            performer.status != PerformerStatus.selected) {
          performer.recommendPerformer();
          recommendedPerformers.add(performer);
          priorityPlayerNotFound = false;
        } else if (performer.status != PerformerStatus.selected) {
          nonPriorityPlayers.add(performer);
        }
      }
    }
    nonPriorityPlayers.sort();
    recommendedPerformers.addAll(nonPriorityPlayers);
    return recommendedPerformers;
  }
}
