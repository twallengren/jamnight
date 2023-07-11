import 'package:quiver/collection.dart';
import '../model/performer/performer.dart';
import '../model/instrument/instrument.dart';
import '../datastore.dart';
import '../model/performer/performerstatus.dart';

class BandSelector {
  static List<Performer> getRecommendedPerformers(DataStore dataStore) {
    Multimap<Instrument, Performer> performersByInstrument =
        dataStore.getPerformersByInstrument();
    List<Performer> band = [];
    for (Instrument instrument in Instrument.values) {
      List<Performer> performersForInstrument =
          performersByInstrument[instrument].toList();
      for (Performer performer in performersForInstrument) {
        if (performer.status != PerformerStatus.selected) {
          performer.setPerformerStatus(PerformerStatus.recommended);
          band.add(performer);
          break;
        }
      }
    }
    return band;
  }
}
