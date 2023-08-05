import 'package:flutter/material.dart';

import '../../model/performer/experiencelevel.dart';

class ExperienceLevelDropdown extends StatelessWidget {
  const ExperienceLevelDropdown(
      {super.key,
      required this.experienceLevel,
      required this.onExperienceLevelSelected});

  final ExperienceLevel? experienceLevel;
  final ValueChanged<ExperienceLevel> onExperienceLevelSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ExperienceLevel>(
      hint: const Text('Select Experience Level'),
      value: experienceLevel,
      onChanged: (ExperienceLevel? newValue) {
        onExperienceLevelSelected(newValue!);
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
