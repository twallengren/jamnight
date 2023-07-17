import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jamnight/performermanager/enternamebox.dart';

void main() {
  group('EnterNameBox widget', () {
    testWidgets('initializes without error', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: EnterNameBox(nameController: TextEditingController()))));
    });
  });
}
