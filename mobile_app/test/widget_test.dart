import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_apps/main.dart';

void main() {
  testWidgets('shows symptom checker home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Symptom Checker'), findsOneWidget);
    expect(find.text('AI Healthcare Assistant'), findsOneWidget);
    expect(find.text('Fever'), findsOneWidget);

    await tester.tap(find.text('Fever'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });
}
