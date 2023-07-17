import 'package:flutter/material.dart';

class AddPerformerButton extends StatelessWidget {
  const AddPerformerButton({
    super.key,
    required onAddPerformerPressed,
  }) : _onAddPerformerPressed = onAddPerformerPressed;

  final VoidCallback _onAddPerformerPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: _onAddPerformerPressed,
        child: const Text('Add Performer'),
      ),
    );
  }
}
