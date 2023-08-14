import 'package:flutter_test/flutter_test.dart';
import 'package:jamnight/data/datastore.dart';
import 'package:jamnight/data/jamnightdao.dart';
import 'package:jamnight/model/instrument/instrument.dart';
import 'package:jamnight/model/performer/experiencelevel.dart';
import 'package:jamnight/model/performer/performer.dart';
import 'package:jamnight/model/performer/performerstatus.dart';
import 'package:jamnight/performermanager/performersdatasource.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../data/datastore_test.mocks.dart';

void main() {
  late JamNightDAO mockJamNightDAO;

    setUp(() {
      mockJamNightDAO = MockJamNightDAO();
    });
  group('PerformersDataSource', () {
    test('PerformerDataSource rows populate with performer', () {
      DateTime now = DateTime.now();
      Performer guitaristA = Performer(
          name: 'guitaristA',
          instrument: Instrument.guitar,
          experienceLevel: ExperienceLevel.beginner,
          created: now,
          status: PerformerStatus.present,
          isJamRegular: false,
          lastPlayed: now,
          numberOfTimesPlayed: 0);

      DataStore dataStore = DataStore(mockJamNightDAO);
      dataStore.addPerformerToCurrentJam(guitaristA);

      PerformersDataSource performersDataSource =
          PerformersDataSource(performers: dataStore.allPerformers);
      List<DataGridRow> rows = performersDataSource.rows;

      expect(rows.length, equals(1));
    });
  });
}
