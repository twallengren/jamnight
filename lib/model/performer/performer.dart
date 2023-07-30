import 'package:jamnight/model/performer/experiencelevel.dart';

import '../instrument/instrument.dart';
import 'performerstatus.dart';

class Performer implements Comparable<Performer> {
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

  DateTime getLastPlayed() {
    if (_lastPlayed == null) {
      return created;
    }
    return _lastPlayed!;
  }

  PerformerStatus getPerformerStatus() {
    return _status;
  }

  int getNumberOfTimesPlayed() {
    return _numberOfTimesPlayed;
  }

  void recommendPerformer() {
    _status = PerformerStatus.recommended;
  }

  void selectPerformer() {
    _status = PerformerStatus.selected;
  }

  void unselectPerformer() {
    if (_status != PerformerStatus.selected) {
      throw Exception('Cannot unselect a performer that is not selected');
    }
    _status = PerformerStatus.present;
  }

  void finalizePerformer() {
    if (_status != PerformerStatus.selected) {
      throw Exception('Cannot finalize a performer that is not selected');
    }
    _status = PerformerStatus.present;
    _lastPlayed = DateTime.now();
    _numberOfTimesPlayed++;
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

  @override
  int compareTo(Performer other) {
    int numberOfTimesPlayedComparison =
        _numberOfTimesPlayed.compareTo(other.getNumberOfTimesPlayed());
    if (numberOfTimesPlayedComparison == 0) {
      return getLastPlayed().compareTo(other.getLastPlayed());
    } else {
      return numberOfTimesPlayedComparison;
    }
  }
}
