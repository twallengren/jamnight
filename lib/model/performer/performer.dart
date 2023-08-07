import 'package:jamnight/model/performer/experiencelevel.dart';

import '../../data/jamnightdao.dart';
import '../instrument/instrument.dart';
import 'performerstatus.dart';

class Performer implements Comparable<Performer> {
  Performer(
      {required this.name,
      required this.instrument,
      required this.experienceLevel,
      required this.created,
      required this.status,
      required this.isJamRegular,
      required this.lastPlayed,
      required this.numberOfTimesPlayed});

  final String name;
  final Instrument instrument;
  final ExperienceLevel experienceLevel;
  final DateTime created;
  PerformerStatus status;
  bool isJamRegular;
  DateTime lastPlayed;
  int numberOfTimesPlayed;

  void recommendPerformer() {
    status = PerformerStatus.recommended;
  }

  void selectPerformer() {
    status = PerformerStatus.selected;
  }

  void unselectPerformer() {
    if (status != PerformerStatus.selected) {
      throw Exception('Cannot unselect a performer that is not selected');
    }
    status = PerformerStatus.present;
  }

  void finalizePerformer() {
    if (status != PerformerStatus.selected) {
      throw Exception('Cannot finalize a performer that is not selected');
    }
    status = PerformerStatus.present;
    lastPlayed = DateTime.now();
    numberOfTimesPlayed++;
  }

  void removePerformerFromCurrentJam() {
    status = PerformerStatus.away;
  }

  Map<String, dynamic> toMap() {
    return {
      JamNightDAO.performerName: name,
      JamNightDAO.performerInstrument: instrument.name,
      JamNightDAO.performerExperienceLevel: experienceLevel.name,
      JamNightDAO.performerCreated: created.millisecondsSinceEpoch,
      JamNightDAO.performerStatus: status.name,
      JamNightDAO.performerIsJamRegular: isJamRegular ? 1 : 0,
      JamNightDAO.performerLastPlayed: lastPlayed.millisecondsSinceEpoch,
      JamNightDAO.performerNumberOfTimesPlayed: numberOfTimesPlayed
    };
  }

  @override
  bool operator ==(Object other) {
    return other is Performer && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return 'Performer(name: $name, instrument: $instrument, experienceLevel: $experienceLevel)';
  }

  @override
  int compareTo(Performer other) {
    int numberOfTimesPlayedComparison =
        numberOfTimesPlayed.compareTo(other.numberOfTimesPlayed);
    if (numberOfTimesPlayedComparison == 0) {
      return lastPlayed.compareTo(other.lastPlayed);
    } else {
      return numberOfTimesPlayedComparison;
    }
  }
}
