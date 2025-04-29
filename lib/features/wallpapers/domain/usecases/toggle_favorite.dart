import '../entities/wallpaper.dart';
import '../repositories/wallpaper_repository.dart';

/// Use case for toggling favorite status
class ToggleFavorite {
  /// Repository for wallpapers
  final WallpaperRepository _repository;

  /// Constructor
  ToggleFavorite(this._repository);

  /// Execute the use case
  /// [wallpaper] - Wallpaper to toggle favorite status for
  Future<bool> execute(Wallpaper wallpaper) {
    return _repository.toggleFavorite(wallpaper);
  }
}
