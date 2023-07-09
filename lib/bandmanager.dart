import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'performer.dart';
import 'performereditor.dart';

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
            PerformerEditor(
              onPerformerCreated: _addPerformer,
              onPerformerRemoved: _removePerformer,
            ),
          ],
        ),
      ),
    );
  }
}
