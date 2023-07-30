import 'package:flutter_test/flutter_test.dart';
import 'package:jamnight/model/performer/experiencelevel.dart';
import 'package:jamnight/datastore.dart';
import 'package:jamnight/model/performer/performer.dart';
import 'package:jamnight/model/instrument/instrument.dart';

void main() {
  group('DataStore', () {
    final DateTime now = DateTime.now();
    late DataStore dataStore;
    late Performer guitaristA;
    late Performer guitaristB;

    setUp(() {
      dataStore = DataStore();
      guitaristA = Performer(
          name: 'guitaristA',
          instrument: Instrument.guitar,
          experienceLevel: ExperienceLevel.beginner,
          created: now);
      guitaristB = Performer(
          name: 'guitaristB',
          instrument: guitaristA.instrument,
          experienceLevel: ExperienceLevel.beginner,
          created: now.add(const Duration(seconds: 1)));
    });

    test('addPerformer adds to both performers and performersByInstrument', () {
      dataStore.addPerformer(guitaristA);
      dataStore.addPerformer(guitaristB);

      expect(dataStore.getPerformers(), contains(guitaristA));
      expect(dataStore.getPerformersByInstrument().containsValue(guitaristA),
          isTrue);
      expect(dataStore.getRecommendedPerformers(), contains(guitaristA));
      expect(dataStore.getSelectedPerformers(), isNot(contains(guitaristA)));

      expect(dataStore.getPerformers(), contains(guitaristB));
      expect(dataStore.getPerformersByInstrument().containsValue(guitaristB),
          isTrue);
      expect(dataStore.getRecommendedPerformers(), contains(guitaristB));
      expect(dataStore.getSelectedPerformers(), isNot(contains(guitaristB)));
    });

    test('addPerformer prioritizes performers by last time played', () {
      dataStore.addPerformer(guitaristA);
      dataStore.addPerformer(guitaristB);

      expect(dataStore.getPerformers(), contains(guitaristA));
      expect(dataStore.getPerformers(), contains(guitaristB));

      List<Performer> performers = dataStore.getRecommendedPerformers();

      Performer firstPerformer = performers[0];
      Performer secondPerformer = performers[1];

      expect(firstPerformer, equals(guitaristA));
      expect(secondPerformer, equals(guitaristB));
    });

    test('addPerformer prioritizes performers by number of times played', () {
      guitaristA.finalizePerformer();

      dataStore.addPerformer(guitaristA);
      dataStore.addPerformer(guitaristB);

      expect(dataStore.getPerformers(), contains(guitaristA));
      expect(dataStore.getPerformers(), contains(guitaristB));

      List<Performer> performers = dataStore.getRecommendedPerformers();

      Performer firstPerformer = performers[0];
      Performer secondPerformer = performers[1];

      expect(firstPerformer, equals(guitaristB));
      expect(secondPerformer, equals(guitaristA));
    });

    test('should remove a performer correctly', () {
      dataStore.addPerformer(guitaristA);
      dataStore.addPerformer(guitaristB);
      dataStore.removePerformer(guitaristA);

      expect(dataStore.getPerformers(), isNot(contains(guitaristA)));
      expect(dataStore.getPerformersByInstrument().containsValue(guitaristA),
          isFalse);
      expect(dataStore.getRecommendedPerformers(), isNot(contains(guitaristA)));
      expect(dataStore.getSelectedPerformers(), isNot(contains(guitaristA)));

      expect(dataStore.getPerformers(), contains(guitaristB));
      expect(dataStore.getPerformersByInstrument().containsValue(guitaristB),
          isTrue);
      expect(dataStore.getRecommendedPerformers(), contains(guitaristB));
      expect(dataStore.getSelectedPerformers(), isNot(contains(guitaristB)));
    });

    // test that dataStore.removePerformerByIndex works correctly
    test('should remove a performer by index correctly', () {
      dataStore.addPerformer(guitaristA);
      dataStore.addPerformer(guitaristB);
      dataStore.removePerformerByIndex(0);

      expect(dataStore.getPerformers(), isNot(contains(guitaristA)));
      expect(dataStore.getPerformersByInstrument().containsValue(guitaristA),
          isFalse);
      expect(dataStore.getRecommendedPerformers(), isNot(contains(guitaristA)));
      expect(dataStore.getSelectedPerformers(), isNot(contains(guitaristA)));

      expect(dataStore.getPerformers(), contains(guitaristB));
      expect(dataStore.getPerformersByInstrument().containsValue(guitaristB),
          isTrue);
      expect(dataStore.getRecommendedPerformers(), contains(guitaristB));
      expect(dataStore.getSelectedPerformers(), isNot(contains(guitaristB)));
    });

    test('should move a performer from recommended to selected correctly', () {
      dataStore.addPerformer(guitaristA);
      dataStore.addPerformer(guitaristB);
      dataStore.movePerformerFromRecommendedToSelected(0);

      expect(dataStore.getPerformers(), contains(guitaristA));
      expect(dataStore.getPerformersByInstrument().containsValue(guitaristA),
          isTrue);
      expect(dataStore.getRecommendedPerformers(), isNot(contains(guitaristA)));
      expect(dataStore.getSelectedPerformers(), contains(guitaristA));

      expect(dataStore.getPerformers(), contains(guitaristB));
      expect(dataStore.getPerformersByInstrument().containsValue(guitaristB),
          isTrue);
      expect(dataStore.getRecommendedPerformers(), contains(guitaristB));
      expect(dataStore.getSelectedPerformers(), isNot(contains(guitaristB)));
    });

    test('should remove a performer from selected correctly', () {
      dataStore.addPerformer(guitaristA);
      dataStore.movePerformerFromRecommendedToSelected(0);
      dataStore.removePerformerFromSelectedPerformers(0);

      expect(dataStore.getPerformers(), contains(guitaristA));
      expect(dataStore.getPerformersByInstrument().containsValue(guitaristA),
          isTrue);
      expect(dataStore.getRecommendedPerformers(), contains(guitaristA));
      expect(dataStore.getSelectedPerformers(), isNot(contains(guitaristA)));
    });

    // test that finalizeSelectedBand() works as expected
    test('should finalize selected band correctly', () {
      dataStore.addPerformer(guitaristA);
      dataStore.movePerformerFromRecommendedToSelected(0);
      dataStore.finalizeSelectedBand();

      expect(dataStore.getPerformers(), contains(guitaristA));
      expect(dataStore.getPerformersByInstrument().containsValue(guitaristA),
          isTrue);
      expect(dataStore.getRecommendedPerformers(), contains(guitaristA));
      expect(dataStore.getSelectedPerformers(), isNot(contains(guitaristA)));
      expect(guitaristA.getNumberOfTimesPlayed(), equals(1));
      expect(guitaristA.getLastPlayed().isAfter(now), isTrue);
    });
  });
}
