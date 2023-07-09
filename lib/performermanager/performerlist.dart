import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datastore.dart';
import '../model/performer.dart';

class PerformerList extends StatefulWidget {
  const PerformerList({super.key});

  @override
  State<PerformerList> createState() => _PerformerListState();
}

class _PerformerListState extends State<PerformerList> {
  @override
  Widget build(BuildContext context) {
    var dataStore = Provider.of<DataStore>(context, listen: true);
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
        DataColumn(
          label: Text(
            'Created',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows: dataStore
          .getPerformers()
          .map((Performer performer) => DataRow(cells: <DataCell>[
                DataCell(Text(performer.name)),
                DataCell(Text(performer.instrument.name.toUpperCase())),
                DataCell(Text(performer.experienceLevel.name.toUpperCase())),
                DataCell(Text(performer.created.toString())),
              ]))
          .toList(),
    );
  }
}
