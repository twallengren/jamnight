import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../data/datastore.dart';
import 'performersdatasource.dart';

class PerformerList extends StatefulWidget {
  const PerformerList({super.key});

  @override
  State<PerformerList> createState() => _PerformerListState();
}

class _PerformerListState extends State<PerformerList> {
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
