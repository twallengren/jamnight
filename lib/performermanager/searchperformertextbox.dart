import 'package:flutter/material.dart';

class SearchPerformerTextBox extends StatelessWidget {

  const SearchPerformerTextBox({
    super.key,
    required TextEditingController searchPerformerController,
    required this.onChanged
  }) : _searchPerformerController = searchPerformerController;

  final TextEditingController _searchPerformerController;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          controller: _searchPerformerController,
          decoration: const InputDecoration(
            labelText: 'Search Performers',
          ),
          onChanged: onChanged),
    );
  }
}
