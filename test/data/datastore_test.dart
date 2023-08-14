import 'package:flutter_test/flutter_test.dart';
import 'package:jamnight/data/jamnightdao.dart';
import 'package:jamnight/model/performer/experiencelevel.dart';
import 'package:jamnight/data/datastore.dart';
import 'package:jamnight/model/performer/performer.dart';
import 'package:jamnight/model/instrument/instrument.dart';
import 'package:jamnight/model/performer/performerstatus.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<JamNightDAO>()])
import 'datastore_test.mocks.dart';

void main() {
  group('DataStore', () {
    final DateTime now = DateTime.now();
    final DateTime nowPlusOne = now.add(const Duration(seconds: 1));
    late DataStore dataStore;
    late Performer guitaristA;
    late Performer guitaristB;
    late JamNightDAO mockJamNightDAO;

    setUp(() {
      mockJamNightDAO = MockJamNightDAO();
      dataStore = DataStore(mockJamNightDAO);
      guitaristA = Performer(
          name: 'guitaristA',
          instrument: Instrument.guitar,
          experienceLevel: ExperienceLevel.beginner,
          created: now,
          status: PerformerStatus.present,
          isJamRegular: false,
          lastPlayed: now,
          numberOfTimesPlayed: 0);
      guitaristB = Performer(
          name: 'guitaristB',
          instrument: guitaristA.instrument,
          experienceLevel: ExperienceLevel.beginner,
          created: nowPlusOne,
          status: PerformerStatus.present,
          isJamRegular: false,
          lastPlayed: nowPlusOne,
          numberOfTimesPlayed: 0);
    });

    test('addPerformer adds to both performers and performersByInstrument', () {
      dataStore.addPerformerToCurrentJam(guitaristA);
      dataStore.addPerformerToCurrentJam(guitaristB);

      expect(dataStore.allPerformers, contains(guitaristA));
      expect(
          dataStore.performersByInstrument.containsValue(guitaristA), isTrue);
      expect(dataStore.recommendedPerformers, contains(guitaristA));
      expect(dataStore.selectedPerformers, isNot(contains(guitaristA)));

      expect(dataStore.allPerformers, contains(guitaristB));
      expect(
          dataStore.performersByInstrument.containsValue(guitaristB), isTrue);
      expect(dataStore.recommendedPerformers, contains(guitaristB));
      expect(dataStore.selectedPerformers, isNot(contains(guitaristB)));
    });

    test('addPerformer prioritizes performers by last time played', () {
      dataStore.addPerformerToCurrentJam(guitaristA);
      dataStore.addPerformerToCurrentJam(guitaristB);

      expect(dataStore.allPerformers, contains(guitaristA));
      expect(dataStore.allPerformers, contains(guitaristB));

      List<Performer> performers = dataStore.recommendedPerformers;

      Performer firstPerformer = performers[0];
      Performer secondPerformer = performers[1];

      expect(firstPerformer, equals(guitaristA));
      expect(secondPerformer, equals(guitaristB));
    });

    test('addPerformer prioritizes performers by number of times played', () {
      dataStore.addPerformerToCurrentJam(guitaristA);
      dataStore.movePerformerFromRecommendedToSelected(0);
      dataStore.finalizeSelectedBand();
      dataStore.addPerformerToCurrentJam(guitaristB);

      expect(dataStore.allPerformers, contains(guitaristA));
      expect(dataStore.allPerformers, contains(guitaristB));

      List<Performer> performers = dataStore.recommendedPerformers;

      Performer firstPerformer = performers[0];
      Performer secondPerformer = performers[1];

      expect(firstPerformer, equals(guitaristB));
      expect(secondPerformer, equals(guitaristA));
    });

    // test that dataStore.removePerformerByIndex works correctly
    test('should remove a performer by index correctly', () {
      dataStore.addPerformerToCurrentJam(guitaristA);
      dataStore.addPerformerToCurrentJam(guitaristB);
      dataStore.removePerformerFromCurrentJam(guitaristA);

      expect(dataStore.allPerformers, isNot(contains(guitaristA)));
      expect(
          dataStore.performersByInstrument.containsValue(guitaristA), isFalse);
      expect(dataStore.recommendedPerformers, isNot(contains(guitaristA)));
      expect(dataStore.selectedPerformers, isNot(contains(guitaristA)));

      expect(dataStore.allPerformers, contains(guitaristB));
      expect(
          dataStore.performersByInstrument.containsValue(guitaristB), isTrue);
      expect(dataStore.recommendedPerformers, contains(guitaristB));
      expect(dataStore.selectedPerformers, isNot(contains(guitaristB)));
    });

    test('should move a performer from recommended to selected correctly', () {
      dataStore.addPerformerToCurrentJam(guitaristA);
      dataStore.addPerformerToCurrentJam(guitaristB);
      dataStore.movePerformerFromRecommendedToSelected(0);

      expect(dataStore.allPerformers, contains(guitaristA));
      expect(
          dataStore.performersByInstrument.containsValue(guitaristA), isTrue);
      expect(dataStore.recommendedPerformers, isNot(contains(guitaristA)));
      expect(dataStore.selectedPerformers, contains(guitaristA));

      expect(dataStore.allPerformers, contains(guitaristB));
      expect(
          dataStore.performersByInstrument.containsValue(guitaristB), isTrue);
      expect(dataStore.recommendedPerformers, contains(guitaristB));
      expect(dataStore.selectedPerformers, isNot(contains(guitaristB)));
    });

    test('should remove a performer from selected correctly', () {
      dataStore.addPerformerToCurrentJam(guitaristA);
      dataStore.movePerformerFromRecommendedToSelected(0);
      dataStore.removePerformerFromSelectedPerformers(0);

      expect(dataStore.allPerformers, contains(guitaristA));
      expect(
          dataStore.performersByInstrument.containsValue(guitaristA), isTrue);
      expect(dataStore.recommendedPerformers, contains(guitaristA));
      expect(dataStore.selectedPerformers, isNot(contains(guitaristA)));
    });

    // test that finalizeSelectedBand() works as expected
    test('should finalize selected band correctly', () {
      dataStore.addPerformerToCurrentJam(guitaristA);
      dataStore.movePerformerFromRecommendedToSelected(0);
      dataStore.finalizeSelectedBand();

      expect(dataStore.allPerformers, contains(guitaristA));
      expect(
          dataStore.performersByInstrument.containsValue(guitaristA), isTrue);
      expect(dataStore.recommendedPerformers, contains(guitaristA));
      expect(dataStore.selectedPerformers, isNot(contains(guitaristA)));
      expect(guitaristA.numberOfTimesPlayed, equals(1));
      expect(guitaristA.lastPlayed.isAfter(now), isTrue);
    });
  });
}
