import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class BandManager extends StatefulWidget {
  const BandManager({super.key, required this.title});

  final String title;

  @override
  State<BandManager> createState() => _BandManagerState();
}

class _BandManagerState extends State<BandManager> {
  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Text('Band Manager'),
    );
  }
}
