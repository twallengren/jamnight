import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../data/datastore.dart';
import 'recommendedperformersdatasource.dart';

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
