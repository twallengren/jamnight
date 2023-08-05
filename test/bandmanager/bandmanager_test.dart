import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jamnight/bandmanager/bandmanager.dart';
import 'package:jamnight/data/datastore.dart';
import 'package:provider/provider.dart';

void main() {
  group('BandManager', () {
    testWidgets('initializes without error', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: ChangeNotifierProvider(
        create: (_) => DataStore(),
        child: const BandManager(),
      )));
    });
  });
}
