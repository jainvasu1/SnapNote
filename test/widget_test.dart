import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:snap_note/main.dart';

void main() {
  testWidgets('shows login form', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Login'), findsWidgets);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('validates empty login fields', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter email and password'), findsOneWidget);
  });
}
