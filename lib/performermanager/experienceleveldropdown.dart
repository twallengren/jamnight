import 'package:flutter/material.dart';
import '../model/performer/experiencelevel.dart';

class ExperienceLevelDropdown extends StatefulWidget {
  const ExperienceLevelDropdown(
      {super.key, required this.onExperienceLevelSelected});

  final ValueChanged<ExperienceLevel> onExperienceLevelSelected;

  @override
  State<ExperienceLevelDropdown> createState() =>
      _ExperienceLevelDropdownState();
}

class _ExperienceLevelDropdownState extends State<ExperienceLevelDropdown> {
  ExperienceLevel? _selectedExperienceLevel;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ExperienceLevel>(
      hint: const Text('Select Experience Level'),
      value: _selectedExperienceLevel,
      onChanged: (ExperienceLevel? newValue) {
        setState(() {
          _selectedExperienceLevel = newValue;
          widget.onExperienceLevelSelected(newValue!);
        });
      },
      items: ExperienceLevel.values.map((ExperienceLevel experienceLevel) {
        return DropdownMenuItem<ExperienceLevel>(
          value: experienceLevel,
          child: Text(experienceLevel.name.toUpperCase()),
        );
      }).toList(),
    );
  }
}
