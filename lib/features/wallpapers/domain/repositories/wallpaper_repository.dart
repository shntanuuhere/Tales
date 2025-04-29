import '../entities/wallpaper.dart';
import '../../../../features/categories/domain/entities/category.dart';

/// Interface for wallpaper repository
abstract class WallpaperRepository {
  /// Get a list of wallpapers
  /// [page] - Page number to retrieve
  /// [perPage] - Number of items per page
  /// [category] - Category to filter by (optional)
  Future<List<Wallpaper>> getWallpapers({
    required int page,
    required int perPage,
    String? category,
  });

  /// Get a list of categories
  Future<List<Category>> getCategories();

  /// Get wallpapers by category
  /// [category] - Category to filter by
  /// [page] - Page number to retrieve
  /// [perPage] - Number of items per page
  Future<List<Wallpaper>> getWallpapersByCategory({
    required String category,
    required int page,
    required int perPage,
  });

  /// Search for wallpapers
  /// [query] - Search query
  /// [page] - Page number to retrieve
  /// [perPage] - Number of items per page
  Future<List<Wallpaper>> searchWallpapers({
    required String query,
    required int page,
    required int perPage,
  });

  /// Get favorite wallpapers
  Future<List<Wallpaper>> getFavoriteWallpapers();

  /// Toggle favorite status for a wallpaper
  Future<bool> toggleFavorite(Wallpaper wallpaper);

  /// Check if a wallpaper is a favorite
  Future<bool> isFavorite(String wallpaperId);

  /// Download a wallpaper
  /// Returns the local file path
  Future<String?> downloadWallpaper(Wallpaper wallpaper);

  /// Check if a wallpaper is downloaded
  Future<bool> isDownloaded(String wallpaperId);

  /// Get the local path for a downloaded wallpaper
  Future<String?> getDownloadedWallpaperPath(String wallpaperId);

  /// Set a wallpaper as the device wallpaper
  /// [wallpaper] - Wallpaper to set
  /// [location] - Where to set the wallpaper (1 = home screen, 2 = lock screen, 3 = both)
  Future<bool> setWallpaper(Wallpaper wallpaper, int location);

  /// Dispose of resources
  void dispose();
}
