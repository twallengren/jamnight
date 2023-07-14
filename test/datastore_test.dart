import 'package:flutter_test/flutter_test.dart';
import 'package:jamnight/model/experiencelevel.dart';
import 'package:jamnight/datastore.dart';
import 'package:jamnight/model/performer/performer.dart';
import 'package:jamnight/model/instrument/instrument.dart';

void main() {
  group('DataStore', () {
    late DataStore dataStore;
    final DateTime now = DateTime.now();
    final Performer performerA = Performer(
        name: 'performerA',
        instrument: Instrument.guitar,
        experienceLevel: ExperienceLevel.beginner,
        created: now);

    setUp(() {
      dataStore = DataStore();
    });

    test('should add a performer correctly', () {
      dataStore.addPerformer(performerA);

      expect(dataStore.getPerformers(), contains(performerA));
      expect(dataStore.getPerformersByInstrument().containsValue(performerA),
          isTrue);
      // Add more assertions here to validate the correctness of your addPerformer function.
    });

    test('should remove a performer correctly', () {
      dataStore.addPerformer(performerA);
      dataStore.removePerformer(performerA);

      expect(dataStore.getPerformers(), isNot(contains(performerA)));
      expect(dataStore.getPerformersByInstrument().containsValue(performerA),
          isFalse);
      // Add more assertions here to validate the correctness of your removePerformer function.
    });

    // Continue adding more tests here to fully cover all your functions.
  });
}
