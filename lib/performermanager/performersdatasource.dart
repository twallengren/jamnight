import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../model/performer/performer.dart';

class PerformersDataSource extends DataGridSource {
  PerformersDataSource({required this.performers});

  final List<Performer> performers;

  @override
  List<DataGridRow> get rows => _getPerformerRows(performers);

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

  List<DataGridRow> _getPerformerRows(List<Performer> performers) {
    List<DataGridRow> performerRows = [];

    for (Performer performer in performers) {
      performerRows.add(DataGridRow(cells: <DataGridCell>[
        DataGridCell(columnName: 'Name', value: performer.name),
        DataGridCell(
            columnName: 'Instrument',
            value: performer.instrument.name.toUpperCase()),
        DataGridCell(
            columnName: 'Experience Level',
            value: performer.experienceLevel.name.toUpperCase()),
      ]));
    }

    return performerRows;
  }
}
