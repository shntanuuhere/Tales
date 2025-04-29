import 'package:flutter_test/flutter_test.dart';
import 'package:tales/features/wallpapers/domain/entities/wallpaper.dart';

void main() {
  group('Wallpaper Model Tests', () {
    test('Create wallpaper from constructor', () {
      final wallpaper = Wallpaper(
        id: 'test_id',
        url: 'https://example.com/image.jpg',
        thumbnailUrl: 'https://example.com/thumbnail.jpg',
        category: 'Nature',
        photographer: 'Test Photographer',
        width: 1920,
        height: 1080,
      );

      expect(wallpaper.id, 'test_id');
      expect(wallpaper.url, 'https://example.com/image.jpg');
      expect(wallpaper.thumbnailUrl, 'https://example.com/thumbnail.jpg');
      expect(wallpaper.category, 'Nature');
      expect(wallpaper.photographer, 'Test Photographer');
      expect(wallpaper.width, 1920);
      expect(wallpaper.height, 1080);
      expect(wallpaper.isFavorite, false);
    });

    test('Create wallpaper with copyWith', () {
      final wallpaper = Wallpaper(
        id: 'test_id',
        url: 'https://example.com/image.jpg',
        thumbnailUrl: 'https://example.com/thumbnail.jpg',
        category: 'Nature',
        photographer: 'Test Photographer',
        width: 1920,
        height: 1080,
      );

      final updatedWallpaper = wallpaper.copyWith(
        isFavorite: true,
        category: 'Abstract',
      );

      // Original wallpaper should remain unchanged
      expect(wallpaper.isFavorite, false);
      expect(wallpaper.category, 'Nature');

      // Updated wallpaper should have new values
      expect(updatedWallpaper.id, 'test_id'); // Same ID
      expect(updatedWallpaper.url, 'https://example.com/image.jpg'); // Same URL
      expect(updatedWallpaper.isFavorite, true); // Updated
      expect(updatedWallpaper.category, 'Abstract'); // Updated
    });

    test('Wallpaper equality', () {
      final wallpaper1 = Wallpaper(
        id: 'test_id',
        url: 'https://example.com/image.jpg',
        thumbnailUrl: 'https://example.com/thumbnail.jpg',
        category: 'Nature',
        photographer: 'Test Photographer',
        width: 1920,
        height: 1080,
      );

      final wallpaper2 = Wallpaper(
        id: 'test_id', // Same ID
        url: 'https://example.com/image.jpg',
        thumbnailUrl: 'https://example.com/thumbnail.jpg',
        category: 'Nature',
        photographer: 'Test Photographer',
        width: 1920,
        height: 1080,
      );

      final wallpaper3 = Wallpaper(
        id: 'different_id', // Different ID
        url: 'https://example.com/image.jpg',
        thumbnailUrl: 'https://example.com/thumbnail.jpg',
        category: 'Nature',
        photographer: 'Test Photographer',
        width: 1920,
        height: 1080,
      );

      // Wallpapers with the same ID should be equal
      expect(wallpaper1 == wallpaper2, true);

      // Wallpapers with different IDs should not be equal
      expect(wallpaper1 == wallpaper3, false);
    });
  });
}
