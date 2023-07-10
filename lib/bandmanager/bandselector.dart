import 'package:quiver/collection.dart';
import '../model/performer.dart';
import '../model/instrument/instrument.dart';

class BandSelector {
  static List<Performer> getRecommendedPerformers(
      Multimap<Instrument, Performer> performers) {
    List<Performer> band = [];
    for (Instrument instrument in Instrument.values) {
      List<Performer> performersForInstrument = performers[instrument].toList();
      if (performersForInstrument.isNotEmpty) {
        band.add(performersForInstrument.first);
      }
    }
    return band;
  }
}
