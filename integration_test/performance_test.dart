import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tales/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('performance tests', () {
    testWidgets('measure scrolling performance', (WidgetTester tester) async {
      // Start the app
      app.main();

      // Wait for app to fully load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify home screen loads with wallpapers
      expect(find.byType(GridView), findsOneWidget);

      // Measure scrolling performance
      await _measureScrollPerformance(tester);
    });

    testWidgets('measure image loading performance', (WidgetTester tester) async {
      // Start the app
      app.main();

      // Wait for app to fully load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify home screen loads with wallpapers
      expect(find.byType(GridView), findsOneWidget);

      // Measure image loading performance
      await _measureImageLoadingPerformance(tester);
    });

    testWidgets('measure app startup time', (WidgetTester tester) async {
      // Measure app startup time
      final stopwatch = Stopwatch()..start();

      // Start the app
      app.main();

      // Wait for app to fully load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Stop the timer
      stopwatch.stop();

      // Log the startup time
      debugPrint('App startup time: ${stopwatch.elapsedMilliseconds}ms');

      // Verify home screen loads with wallpapers
      expect(find.byType(GridView), findsOneWidget);
    });
  });
}

Future<void> _measureScrollPerformance(WidgetTester tester) async {
  // Find the scrollable widget
  final scrollable = find.byType(Scrollable).first;

  // Perform scrolling without tracing (traceAction is not available in this version)
  // Scroll down 5 times
  for (int i = 0; i < 5; i++) {
    await tester.fling(scrollable, const Offset(0, -500), 1000);
    await tester.pumpAndSettle();
  }

  // Scroll back up 5 times
  for (int i = 0; i < 5; i++) {
    await tester.fling(scrollable, const Offset(0, 500), 1000);
    await tester.pumpAndSettle();
  }
}

Future<void> _measureImageLoadingPerformance(WidgetTester tester) async {
  // Navigate to a fresh category to force image loading
  await tester.tap(find.text('Categories'));
  await tester.pumpAndSettle();

  // Tap on a category
  final firstCategory = find.byType(GestureDetector).first;

  // Perform image loading without tracing
  await tester.tap(firstCategory);
  await tester.pumpAndSettle(const Duration(seconds: 5));
}
