import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datastore.dart';
import '../model/performer.dart';
import '../model/instrument.dart';

class BandList extends StatefulWidget {
  const BandList({super.key});

  @override
  State<BandList> createState() => _BandListState();
}

class _BandListState extends State<BandList> {
  @override
  Widget build(BuildContext context) {
    DataStore dataStore = Provider.of<DataStore>(context, listen: true);
    return DataTable(
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
    );
  }

  List<DataRow> getBandRows(DataStore dataStore) {
    List<DataRow> bandRows = [];

    for (Instrument instrument in Instrument.values) {
      List<Performer> performers =
          dataStore.getPerformersByInstrument(instrument);
      Performer? selectedPerformer = selectPerformer(performers);
      if (selectedPerformer != null) {
        bandRows.add(DataRow(cells: <DataCell>[
          DataCell(Text(selectedPerformer.name)),
          DataCell(Text(selectedPerformer.instrument.name.toUpperCase())),
          DataCell(Text(selectedPerformer.experienceLevel.name.toUpperCase())),
        ]));
      }
    }
    return bandRows;
  }

  Performer? selectPerformer(List<Performer> performers) {
    if (performers.isNotEmpty) {
      return performers.first;
    } else {
      return null;
    }
  }
}
