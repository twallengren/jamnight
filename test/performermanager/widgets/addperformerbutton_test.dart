import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jamnight/performermanager/widgets/addperformerbutton.dart';

void main() {
  group('AddPerformerButton widget', () {
    testWidgets('initializes without error', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: AddPerformerButton(onAddPerformerPressed: () => {})));
    });
  });
}
