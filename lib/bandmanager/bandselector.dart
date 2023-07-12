import 'package:quiver/collection.dart';
import '../model/performer/performer.dart';
import '../model/instrument/instrument.dart';
import '../datastore.dart';
import '../model/performer/performerstatus.dart';

class BandSelector {
  static List<Performer> getRecommendedPerformers(DataStore dataStore) {
    Multimap<Instrument, Performer> performersByInstrument =
        dataStore.getPerformersByInstrument();
    List<Performer> recommendedPerformers = [];
    List<Performer> nonPriorityPlayers = [];

    for (Instrument instrument in Instrument.values) {
      List<Performer> performersForInstrument =
          performersByInstrument[instrument].toList();
      bool priorityPlayerNotFound = true;
      for (Performer performer in performersForInstrument) {
        if (priorityPlayerNotFound &&
            performer.getPerformerStatus() != PerformerStatus.selected) {
          performer.setPerformerStatus(PerformerStatus.recommended);
          recommendedPerformers.add(performer);
          priorityPlayerNotFound = false;
        } else if (performer.getPerformerStatus() != PerformerStatus.selected) {
          nonPriorityPlayers.add(performer);
        }
      }
    }
    nonPriorityPlayers.sort((Performer performerA, Performer performerB) =>
        _performerComparison(performerA, performerB));
    recommendedPerformers.addAll(nonPriorityPlayers);
    return recommendedPerformers;
  }

  static int _performerComparison(Performer performerA, Performer performerB) {
    int numberOfTimesPlayedComparison = performerA
        .getNumberOfTimesPlayed()
        .compareTo(performerB.getNumberOfTimesPlayed());
    if (numberOfTimesPlayedComparison == 0) {
      return performerA.getLastPlayed().compareTo(performerB.getLastPlayed());
    } else {
      return numberOfTimesPlayedComparison;
    }
  }
}
