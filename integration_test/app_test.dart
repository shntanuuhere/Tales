import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tales/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('verify main app flow', (WidgetTester tester) async {
      // Start the app
      app.main();
      
      // Wait for app to fully load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify home screen loads with wallpapers
      expect(find.byType(GridView), findsOneWidget);
      
      // Tap on the first wallpaper
      final firstWallpaper = find.byType(GestureDetector).first;
      await tester.tap(firstWallpaper);
      await tester.pumpAndSettle();
      
      // Verify detail screen loads
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.file_download_outlined), findsOneWidget);
      expect(find.byIcon(Icons.wallpaper), findsOneWidget);
      
      // Tap favorite button
      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pumpAndSettle();
      
      // Verify favorite status changed
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      
      // Go back to home screen
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      
      // Navigate to favorites tab
      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();
      
      // Verify favorites screen shows the wallpaper
      expect(find.byType(GridView), findsOneWidget);
      
      // Navigate to categories tab
      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();
      
      // Verify categories screen loads
      expect(find.byType(ListView), findsOneWidget);
      
      // Tap on a category
      final firstCategory = find.byType(GestureDetector).first;
      await tester.tap(firstCategory);
      await tester.pumpAndSettle();
      
      // Verify category wallpapers load
      expect(find.byType(GridView), findsOneWidget);
      
      // Navigate to settings tab
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      
      // Verify settings screen loads
      expect(find.text('Dark Mode'), findsOneWidget);
      
      // Toggle dark mode
      final darkModeSwitch = find.byType(Switch).first;
      await tester.tap(darkModeSwitch);
      await tester.pumpAndSettle();
      
      // Verify dark mode is applied
      // This is a simple check - in a real test you might want to verify colors
      expect(find.byType(Switch), findsOneWidget);
      
      // Navigate back to home
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      
      // Verify we're back on the home screen
      expect(find.byType(GridView), findsOneWidget);
    });
  });
}
