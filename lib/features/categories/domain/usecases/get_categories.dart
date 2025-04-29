import '../entities/category.dart';
import '../../../wallpapers/domain/repositories/wallpaper_repository.dart';

/// Use case for getting categories
class GetCategories {
  /// Repository for wallpapers
  final WallpaperRepository _repository;

  /// Constructor
  GetCategories(this._repository);

  /// Execute the use case
  Future<List<Category>> execute() {
    return _repository.getCategories();
  }
}
