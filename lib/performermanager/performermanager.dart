import 'package:flutter/material.dart';
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
import 'selectregulardropdown.dart';

class PerformerManager extends StatefulWidget {
  const PerformerManager({super.key});

  @override
  State<PerformerManager> createState() => _PerformerManagerState();
}

class _PerformerManagerState extends State<PerformerManager> {
  final TextEditingController _nameController = TextEditingController();

  Performer? _savedPerformer;
  Instrument? _instrument;
  ExperienceLevel? _experienceLevel;

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
      dataStore.addPerformerToCurrentJam(_savedPerformer!);
    }

    setState(() {
      _nameController.clear();
      _savedPerformer = null;
      _instrument = null;
      _experienceLevel = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    DataStore dataStore = Provider.of<DataStore>(context, listen: true);
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
            PerformerList(performers: dataStore.currentJamPerformers)
          ],
        ));
  }
}
