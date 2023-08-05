import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jamnight/model/performer/experiencelevel.dart';
import 'package:jamnight/performermanager/experienceleveldropdown.dart';

void main() {
  group('ExperienceLevelDropdown widget', () {
    testWidgets('initializes without error', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: ExperienceLevelDropdown(
        onExperienceLevelSelected: (ExperienceLevel experienceLevel) => {},
        experienceLevel: null,
      ))));
    });
  });
}
