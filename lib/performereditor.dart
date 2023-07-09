import 'package:flutter/material.dart';
import 'performer.dart';
import 'instrument.dart';
import 'instrumentdropdown.dart';
import 'experiencelevel.dart';
import 'experienceleveldropdown.dart';

class PerformerEditor extends StatefulWidget {
  const PerformerEditor(
      {super.key,
      required this.onPerformerCreated,
      required this.onPerformerRemoved});

  final ValueChanged<Performer> onPerformerCreated;
  final ValueChanged<Performer> onPerformerRemoved;

  @override
  State<PerformerEditor> createState() => _PerformerEditorState();
}

class _PerformerEditorState extends State<PerformerEditor> {
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
    );
    widget.onPerformerCreated(performer);
  }

  void _removePerformer() {
    final Performer performer = Performer(
      name: _nameController.text,
      instrument: _instrument,
      experienceLevel: _experienceLevel,
    );
    widget.onPerformerRemoved(performer);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
          ),
        ),
        InstrumentDropdown(onInstrumentSelected: _selectInstrument),
        ExperienceLevelDropdown(
            onExperienceLevelSelected: _selectExperienceLevel),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: _createPerformer,
              child: const Text('Add Performer'),
            ),
            ElevatedButton(
              onPressed: _removePerformer,
              child: const Text('Remove Performer'),
            ),
          ],
        ),
      ],
    );
  }
}
