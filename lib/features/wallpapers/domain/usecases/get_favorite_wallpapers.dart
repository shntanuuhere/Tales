import '../entities/wallpaper.dart';
import '../repositories/wallpaper_repository.dart';

/// Use case for getting favorite wallpapers
class GetFavoriteWallpapers {
  /// Repository for wallpapers
  final WallpaperRepository _repository;

  /// Constructor
  GetFavoriteWallpapers(this._repository);

  /// Execute the use case
  Future<List<Wallpaper>> execute() {
    return _repository.getFavoriteWallpapers();
  }
}
