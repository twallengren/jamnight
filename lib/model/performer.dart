import 'package:jamnight/model/experiencelevel.dart';

import 'instrument/instrument.dart';

class Performer {
  Performer({
    required this.name,
    required this.instrument,
    required this.experienceLevel,
    required this.created,
  });

  final String name;
  final Instrument instrument;
  final ExperienceLevel experienceLevel;
  final DateTime created;
  DateTime? lastPlayed;

  void setLastPlayed(DateTime dateTime) {
    lastPlayed = dateTime;
  }

  DateTime getLastPlayed() {
    if (lastPlayed == null) {
      return created;
    }
    return lastPlayed!;
  }

  @override
  bool operator ==(Object other) {
    return other is Performer &&
        other.name == name &&
        other.instrument == instrument &&
        other.experienceLevel == experienceLevel &&
        other.created == created;
  }

  @override
  int get hashCode =>
      name.hashCode ^
      instrument.hashCode ^
      experienceLevel.hashCode ^
      created.hashCode;

  @override
  String toString() {
    return 'Performer(name: $name, instrument: $instrument, experienceLevel: $experienceLevel)';
  }
}
