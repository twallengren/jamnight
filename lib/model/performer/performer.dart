import 'package:jamnight/model/experiencelevel.dart';

import '../instrument/instrument.dart';
import 'performerstatus.dart';

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
  DateTime? _lastPlayed;
  PerformerStatus _status = PerformerStatus.present;
  int _numberOfTimesPlayed = 0;

  void setLastPlayed(DateTime dateTime) {
    _lastPlayed = dateTime;
  }

  DateTime getLastPlayed() {
    if (_lastPlayed == null) {
      return created;
    }
    return _lastPlayed!;
  }

  void setPerformerStatus(PerformerStatus performerStatus) {
    _status = performerStatus;
  }

  PerformerStatus getPerformerStatus() {
    return _status;
  }

  void incrementNumberOfTimesPlayed() {
    _numberOfTimesPlayed++;
  }

  int getNumberOfTimesPlayed() {
    return _numberOfTimesPlayed;
  }

  @override
  bool operator ==(Object other) {
    return other is Performer &&
        other.name == name &&
        other.instrument == instrument;
  }

  @override
  int get hashCode => name.hashCode ^ instrument.hashCode;

  @override
  String toString() {
    return 'Performer(name: $name, instrument: $instrument, experienceLevel: $experienceLevel)';
  }
}
