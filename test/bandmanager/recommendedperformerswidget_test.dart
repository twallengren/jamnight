import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jamnight/bandmanager/recommendedperformerswidget.dart';
import 'package:jamnight/data/datastore.dart';
import 'package:jamnight/data/jamnightdao.dart';
import 'package:provider/provider.dart';

import '../data/datastore_test.mocks.dart';

void main() {
  group('RecommendedPerformers', () {
    late JamNightDAO mockJamNightDAO;

    setUp(() {
      mockJamNightDAO = MockJamNightDAO();
    });
    testWidgets('initializes without error', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: ChangeNotifierProvider(
        create: (_) => DataStore(mockJamNightDAO),
        child: const RecommendedPerformersWidget(),
      )));
    });
  });
}
