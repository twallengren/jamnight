import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jamnight/data/datastore.dart';
import 'package:jamnight/performermanager/performermanager.dart';
import 'package:jamnight/performermanager/addperformerbutton.dart';
import 'package:jamnight/performermanager/instrumentdropdown.dart';
import 'package:provider/provider.dart';

void main() {
  group('PerformerManager widget', () {
    testWidgets('initializes without error', (tester) async {
      // Wrap the widget under test with the ChangeNotifierProvider to avoid
      // the Provider error
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => DataStore(),
            child: const PerformerManager(),
          ),
        ),
      );
    });

    // test adding a performer
    testWidgets('can add a performer', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => DataStore(),
            child: const PerformerManager(),
          ),
        ),
      );

      // Enter a name
      await tester.enterText(find.byType(TextField), 'John');

      // Select an instrument
      await tester.tap(find.byType(InstrumentDropdown));
      await tester.pumpAndSettle();
      await tester.tap(find.text('GUITAR'));
      await tester.pumpAndSettle();

      // Tap the add performer button
      await tester.tap(find.byType(AddPerformerButton));
      await tester.pumpAndSettle();

      // Verify that the performer was added
      expect(find.text('John'), findsNWidgets(2));
      expect(find.text('GUITAR'), findsNWidgets(2));
    });
  });
}
