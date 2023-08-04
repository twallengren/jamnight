import 'package:flutter_test/flutter_test.dart';
import 'package:jamnight/data/datastore.dart';
import 'package:jamnight/model/instrument/instrument.dart';
import 'package:jamnight/model/performer/experiencelevel.dart';
import 'package:jamnight/model/performer/performer.dart';
import 'package:jamnight/performermanager/performersdatasource.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  group('PerformersDataSource', () {
    test('PerformerDataSource rows populate with performer', () {
      Performer guitaristA = Performer(
          name: 'guitaristA',
          instrument: Instrument.guitar,
          experienceLevel: ExperienceLevel.beginner,
          created: DateTime.now());

      DataStore dataStore = DataStore();
      dataStore.addPerformer(guitaristA);

      PerformersDataSource performersDataSource =
          PerformersDataSource(dataStore: dataStore);
      List<DataGridRow> rows = performersDataSource.rows;

      expect(rows.length, equals(1));
    });
  });
}
