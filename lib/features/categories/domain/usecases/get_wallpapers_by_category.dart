import '../../../wallpapers/domain/entities/wallpaper.dart';
import '../../../wallpapers/domain/repositories/wallpaper_repository.dart';

/// Use case for getting wallpapers by category
class GetWallpapersByCategory {
  /// Repository for wallpapers
  final WallpaperRepository _repository;

  /// Constructor
  GetWallpapersByCategory(this._repository);

  /// Execute the use case
  /// [category] - Category to filter by
  /// [page] - Page number to retrieve (optional)
  /// [perPage] - Number of items per page (optional)
  Future<List<Wallpaper>> execute({
    required String category,
    int page = 1,
    int perPage = 10,
  }) {
    return _repository.getWallpapersByCategory(
      category: category,
      page: page,
      perPage: perPage,
    );
  }
}
