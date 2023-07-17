import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jamnight/model/instrument/instrument.dart';
import 'package:jamnight/performermanager/components/instrumentdropdown.dart';

void main() {
  group('InstrumentDropdown widget', () {
    testWidgets('initializes without error', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: InstrumentDropdown(
        onInstrumentSelected: (Instrument instrument) => {},
      ))));
    });
  });
}
