import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiver/collection.dart';
import '../datastore.dart';
import '../model/performer.dart';
import '../model/instrument/instrument.dart';
import 'bandselector.dart';

class RecommendedPerformersWidget extends StatefulWidget {
  const RecommendedPerformersWidget({super.key});

  @override
  State<RecommendedPerformersWidget> createState() =>
      _RecommendedPerformersWidgetState();
}

class _RecommendedPerformersWidgetState
    extends State<RecommendedPerformersWidget> {
  @override
  Widget build(BuildContext context) {
    DataStore dataStore = Provider.of<DataStore>(context, listen: true);
    return Column(
      children: [
        const Text('Recommended Players'),
        DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Name',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Instrument',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Experience Level',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
          rows: getBandRows(dataStore),
        ),
      ],
    );
  }

  List<DataRow> getBandRows(DataStore dataStore) {
    List<DataRow> bandRows = [];

    Multimap<Instrument, Performer> performers =
        dataStore.getPerformersByInstrument();
    List<Performer> selectedPerformers = BandSelector.selectBand(performers);

    for (Performer performer in selectedPerformers) {
      bandRows.add(DataRow(cells: <DataCell>[
        DataCell(Text(performer.name)),
        DataCell(Text(performer.instrument.name.toUpperCase())),
        DataCell(Text(performer.experienceLevel.name.toUpperCase())),
      ]));
    }

    return bandRows;
  }
}
