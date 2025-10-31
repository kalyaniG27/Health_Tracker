// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_tracker_app/main.dart';
import 'package:health_tracker_app/utils/data_manager.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // We need to wrap the app in the provider for it to work.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => DataManager(),
        child: const HealthEcoTracker(),
      ),
    );

    // Verify that the Dashboard title is present.
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
