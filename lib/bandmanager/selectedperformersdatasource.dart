import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../data/datastore.dart';
import '../model/performer/performer.dart';

class SelectedPerformersDataSource extends DataGridSource {
  SelectedPerformersDataSource({required this.dataStore});

  final DataStore dataStore;

  @override
  List<DataGridRow> get rows => getBandRows(dataStore);

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(e.value.toString()),
      );
    }).toList());
  }

  List<DataGridRow> getBandRows(DataStore dataStore) {
    List<DataGridRow> bandRows = [];

    List<Performer> selectedPerformers = dataStore.selectedPerformers;

    for (Performer performer in selectedPerformers) {
      bandRows.add(DataGridRow(cells: <DataGridCell>[
        DataGridCell(columnName: 'Name', value: performer.name),
        DataGridCell(
            columnName: 'Instrument',
            value: performer.instrument.name.toUpperCase()),
      ]));
    }

    return bandRows;
  }
}