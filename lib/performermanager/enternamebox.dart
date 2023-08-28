import 'package:flutter/material.dart';

class EnterNameBox extends StatelessWidget {

  static const Key widgetKey = Key('PerformerManager.EnterNameBox');

  const EnterNameBox({super.key, 
    required TextEditingController nameController,
  }) : _nameController = nameController;

  final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _nameController,
        decoration: const InputDecoration(
          labelText: 'Enter Name',
        ),
      ),
    );
  }
}
