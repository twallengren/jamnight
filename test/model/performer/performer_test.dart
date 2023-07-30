import 'package:flutter_test/flutter_test.dart';
import 'package:jamnight/model/instrument/instrument.dart';
import 'package:jamnight/model/performer/experiencelevel.dart';
import 'package:jamnight/model/performer/performer.dart';
import 'package:jamnight/model/performer/performerstatus.dart';

void main() {
  group('Performer', () {
    DateTime created = DateTime.now();
    late Performer guitaristA;

    setUp(() {
      guitaristA = Performer(
          name: 'guitaristA',
          instrument: Instrument.guitar,
          experienceLevel: ExperienceLevel.beginner,
          created: created);
    });

    test(
        'Performer is equal to another performer with same name and instrument',
        () {
      final guitaristB = Performer(
          name: 'guitaristA',
          instrument: Instrument.guitar,
          experienceLevel: ExperienceLevel.intermediate,
          created: created.add(const Duration(seconds: 1)));
      expect(guitaristA, equals(guitaristB));
    });

    test('Performer is not equal to another performer with different name', () {
      final guitaristB = Performer(
          name: 'guitaristB',
          instrument: Instrument.guitar,
          experienceLevel: ExperienceLevel.intermediate,
          created: created.add(const Duration(seconds: 1)));
      expect(guitaristA, isNot(equals(guitaristB)));
    });

    test(
        'Performer is not equal to another performer with different instrument',
        () {
      final bassist = Performer(
          name: 'guitaristA',
          instrument: Instrument.bass,
          experienceLevel: ExperienceLevel.intermediate,
          created: created.add(const Duration(seconds: 1)));
      expect(guitaristA, isNot(equals(bassist)));
    });

    test('getLastPlayed returns created if lastPlayed is null', () {
      expect(guitaristA.getLastPlayed(), equals(created));
    });

    test('getPerformerStatus returns present if not selected', () {
      expect(guitaristA.getPerformerStatus(), equals(PerformerStatus.present));
    });

    test('selectPerformer changes status to selected', () {
      guitaristA.selectPerformer();
      expect(guitaristA.getPerformerStatus(), equals(PerformerStatus.selected));
    });

    test('unselectPerformer changes status to present', () {
      guitaristA.selectPerformer();
      guitaristA.unselectPerformer();
      expect(guitaristA.getPerformerStatus(), equals(PerformerStatus.present));
    });

    test('unselectPerformer throws exception if performer not selected', () {
      expect(() => guitaristA.unselectPerformer(),
          throwsA(isInstanceOf<Exception>()));
    });

    test('recommendPerformer changes status to recommended', () {
      guitaristA.recommendPerformer();
      expect(
          guitaristA.getPerformerStatus(), equals(PerformerStatus.recommended));
    });

    test(
        'finalizePerformer changes status to present, updates lastPlayed, and increments times played',
        () {
      guitaristA.selectPerformer();
      guitaristA.finalizePerformer();
      expect(guitaristA.getPerformerStatus(), equals(PerformerStatus.present));
      expect(guitaristA.getLastPlayed().isAfter(created), isTrue);
      expect(guitaristA.getNumberOfTimesPlayed(), equals(1));
    });

    test('finalizePerformer throws exception if performer not selected', () {
      expect(() => guitaristA.finalizePerformer(),
          throwsA(isInstanceOf<Exception>()));
    });

    test('compareTo prioritises performers who arrived earlier', () {
      final guitaristB = Performer(
          name: 'guitaristB',
          instrument: Instrument.guitar,
          experienceLevel: ExperienceLevel.beginner,
          created: created.add(const Duration(seconds: 1)));
      expect(guitaristA.compareTo(guitaristB), equals(-1));
      expect(guitaristB.compareTo(guitaristA), equals(1));
    });

    test('compareTo prioritises performers who have played less', () {
      guitaristA.selectPerformer();
      guitaristA.finalizePerformer();
      final guitaristB = Performer(
          name: 'guitaristB',
          instrument: Instrument.guitar,
          experienceLevel: ExperienceLevel.beginner,
          created: created.add(const Duration(seconds: 1)));
      expect(guitaristA.compareTo(guitaristB), equals(1));
      expect(guitaristB.compareTo(guitaristA), equals(-1));
    });
  });
}
