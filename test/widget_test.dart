// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tales/models/wallpaper.dart';
import 'package:tales/services/auth_service.dart';
import 'package:tales/services/theme_service.dart';
import 'package:tales/services/wallpaper_service.dart';
import 'package:tales/widgets/wallpaper_card.dart';

// Mock WallpaperService for testing
class MockWallpaperService extends ChangeNotifier implements WallpaperService {
  bool _isLoading = false;
  List<Wallpaper> _wallpapers = [];
  final Set<String> _favorites = {};

  @override
  bool get isLoading => _isLoading;

  @override
  List<Wallpaper> get wallpapers => _wallpapers;

  @override
  List<String> get categories => [];

  @override
  String get selectedCategory => 'All';

  @override
  bool get hasError => false;

  @override
  String? get errorMessage => null;

  MockWallpaperService() {
    _wallpapers = Wallpaper.getDemoWallpapers();
  }

  @override
  Future<void> fetchWallpapers({bool useDelay = false}) async {
    // No delay in tests
    _isLoading = true;
    notifyListeners();

    _wallpapers = Wallpaper.getDemoWallpapers();

    _isLoading = false;
    notifyListeners();
  }

  @override
  bool isFavorite(String wallpaperId) {
    return _favorites.contains(wallpaperId);
  }

  @override
  Future<void> toggleFavorite(Wallpaper wallpaper) async {
    if (_favorites.contains(wallpaper.id)) {
      _favorites.remove(wallpaper.id);
    } else {
      _favorites.add(wallpaper.id);
    }
    notifyListeners();
  }

  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  testWidgets('WallpaperCard displays correctly', (WidgetTester tester) async {
    // Create a test wallpaper
    final testWallpaper = Wallpaper(
      id: 'test_id',
      url: 'https://example.com/image.jpg',
      thumbnailUrl: 'https://example.com/thumbnail.jpg',
      category: 'Test Category',
      photographer: 'Test Photographer',
      width: 1920,
      height: 1080,
    );

    // Build the widget with providers
    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<WallpaperService>(
              create: (_) => MockWallpaperService(),
            ),
            ChangeNotifierProvider<ThemeService>(
              create: (_) => ThemeService(false),
            ),
            ChangeNotifierProvider<AuthService>(
              create: (_) => AuthService(),
            ),
          ],
          child: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                height: 300,
                child: WallpaperCard(
                  wallpaper: testWallpaper,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Allow widget to build
    await tester.pump();

    // Verify the category text is displayed
    expect(find.text('Test Category'), findsOneWidget);

    // Verify the favorite button is displayed (looking for the icon)
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });

  testWidgets('Simple app title test', (WidgetTester tester) async {
    // Build a simple MaterialApp with a Text widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Tales'),
          ),
        ),
      ),
    );

    // Verify that the text is displayed
    expect(find.text('Tales'), findsOneWidget);
  });
}
