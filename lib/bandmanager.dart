import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'performer.dart';

class BandManager extends StatefulWidget {
  const BandManager({super.key, required this.title});

  final String title;

  @override
  State<BandManager> createState() => _BandManagerState();
}

class _BandManagerState extends State<BandManager> {
  // Logger for debugging
  final Logger logger = Logger();

  // This is the full list of possible performers. Throughout the night, performers
  // may be added to and removed from this list.
  final List<Performer> _performers = <Performer>[];

  // This method is used to add a performer to the list of performers.
  void _addPerformer(Performer performer) {
    setState(() {
      _performers.add(performer);
      logger.i(_performers);
    });
  }

  // This method is used to remove a performer from the list of performers.
  void _removePerformer(Performer performer) {
    setState(() {
      _performers.remove(performer);
      logger.i(_performers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // This widget allows users to create new performers and add them to the list.
            PerformerCreator(
              onPerformerCreated: _addPerformer,
            ),
          ],
        ),
      ),
    );
  }
}

// This widget allows users to create new performers and add them to the list. It should have a text box to enter information for the performer (name, instrument, and skill level), and a button to add the performer to the list.
class PerformerCreator extends StatefulWidget {
  const PerformerCreator({super.key, required this.onPerformerCreated});

  final ValueChanged<Performer> onPerformerCreated;

  @override
  State<PerformerCreator> createState() => _PerformerCreatorState();
}

class _PerformerCreatorState extends State<PerformerCreator> {
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
        ElevatedButton(
          onPressed: _createPerformer,
          child: const Text('Add Performer'),
        ),
      ],
    );
  }
}
