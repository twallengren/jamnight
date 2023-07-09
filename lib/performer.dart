import 'package:jamnight/experiencelevel.dart';

import 'instrument.dart';

// This class represents a single performer that could be added to a jam band.
// It contains a name, an instrument, and a skill level.
class Performer {
  const Performer({
    required this.name,
    required this.instrument,
    required this.experienceLevel,
    required this.created,
  });

  final String name;
  final Instrument instrument;
  final ExperienceLevel experienceLevel;
  final DateTime created;

  // Two performers should be considered equal if they have the same name.
  @override
  bool operator ==(Object other) {
    return other is Performer && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  // This method returns a string representation of the performer.
  @override
  String toString() {
    return 'Performer(name: $name, instrument: $instrument, experienceLevel: $experienceLevel)';
  }
}
