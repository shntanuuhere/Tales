import '../entities/wallpaper.dart';
import '../repositories/wallpaper_repository.dart';

/// Use case for downloading a wallpaper
class DownloadWallpaper {
  /// Repository for wallpapers
  final WallpaperRepository _repository;

  /// Constructor
  DownloadWallpaper(this._repository);

  /// Execute the use case
  /// [wallpaper] - Wallpaper to download
  Future<String?> execute(Wallpaper wallpaper) {
    return _repository.downloadWallpaper(wallpaper);
  }
}
