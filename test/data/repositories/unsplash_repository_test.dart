import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tales/data/api/unsplash_api_client.dart';
import 'package:tales/features/wallpapers/domain/entities/wallpaper.dart';
import 'package:tales/features/wallpapers/data/repositories/unsplash_repository.dart';

// Mock classes manually since we're having issues with build_runner
class MockUnsplashApiClient extends Mock implements UnsplashApiClient {}

void main() {
  // Initialize Flutter binding
  TestWidgetsFlutterBinding.ensureInitialized();

  late UnsplashRepository repository;
  late MockUnsplashApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockUnsplashApiClient();
    repository = UnsplashRepository(apiClient: mockApiClient);
  });

  group('UnsplashRepository', () {
    test('toggleFavorite adds and removes wallpaper from favorites', () async {
      // Arrange
      final wallpaper = Wallpaper(
        id: 'test1',
        url: 'https://example.com/photo1.jpg',
        thumbnailUrl: 'https://example.com/thumb1.jpg',
        category: 'Nature',
        photographer: 'Test User',
        width: 1920,
        height: 1080,
      );

      // Act - Add to favorites
      final addResult = await repository.toggleFavorite(wallpaper);
      final isFavoriteAfterAdd = await repository.isFavorite(wallpaper.id);

      // Act - Remove from favorites
      final removeResult = await repository.toggleFavorite(wallpaper);
      final isFavoriteAfterRemove = await repository.isFavorite(wallpaper.id);

      // Assert
      expect(addResult, true);
      expect(isFavoriteAfterAdd, true);
      expect(removeResult, true);
      expect(isFavoriteAfterRemove, false);
    });

    test('getFavoriteWallpapers returns empty list when no favorites', () async {
      // Act
      final result = await repository.getFavoriteWallpapers();

      // Assert
      expect(result, isEmpty);
    });
  });
}
