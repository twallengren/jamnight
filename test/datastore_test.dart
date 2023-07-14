import 'package:flutter_test/flutter_test.dart';
import 'package:quiver/collection.dart';
import 'package:jamnight/model/experiencelevel.dart';
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

      expect(dataStore.getPerformers(), contains(guitaristA));
      expect(dataStore.getPerformersByInstrument().containsValue(guitaristA),
          isTrue);
    });

    test('addPerformer prioritizes performers by last time played', () {
      dataStore.addPerformer(guitaristA);
      dataStore.addPerformer(guitaristB);

      expect(dataStore.getPerformers(), contains(guitaristA));
      expect(dataStore.getPerformers(), contains(guitaristB));

      Multimap<Instrument, Performer> performersByInstrument =
          dataStore.getPerformersByInstrument();
      List<Performer> performers =
          performersByInstrument[guitaristA.instrument].toList();

      Performer firstPerformer = performers[0];
      Performer secondPerformer = performers[1];

      expect(firstPerformer, equals(guitaristA));
      expect(secondPerformer, equals(guitaristB));
    });

    test('addPerformer prioritizes performers by number of times played', () {
      guitaristA.incrementNumberOfTimesPlayed();

      dataStore.addPerformer(guitaristA);
      dataStore.addPerformer(guitaristB);

      expect(dataStore.getPerformers(), contains(guitaristA));
      expect(dataStore.getPerformers(), contains(guitaristB));

      Multimap<Instrument, Performer> performersByInstrument =
          dataStore.getPerformersByInstrument();
      List<Performer> performers =
          performersByInstrument[guitaristA.instrument].toList();

      Performer firstPerformer = performers[0];
      Performer secondPerformer = performers[1];

      expect(firstPerformer, equals(guitaristB));
      expect(secondPerformer, equals(guitaristA));
    });

    test('should remove a performer correctly', () {
      dataStore.addPerformer(guitaristA);
      dataStore.removePerformer(guitaristA);

      expect(dataStore.getPerformers(), isNot(contains(guitaristA)));
      expect(dataStore.getPerformersByInstrument().containsValue(guitaristA),
          isFalse);
    });

    // Continue adding more tests here to fully cover all your functions.
  });
}
