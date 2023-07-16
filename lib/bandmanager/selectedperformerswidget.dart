import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../datastore.dart';
import '../model/performer/performer.dart';

class SelectedPerformersWidget extends StatefulWidget {
  const SelectedPerformersWidget({super.key});

  @override
  State<SelectedPerformersWidget> createState() =>
      _SelectedPerformersWidgetState();
}

class _SelectedPerformersWidgetState extends State<SelectedPerformersWidget> {
  @override
  Widget build(BuildContext context) {
    DataStore dataStore = Provider.of<DataStore>(context, listen: true);
    return Center(
      child: Column(
        children: [
          const Text('Selected Performers'),
          SfDataGrid(
            allowSwiping: true,
            swipeMaxOffset: 100,
            columnWidthMode: ColumnWidthMode.fill,
            horizontalScrollPhysics: const BouncingScrollPhysics(),
            source: SelectedPerformersDataSource(dataStore: dataStore),
            endSwipeActionsBuilder:
                (BuildContext context, DataGridRow dataGridRow, int rowIndex) {
              return GestureDetector(
                onTap: () =>
                    dataStore.removePerformerFromSelectedPerformers(rowIndex),
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
          ElevatedButton(
            onPressed: () => dataStore.finalizeSelectedBand(),
            child: const Text('Finalize Band'),
          )
        ],
      ),
    );
  }
}

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

    List<Performer> selectedPerformers = dataStore.getSelectedPerformers();

    for (Performer performer in selectedPerformers) {
      bandRows.add(DataGridRow(cells: <DataGridCell>[
        DataGridCell(columnName: 'Name', value: performer.name),
        DataGridCell(
            columnName: 'Instrument',
            value: performer.instrument.name.toUpperCase()),
        DataGridCell(
            columnName: 'Experience Level',
            value: performer.experienceLevel.name.toUpperCase()),
      ]));
    }

    return bandRows;
  }
}
