import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../datastore.dart';
import '../model/instrument/instrument.dart';
import '../model/performer/experiencelevel.dart';
import '../model/performer/performer.dart';
import 'experienceleveldropdown.dart';
import 'instrumentdropdown.dart';
import 'performerlist.dart';

class PerformerManager extends StatefulWidget {
  const PerformerManager({super.key});

  @override
  State<PerformerManager> createState() => _PerformerManagerState();
}

class _PerformerManagerState extends State<PerformerManager> {
  final TextEditingController _nameController = TextEditingController();

  Instrument _instrument = Instrument.guitar;
  ExperienceLevel _experienceLevel = ExperienceLevel.beginner;

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

  void _createPerformer(DataStore dataStore) {
    final Performer performer = Performer(
      name: _nameController.text,
      instrument: _instrument,
      experienceLevel: _experienceLevel,
      created: DateTime.now(),
    );
    dataStore.addPerformer(performer);
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Enter Name',
                ),
              ),
            ),
            InstrumentDropdown(onInstrumentSelected: _selectInstrument),
            ExperienceLevelDropdown(
                onExperienceLevelSelected: _selectExperienceLevel),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => _createPerformer(dataStore),
                child: const Text('Add Performer'),
              ),
            ),
            const PerformerList()
          ],
        ));
  }
}
