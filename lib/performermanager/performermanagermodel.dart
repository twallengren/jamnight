import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jamnight/data/datastore.dart';
import 'package:jamnight/model/instrument/instrument.dart';
import 'package:jamnight/model/performer/experiencelevel.dart';
import 'package:logger/logger.dart';

import '../data/datastoreevent.dart';
import '../model/performer/performer.dart';
import '../model/performer/performerstatus.dart';

class PerformerManagerModel extends ChangeNotifier {
  final Logger logger = Logger();
  final List<Performer> _performerList = [];
  final List<Performer> _filteredPerformerList = [];
  final DataStore _dataStore;
  late StreamSubscription<DataStoreEvent> _subscription;

  String? _name;
  String? _searchPerformer;
  Instrument? _instrument;
  ExperienceLevel? _experienceLevel = ExperienceLevel.unknown;
  Performer? _savedPerformer;

  String? get name => _name;
  String? get searchPerformer => _searchPerformer;
  Instrument? get instrument => _instrument;
  ExperienceLevel? get experienceLevel => _experienceLevel;
  List<Performer> get performerList => _performerList;
  List<Performer> get filteredPerformerList => _filteredPerformerList;
  Performer? get savedPerformer => _savedPerformer;

  PerformerManagerModel(this._dataStore) {
    _subscription = _dataStore.events.listen((DataStoreEvent event) {});
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void selectSavedPerformer(Performer performer) {
    _savedPerformer = performer;
    _name = performer.name;
    _instrument = performer.instrument;
    _experienceLevel = performer.experienceLevel;
    notifyListeners();
  }

  void onNameChanged(String name) {
    _name = name;
    notifyListeners();
  }

  void onSearchPerformerChanged(String searchPerformer) {
    _searchPerformer = searchPerformer;
    _updateFilteredPerformerListAndNotifyListeners();
  }

  void selectInstrument(Instrument instrument) {
    _instrument = instrument;
    notifyListeners();
  }

  void addPerformerToCurrentJam() {
    if (_savedPerformer == null) {
      // TODO: Add UI popups for validation problems

      if (_name == null || _name!.isEmpty) {
        logger.i('Cannot add performer with empty name');
        return;
      }

      if (_instrument == null) {
        logger.i('Cannot add performer with no instrument');
        return;
      }

      final Performer performer = Performer(
          name: _name!,
          instrument: _instrument!,
          experienceLevel: _experienceLevel!,
          created: DateTime.now(),
          status: PerformerStatus.present,
          isJamRegular: false,
          lastPlayed: DateTime.now(),
          numberOfTimesPlayed: 0);
      _dataStore.addPerformerToCurrentJam(performer);
      _performerList.add(performer);
    } else {
      // TODO: Add UI popups for validation problems

      if (_name! != _savedPerformer!.name) {
        logger.i('Cannot change name of saved performer');
        return;
      }

      if (_instrument != _savedPerformer!.instrument) {
        logger.i('Cannot change instrument of saved performer');
        return;
      }

      if (_experienceLevel != _savedPerformer!.experienceLevel) {
        logger.i('Cannot change experience level of saved performer');
        return;
      }

      _dataStore.addPerformerToCurrentJam(_savedPerformer!);
      _performerList.add(_savedPerformer!);
    }
    _clearForm();
    _updateFilteredPerformerListAndNotifyListeners();
  }

  void removePerformerFromCurrentJam(int rowIndex) {
    Performer performer = _filteredPerformerList[rowIndex];
    _dataStore.removePerformerFromCurrentJam(performer);
    _performerList.remove(performer);
    _updateFilteredPerformerListAndNotifyListeners();
  }

  void savePerformerAsRegular(int rowIndex) {
    Performer performer = _filteredPerformerList[rowIndex];
    _dataStore.savePerformerAsJamRegular(performer);
    notifyListeners();
  }

  void _updateFilteredPerformerListAndNotifyListeners() {
    _filteredPerformerList.clear();
    if (_searchPerformer == null) {
      _filteredPerformerList.addAll(_performerList);
    } else {
      _filteredPerformerList.addAll(_performerList
          .where((Performer performer) => performer.name
              .toLowerCase()
              .startsWith(_searchPerformer!.toLowerCase()))
          .toList());
    }
    notifyListeners();
  }

  void _clearForm() {
    _name = null;
    _instrument = null;
    _experienceLevel = null;
    _savedPerformer = null;
  }
}
