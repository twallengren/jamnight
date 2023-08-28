import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../data/datastore.dart';
import '../model/performer/performer.dart';

class RecommendedPerformersWidget extends StatefulWidget {
  const RecommendedPerformersWidget({super.key});

  @override
  State<RecommendedPerformersWidget> createState() =>
      _RecommendedPerformersWidgetState();
}

class _RecommendedPerformersWidgetState
    extends State<RecommendedPerformersWidget> {
  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    DataStore dataStore = Provider.of<DataStore>(context, listen: true);
    return Center(
      child: Column(
        children: [
          const Text('Recommended Performers'),
          SfDataGrid(
            allowSwiping: true,
            swipeMaxOffset: 100,
            columnWidthMode: ColumnWidthMode.fill,
            horizontalScrollPhysics: const BouncingScrollPhysics(),
            source: RecommendedPerformersDataSource(dataStore: dataStore),
            startSwipeActionsBuilder:
                (BuildContext context, DataGridRow dataGridRow, int rowIndex) {
              return GestureDetector(
                onTap: () =>
                    dataStore.movePerformerFromRecommendedToSelected(rowIndex),
                child: Container(
                  color: Colors.greenAccent,
                  child: const Center(child: Icon(Icons.add)),
                ),
              );
            },
            columns: <GridColumn>[
              GridColumn(
                columnName: 'Performer',
                label: const Text('Performer'),
              ),
              GridColumn(
                columnName: 'Times Played',
                label: const Text('Times Played'),
              ),
              GridColumn(
                columnName: 'Last Played',
                label: const Text('Last Played'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
