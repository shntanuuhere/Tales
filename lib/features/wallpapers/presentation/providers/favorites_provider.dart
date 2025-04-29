import 'package:flutter/foundation.dart';

import '../../domain/entities/wallpaper.dart';
import '../../domain/usecases/get_favorite_wallpapers.dart';
import '../../domain/usecases/toggle_favorite.dart';

/// Provider for favorites
class FavoritesProvider extends ChangeNotifier {
  /// Use case for getting favorite wallpapers
  final GetFavoriteWallpapers _getFavoriteWallpapers;

  /// Use case for toggling favorite status
  final ToggleFavorite _toggleFavorite;

  /// List of favorite wallpapers
  List<Wallpaper> _favorites = [];

  /// Whether the provider is loading
  bool _isLoading = false;

  /// Error message
  String? _errorMessage;

  /// Whether there is an error
  bool _hasError = false;

  /// Constructor
  FavoritesProvider({
    required GetFavoriteWallpapers getFavoriteWallpapers,
    required ToggleFavorite toggleFavorite,
  }) :
    _getFavoriteWallpapers = getFavoriteWallpapers,
    _toggleFavorite = toggleFavorite {
    loadFavorites();
  }

  /// Load favorites (alias for fetchFavorites for consistency with other providers)
  Future<void> loadFavorites() async {
    return fetchFavorites();
  }

  /// Getters
  List<Wallpaper> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _hasError;

  /// Fetch favorites
  Future<void> fetchFavorites() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
      notifyListeners();

      final favorites = await _getFavoriteWallpapers.execute();

      _favorites = favorites;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = 'Failed to load favorites: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(Wallpaper wallpaper) async {
    try {
      final success = await _toggleFavorite.execute(wallpaper);

      if (success) {
        // If the wallpaper is in the favorites list, remove it
        if (_favorites.any((w) => w.id == wallpaper.id)) {
          _favorites.removeWhere((w) => w.id == wallpaper.id);
        } else {
          // Otherwise, add it
          _favorites.add(wallpaper.copyWith(isFavorite: true));
        }

        notifyListeners();
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Failed to toggle favorite: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _hasError = false;
    _errorMessage = null;
    notifyListeners();
  }
}
