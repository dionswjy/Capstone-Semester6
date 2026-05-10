import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    // Build a simple app to test
    await tester.pumpWidget(const MaterialApp(home: Scaffold()));

    // Verify that the widget is built
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
