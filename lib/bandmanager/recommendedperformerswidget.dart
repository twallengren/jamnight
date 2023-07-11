import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiver/collection.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../datastore.dart';
import '../model/performer.dart';
import '../model/instrument/instrument.dart';
import 'bandselector.dart';

class RecommendedPerformersWidget extends StatefulWidget {
  const RecommendedPerformersWidget({super.key});

  @override
  State<RecommendedPerformersWidget> createState() =>
      _RecommendedPerformersWidgetState();
}

class _RecommendedPerformersWidgetState
    extends State<RecommendedPerformersWidget> {
  @override
  Widget build(BuildContext context) {
    DataStore dataStore = Provider.of<DataStore>(context, listen: true);
    return Center(
      child: Column(
        children: [
          const Text('Recommended Players'),
          SfDataGrid(
            allowSwiping: true,
            swipeMaxOffset: 100,
            columnWidthMode: ColumnWidthMode.fill,
            horizontalScrollPhysics: const BouncingScrollPhysics(),
            source: RecommendedPerformersDataSource(dataStore: dataStore),
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

class RecommendedPerformersDataSource extends DataGridSource {
  RecommendedPerformersDataSource({required this.dataStore});

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

    Multimap<Instrument, Performer> performers =
        dataStore.getPerformersByInstrument();
    List<Performer> recommendedPerformers =
        BandSelector.getRecommendedPerformers(performers);

    for (Performer performer in recommendedPerformers) {
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