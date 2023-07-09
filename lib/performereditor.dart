import 'package:flutter/material.dart';
import 'performer.dart';

// This widget allows users to create new performers and add them to the list. It should have a text box to enter information for the performer (name, instrument, and skill level), and a button to add the performer to the list.
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
  // This controller is used to retrieve the value of the text field.
  final TextEditingController _nameController = TextEditingController();

  // This controller is used to retrieve the value of the text field.
  final TextEditingController _instrumentController = TextEditingController();

  // This controller is used to retrieve the value of the text field.
  final TextEditingController _skillLevelController = TextEditingController();

  // This method is called when the "Add Performer" button is pressed. It should create a new Performer object with the information from the text fields, and call the onPerformerCreated callback with the new performer.
  void _createPerformer() {
    final Performer performer = Performer(
      name: _nameController.text,
      instrument: _instrumentController.text,
      skillLevel: int.parse(_skillLevelController.text),
    );
    widget.onPerformerCreated(performer);
  }

  void _removePerformer() {
    final Performer performer = Performer(
      name: _nameController.text,
      instrument: _instrumentController.text,
      skillLevel: int.parse(_skillLevelController.text),
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
        TextField(
          controller: _instrumentController,
          decoration: const InputDecoration(
            labelText: 'Instrument',
          ),
        ),
        TextField(
          controller: _skillLevelController,
          decoration: const InputDecoration(
            labelText: 'Skill Level',
          ),
        ),
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
