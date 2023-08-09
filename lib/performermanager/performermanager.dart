import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../data/datastore.dart';
import '../model/instrument/instrument.dart';
import '../model/performer/experiencelevel.dart';
import '../model/performer/performer.dart';
import '../model/performer/performerstatus.dart';
import 'addperformerbutton.dart';
import 'enternamebox.dart';
import 'experienceleveldropdown.dart';
import 'instrumentdropdown.dart';
import 'performerlist.dart';
import 'searchperformertextbox.dart';
import 'selectregulardropdown.dart';

class PerformerManager extends StatefulWidget {
  const PerformerManager({super.key});

  @override
  State<PerformerManager> createState() => _PerformerManagerState();
}

class _PerformerManagerState extends State<PerformerManager> {
  final Logger logger = Logger();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchPerformerController =
      TextEditingController();

  Performer? _savedPerformer;
  Instrument? _instrument;
  ExperienceLevel? _experienceLevel;
  List<Performer> _filteredJamPerformers = [];

  void _selectSavedPerformer(Performer performer) {
    setState(() {
      _savedPerformer = performer;
      _nameController.text = performer.name;
      _instrument = performer.instrument;
      _experienceLevel = performer.experienceLevel;
    });
  }

  void _selectInstrument(Instrument instrument) {
    setState(() {
      _instrument = instrument;
    });
  }

  void _selectExperienceLevel(ExperienceLevel experienceLevel) {
    setState(() {
      _experienceLevel = experienceLevel;
    });
  }

  void _addPerformer(DataStore dataStore) {
    if (_savedPerformer == null) {
      // TODO: Add UI popups for validation problems

      if (_nameController.text.isEmpty) {
        logger.i('Cannot add performer with empty name');
        return;
      }

      if (_instrument == null) {
        logger.i('Cannot add performer with no instrument');
        return;
      }

      if (_experienceLevel == null) {
        logger.i('Cannot add performer with no experience level');
        return;
      }

      final Performer performer = Performer(
          name: _nameController.text,
          instrument: _instrument!,
          experienceLevel: _experienceLevel!,
          created: DateTime.now(),
          status: PerformerStatus.present,
          isJamRegular: false,
          lastPlayed: DateTime.now(),
          numberOfTimesPlayed: 0);
      dataStore.addPerformerToCurrentJam(performer);
    } else {
      // TODO: Add UI popups for validation problems

      if (_nameController.text != _savedPerformer!.name) {
        logger.i('Cannot change name of saved performer');
        _clearForm();
        return;
      }

      if (_instrument != _savedPerformer!.instrument) {
        logger.i('Cannot change instrument of saved performer');
        _clearForm();
        return;
      }

      if (_experienceLevel != _savedPerformer!.experienceLevel) {
        logger.i('Cannot change experience level of saved performer');
        _clearForm();
        return;
      }

      dataStore.addPerformerToCurrentJam(_savedPerformer!);
    }
    _clearForm();
    _filterCurrentJamPerformers(dataStore);
  }

  void _clearForm() {
    setState(() {
      _nameController.clear();
      _savedPerformer = null;
      _instrument = null;
      _experienceLevel = null;
    });
  }

  void _filterCurrentJamPerformers(DataStore dataStore) {
    setState(() {
      _filteredJamPerformers = dataStore.currentJamPerformers
          .where((Performer performer) => performer.name
              .toLowerCase()
              .startsWith(_searchPerformerController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    DataStore dataStore = Provider.of<DataStore>(context, listen: true);
    _filterCurrentJamPerformers(dataStore);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Performer Manager'),
        ),
        body: ListView(
          children: <Widget>[
            SelectRegularDropdown(
                savedPerformer: _savedPerformer,
                onPerformerSelected: _selectSavedPerformer),
            EnterNameBox(nameController: _nameController),
            InstrumentDropdown(
                instrument: _instrument,
                onInstrumentSelected: _selectInstrument),
            ExperienceLevelDropdown(
                experienceLevel: _experienceLevel,
                onExperienceLevelSelected: _selectExperienceLevel),
            AddPerformerButton(
                onAddPerformerPressed: () => _addPerformer(dataStore)),
            SearchPerformerTextBox(
                searchPerformerController: _searchPerformerController,
                onChanged: (String value) =>
                    _filterCurrentJamPerformers(dataStore)),
            PerformerList(performers: _filteredJamPerformers),
          ],
        ));
  }
}
