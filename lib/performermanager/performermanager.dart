import 'package:flutter/material.dart';
import '../model/performer.dart';
import 'performerlist.dart';
import '../model/instrument/instrument.dart';
import 'instrumentdropdown.dart';
import '../model/experiencelevel.dart';
import 'experienceleveldropdown.dart';

class PerformerManager extends StatefulWidget {
  const PerformerManager(
      {super.key,
      required this.onPerformerCreated,
      required this.onPerformerRemoved});

  final ValueChanged<Performer> onPerformerCreated;
  final ValueChanged<String> onPerformerRemoved;

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

  void _createPerformer() {
    final Performer performer = Performer(
      name: _nameController.text,
      instrument: _instrument,
      experienceLevel: _experienceLevel,
      created: DateTime.now(),
    );
    widget.onPerformerCreated(performer);
  }

  void _removePerformer() {
    widget.onPerformerRemoved(_nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Performer Manager"),
        ),
        body: Column(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _createPerformer,
                    child: const Text('Add Performer'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _removePerformer,
                    child: const Text('Remove Performer'),
                  ),
                ),
              ],
            ),
            const PerformerList()
          ],
        ));
  }
}
