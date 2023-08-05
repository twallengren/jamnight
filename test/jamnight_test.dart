import 'package:flutter_test/flutter_test.dart';
import 'package:jamnight/bandmanager/bandmanager.dart';
import 'package:jamnight/data/datastore.dart';
import 'package:jamnight/homepage/homepage.dart';
import 'package:jamnight/jamnight.dart';
import 'package:jamnight/performermanager/performermanager.dart';
import 'package:provider/provider.dart';

void main() {
  group('JamNight widget', () {
    testWidgets('initializes without error', (tester) async {
      // Wrap the widget under test with the ChangeNotifierProvider to avoid
      // the Provider error
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => DataStore(),
          child: const JamNight(title: 'Jam Night'),
        ),
      );
    });

    testWidgets('home page is the initial route', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => DataStore(),
          child: const JamNight(title: 'Jam Night'),
        ),
      );

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('can navigate to performer manager', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => DataStore(),
          child: const JamNight(title: 'Jam Night'),
        ),
      );

      Finder managePerformersButton = find.text('Manage Performers');
      expect(managePerformersButton, findsOneWidget);

      await tester.tap(managePerformersButton);
      await tester.pumpAndSettle();

      expect(find.byType(PerformerManager), findsOneWidget);
    });

    testWidgets('can navigate to band manager', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => DataStore(),
          child: const JamNight(title: 'Jam Night'),
        ),
      );

      Finder managePerformersButton = find.text('Manage Bands');
      expect(managePerformersButton, findsOneWidget);

      await tester.tap(managePerformersButton);
      await tester.pumpAndSettle();

      expect(find.byType(BandManager), findsOneWidget);
    });
  });
}
