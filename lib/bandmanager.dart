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
  final Logger logger = Logger();
  final List<Performer> _performers = <Performer>[];

  void _addPerformer(Performer performer) {
    setState(() {
      _performers.add(performer);
      logger.i(_performers);
    });
  }

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
