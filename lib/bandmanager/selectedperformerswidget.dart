import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../data/datastore.dart';
import 'selectedperformersdatasource.dart';

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
