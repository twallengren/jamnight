import 'package:quiver/collection.dart';

import '../datastore.dart';
import '../model/instrument/instrument.dart';
import '../model/performer/performer.dart';
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
          performer.recommendPerformer();
          recommendedPerformers.add(performer);
          priorityPlayerNotFound = false;
        } else if (performer.getPerformerStatus() != PerformerStatus.selected) {
          nonPriorityPlayers.add(performer);
        }
      }
    }
    nonPriorityPlayers.sort();
    recommendedPerformers.addAll(nonPriorityPlayers);
    return recommendedPerformers;
  }
}
