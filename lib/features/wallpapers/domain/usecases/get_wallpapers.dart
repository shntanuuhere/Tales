import '../entities/wallpaper.dart';
import '../repositories/wallpaper_repository.dart';

/// Use case for getting wallpapers
class GetWallpapers {
  /// Repository for wallpapers
  final WallpaperRepository _repository;

  /// Constructor
  GetWallpapers(this._repository);

  /// Execute the use case
  /// [page] - Page number to retrieve
  /// [perPage] - Number of items per page
  /// [category] - Category to filter by (optional)
  Future<List<Wallpaper>> execute({
    required int page,
    required int perPage,
    String? category,
  }) {
    return _repository.getWallpapers(
      page: page,
      perPage: perPage,
      category: category,
    );
  }
}
