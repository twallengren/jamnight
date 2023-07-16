import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../datastore.dart';
import '../model/performer/performer.dart';

class PerformerList extends StatefulWidget {
  const PerformerList({super.key});

  @override
  State<PerformerList> createState() => _PerformerListState();
}

class _PerformerListState extends State<PerformerList> {
  @override
  Widget build(BuildContext context) {
    var dataStore = Provider.of<DataStore>(context, listen: true);
    return Center(
      child: Column(
        children: [
          const Text('Selected Performers'),
          SfDataGrid(
            allowSwiping: true,
            swipeMaxOffset: 100,
            columnWidthMode: ColumnWidthMode.fill,
            horizontalScrollPhysics: const BouncingScrollPhysics(),
            source: PerformersDataSource(dataStore: dataStore),
            endSwipeActionsBuilder:
                (BuildContext context, DataGridRow dataGridRow, int rowIndex) {
              return GestureDetector(
                onTap: () => dataStore.removePerformerByIndex(rowIndex),
                child: Container(
                  color: Colors.redAccent,
                  child: const Center(child: Icon(Icons.remove)),
                ),
              );
            },
            columns: <GridColumn>[
              GridColumn(
                columnName: 'Name',
                label: const Text('Name'),
              ),
              GridColumn(
                columnName: 'Instrument',
                label: const Text('Instrument'),
              ),
              GridColumn(
                columnName: 'Experience Level',
                label: const Text('Experience Level'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PerformersDataSource extends DataGridSource {
  PerformersDataSource({required this.dataStore});

  final DataStore dataStore;

  @override
  List<DataGridRow> get rows => getPerformerRows(dataStore);

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

  List<DataGridRow> getPerformerRows(DataStore dataStore) {
    List<DataGridRow> performerRows = [];

    List<Performer> selectedPerformers = dataStore.getPerformers();

    for (Performer performer in selectedPerformers) {
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
