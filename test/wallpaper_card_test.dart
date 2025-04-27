import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Simple widget test', (WidgetTester tester) async {
    // Build a simple widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('WallpaperCard Test'),
          ),
        ),
      ),
    );

    // Verify the text is displayed
    expect(find.text('WallpaperCard Test'), findsOneWidget);
  });
}
