import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../data/datastore.dart';
import '../model/performer/performer.dart';

class RecommendedPerformersDataSource extends DataGridSource {
  RecommendedPerformersDataSource({required this.dataStore});

  final DataStore dataStore;

  @override
  List<DataGridRow> get rows => getBandRows();

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

  List<DataGridRow> getBandRows() {
    List<DataGridRow> bandRows = [];

    List<Performer> recommendedPerformers = dataStore.recommendedPerformers;

    for (Performer performer in recommendedPerformers) {
      bandRows.add(DataGridRow(cells: <DataGridCell>[
        DataGridCell(
            columnName: 'Performer',
            value:
                '${performer.name} (${performer.instrument.name.toUpperCase()})'),
        DataGridCell(
            columnName: 'Number of Times Played',
            value: performer.numberOfTimesPlayed),
        DataGridCell(
            columnName: 'Last Played', value: timeToNearestMinute(performer)),
      ]));
    }

    return bandRows;
  }

  String timeToNearestMinute(Performer performer) {
    if (performer.numberOfTimesPlayed == 0) {
      return 'N/A';
    }
    DateTime dt = performer.lastPlayed;
    String twoDigit(int n) => n.toString().padLeft(2, '0');
    return '${twoDigit(dt.hour)}:${twoDigit(dt.minute)}';
  }
}