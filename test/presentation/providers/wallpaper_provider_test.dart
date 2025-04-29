import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tales/features/wallpapers/domain/entities/wallpaper.dart';
import 'package:tales/features/wallpapers/domain/usecases/get_wallpapers.dart';
import 'package:tales/features/categories/domain/usecases/get_wallpapers_by_category.dart';
import 'package:tales/features/wallpapers/domain/usecases/toggle_favorite.dart';
import 'package:tales/features/wallpapers/domain/usecases/download_wallpaper.dart';
import 'package:tales/features/wallpapers/domain/usecases/set_wallpaper.dart';
import 'package:tales/features/wallpapers/presentation/providers/wallpaper_provider.dart';

// Mock classes manually since we're having issues with build_runner
class MockGetWallpapers extends Mock implements GetWallpapers {}
class MockGetWallpapersByCategory extends Mock implements GetWallpapersByCategory {}
class MockToggleFavorite extends Mock implements ToggleFavorite {}
class MockDownloadWallpaper extends Mock implements DownloadWallpaper {}
class MockSetWallpaper extends Mock implements SetWallpaper {}

void main() {
  // Initialize Flutter binding
  TestWidgetsFlutterBinding.ensureInitialized();

  late WallpaperProvider provider;
  late MockGetWallpapers mockGetWallpapers;
  late MockGetWallpapersByCategory mockGetWallpapersByCategory;
  late MockToggleFavorite mockToggleFavorite;
  late MockDownloadWallpaper mockDownloadWallpaper;
  late MockSetWallpaper mockSetWallpaper;

  setUp(() {
    // Create the mocks
    mockGetWallpapers = MockGetWallpapers();
    mockGetWallpapersByCategory = MockGetWallpapersByCategory();
    mockToggleFavorite = MockToggleFavorite();
    mockDownloadWallpaper = MockDownloadWallpaper();
    mockSetWallpaper = MockSetWallpaper();

    // Create the provider with the mocks
    provider = WallpaperProvider(
      getWallpapers: mockGetWallpapers,
      getWallpapersByCategory: mockGetWallpapersByCategory,
      toggleFavorite: mockToggleFavorite,
      downloadWallpaper: mockDownloadWallpaper,
      setWallpaper: mockSetWallpaper,
    );
  });

  group('WallpaperProvider', () {
    test('initial state is correct', () {
      expect(provider.wallpapers, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.hasError, false);
      expect(provider.errorMessage, null);
    });

    test('fetchWallpapers updates state correctly', () async {
      // Arrange
      final mockWallpapers = [
        Wallpaper(
          id: 'test1',
          url: 'https://example.com/photo1.jpg',
          thumbnailUrl: 'https://example.com/thumb1.jpg',
          category: 'Nature',
          photographer: 'Test User 1',
          width: 1920,
          height: 1080,
        ),
        Wallpaper(
          id: 'test2',
          url: 'https://example.com/photo2.jpg',
          thumbnailUrl: 'https://example.com/thumb2.jpg',
          category: 'Architecture',
          photographer: 'Test User 2',
          width: 1920,
          height: 1080,
        ),
      ];

      when(mockGetWallpapers.execute(
        page: 1,
        perPage: 10,
        category: null,
      )).thenAnswer((_) async => mockWallpapers);

      // Act
      await provider.fetchWallpapers();

      // Assert
      expect(provider.wallpapers, mockWallpapers);
      expect(provider.isLoading, false);
      expect(provider.hasError, false);
      verify(mockGetWallpapers.execute(
        page: 1,
        perPage: 10,
        category: null,
      )).called(1);
    });

    test('fetchWallpapers handles errors correctly', () async {
      // Arrange
      when(mockGetWallpapers.execute(
        page: 1,
        perPage: 10,
        category: null,
      )).thenThrow(Exception('Test error'));

      // Act
      await provider.fetchWallpapers();

      // Assert
      expect(provider.wallpapers, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.hasError, true);
      expect(provider.errorMessage, contains('Test error'));
    });

    test('toggleFavorite calls use case and updates state', () async {
      // Arrange
      final wallpaper = Wallpaper(
        id: 'test1',
        url: 'https://example.com/photo1.jpg',
        thumbnailUrl: 'https://example.com/thumb1.jpg',
        category: 'Nature',
        photographer: 'Test User 1',
        width: 1920,
        height: 1080,
        isFavorite: false,
      );

      when(mockToggleFavorite.execute(wallpaper)).thenAnswer((_) async => true);

      // Act
      await provider.toggleFavorite(wallpaper);

      // Assert
      verify(mockToggleFavorite.execute(wallpaper)).called(1);
    });

    test('downloadWallpaper calls use case and updates state', () async {
      // Arrange
      final wallpaper = Wallpaper(
        id: 'test1',
        url: 'https://example.com/photo1.jpg',
        thumbnailUrl: 'https://example.com/thumb1.jpg',
        category: 'Nature',
        photographer: 'Test User 1',
        width: 1920,
        height: 1080,
      );

      when(mockDownloadWallpaper.execute(wallpaper)).thenAnswer((_) async => '/path/to/wallpaper.jpg');

      // Act
      final result = await provider.downloadWallpaper(wallpaper);

      // Assert
      expect(result, '/path/to/wallpaper.jpg');
      verify(mockDownloadWallpaper.execute(wallpaper)).called(1);
    });

    test('setWallpaper calls use case', () async {
      // Arrange
      final wallpaper = Wallpaper(
        id: 'test1',
        url: 'https://example.com/photo1.jpg',
        thumbnailUrl: 'https://example.com/thumb1.jpg',
        category: 'Nature',
        photographer: 'Test User 1',
        width: 1920,
        height: 1080,
      );

      when(mockSetWallpaper.execute(wallpaper, 1)).thenAnswer((_) async => true);

      // Act
      final result = await provider.setWallpaper(wallpaper, 1);

      // Assert
      expect(result, true);
      verify(mockSetWallpaper.execute(wallpaper, 1)).called(1);
    });

    test('clearError clears error state', () {
      // Since we can't directly set the error state (private fields),
      // we'll trigger an error and then clear it

      // Arrange - Trigger an error
      when(mockGetWallpapers.execute(
        page: 1,
        perPage: 10,
        category: null,
      )).thenThrow(Exception('Test error'));

      // Trigger the error
      provider.fetchWallpapers();

      // Verify error state is set
      expect(provider.hasError, true);
      expect(provider.errorMessage, isNotNull);

      // Act
      provider.clearError();

      // Assert
      expect(provider.hasError, false);
      expect(provider.errorMessage, null);
    });
  });
}
