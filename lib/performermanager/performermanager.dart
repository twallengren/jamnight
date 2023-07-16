import 'package:flutter/material.dart';
import 'package:jamnight/performermanager/widgets/addperformerbutton.dart';
import 'package:provider/provider.dart';

import '../datastore.dart';
import '../model/instrument/instrument.dart';
import '../model/performer/experiencelevel.dart';
import '../model/performer/performer.dart';
import 'widgets/experienceleveldropdown.dart';
import 'widgets/instrumentdropdown.dart';
import 'widgets/performerlist.dart';
import 'widgets/enternamebox.dart';

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
            EnterNameBox(nameController: _nameController),
            InstrumentDropdown(onInstrumentSelected: _selectInstrument),
            ExperienceLevelDropdown(
                onExperienceLevelSelected: _selectExperienceLevel),
            AddPerformerButton(
                onAddPerformerPressed: () => _createPerformer(dataStore)),
            const PerformerList()
          ],
        ));
  }
}
