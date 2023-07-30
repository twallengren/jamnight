import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jamnight/homepage/homepage.dart';

void main() {
  group('Homepage widget', () {
    testWidgets('initializes without error', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
    });
  });
}
