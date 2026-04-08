import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// This MUST match the name: study in your pubspec.yaml
import 'package:study/main.dart';

void main() {
  testWidgets('App load test', (WidgetTester tester) async {
    // This will now recognize MyApp because of the import above
    await tester.pumpWidget(const MyApp());

    expect(find.text('Studify'), findsOneWidget);
  });
}