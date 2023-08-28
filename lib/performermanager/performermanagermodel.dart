import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jamnight/data/datastore.dart';
import 'package:jamnight/model/instrument/instrument.dart';
import 'package:jamnight/model/performer/experiencelevel.dart';

import '../data/datastoreevent.dart';
import '../model/performer/performer.dart';

class PerformerManagerModel extends ChangeNotifier {
  final DataStore _dataStore;
  late StreamSubscription<DataStoreEvent> _subscription;

  String? _name;
  String? _searchPerformer;
  Instrument? _instrument;
  ExperienceLevel? _experienceLevel;
  List<Performer>? _performerList;
  Performer? _savedPerformer;

  String? get name => _name;
  String? get searchPerformer => _searchPerformer;
  Instrument? get instrument => _instrument;
  ExperienceLevel? get experienceLevel => _experienceLevel;
  List<Performer>? get performerList => _performerList;
  Performer? get savedPerformer => _savedPerformer;

  PerformerManagerModel(this._dataStore) {
    _subscription = _dataStore.events.listen((DataStoreEvent event) {
      if (event == DataStoreEvent.performerAddedToCurrentJam) {
        _performerList = _dataStore.currentJamPerformers;
        notifyListeners();
      }
    });
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
}
