import '../entities/wallpaper.dart';
import '../repositories/wallpaper_repository.dart';

/// Use case for setting a wallpaper
class SetWallpaper {
  /// Repository for wallpapers
  final WallpaperRepository _repository;

  /// Constructor
  SetWallpaper(this._repository);

  /// Execute the use case
  /// [wallpaper] - Wallpaper to set
  /// [location] - Where to set the wallpaper (1 = home screen, 2 = lock screen, 3 = both)
  Future<bool> execute(Wallpaper wallpaper, int location) {
    return _repository.setWallpaper(wallpaper, location);
  }
}
