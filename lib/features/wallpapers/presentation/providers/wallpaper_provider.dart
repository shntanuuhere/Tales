import 'package:flutter/foundation.dart';

import '../../domain/entities/wallpaper.dart';
import '../../domain/usecases/get_wallpapers.dart';
import '../../../categories/domain/usecases/get_wallpapers_by_category.dart';
import '../../domain/usecases/toggle_favorite.dart';
import '../../domain/usecases/download_wallpaper.dart';
import '../../domain/usecases/set_wallpaper.dart';
import '../../../../core/utils/performance/performance_monitor.dart';
import '../../../../core/utils/error/error_handler.dart';
import '../../../../core/network/offline_manager.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../di/service_locator.dart';

/// Provider for wallpapers
class WallpaperProvider extends ChangeNotifier {
  /// Use case for getting wallpapers
  final GetWallpapers _getWallpapers;

  /// Use case for getting wallpapers by category
  final GetWallpapersByCategory _getWallpapersByCategory;

  /// Use case for toggling favorite status
  final ToggleFavorite _toggleFavorite;

  /// Use case for downloading a wallpaper
  final DownloadWallpaper _downloadWallpaper;

  /// Use case for setting a wallpaper
  final SetWallpaper _setWallpaper;

  /// List of wallpapers
  List<Wallpaper> _wallpapers = [];

  /// Whether the provider is loading
  bool _isLoading = false;

  /// Whether the provider is loading more
  bool _isLoadingMore = false;

  /// Whether there are more wallpapers to load
  bool _hasMoreWallpapers = true;

  /// Current page
  int _page = 1;

  /// Current category
  String _selectedCategory = 'All';

  /// Error message
  String? _errorMessage;

  /// Whether there is an error
  bool _hasError = false;

  /// Map of download progress
  final Map<String, bool> _downloadProgress = {};

  /// Offline manager
  final OfflineManager _offlineManager = OfflineManager();

  /// Connectivity service
  late final ConnectivityService _connectivityService;

  /// Whether the app is in offline mode
  bool _isOfflineMode = false;

  /// Constructor
  WallpaperProvider({
    required GetWallpapers getWallpapers,
    required GetWallpapersByCategory getWallpapersByCategory,
    required ToggleFavorite toggleFavorite,
    required DownloadWallpaper downloadWallpaper,
    required SetWallpaper setWallpaper,
  }) :
    _getWallpapers = getWallpapers,
    _getWallpapersByCategory = getWallpapersByCategory,
    _toggleFavorite = toggleFavorite,
    _downloadWallpaper = downloadWallpaper,
    _setWallpaper = setWallpaper {

    // Initialize connectivity service
    _connectivityService = serviceLocator<ConnectivityService>();
    _connectivityService.addListener(_onConnectivityChanged);

    // Check if we're offline
    _isOfflineMode = !_connectivityService.isConnected;

    // Fetch wallpapers
    fetchWallpapers();
  }

  /// Handle connectivity changes
  void _onConnectivityChanged() {
    final isConnected = _connectivityService.isConnected;

    // If we're going from offline to online, refresh data
    if (isConnected && _isOfflineMode) {
      _isOfflineMode = false;
      fetchWallpapers(refresh: true);
    } else if (!isConnected && !_isOfflineMode) {
      // If we're going from online to offline, switch to offline mode
      _isOfflineMode = true;
      _loadOfflineWallpapers();
    }
  }

  /// Load wallpapers from offline storage
  Future<void> _loadOfflineWallpapers() async {
    try {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
      notifyListeners();

      List<Wallpaper> offlineWallpapers;

      // If a category is selected, load wallpapers for that category
      if (_selectedCategory != 'All') {
        offlineWallpapers = await _offlineManager.getWallpapersByCategory(_selectedCategory);
      } else {
        // Otherwise load all wallpapers
        offlineWallpapers = await _offlineManager.getWallpapers();
      }

      // If we have offline wallpapers, use them
      if (offlineWallpapers.isNotEmpty) {
        _wallpapers = offlineWallpapers;
        _isLoading = false;
        notifyListeners();
      } else {
        // If we don't have offline wallpapers, show an error
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'No offline wallpapers available. Please connect to the internet.';
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = 'Failed to load offline wallpapers: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Getters
  List<Wallpaper> get wallpapers => _wallpapers;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMoreWallpapers => _hasMoreWallpapers;
  int get page => _page;
  String get selectedCategory => _selectedCategory;
  String? get errorMessage => _errorMessage;
  bool get hasError => _hasError;
  bool get isOfflineMode => _isOfflineMode;

  /// Fetch wallpapers
  Future<void> fetchWallpapers({bool refresh = false}) async {
    // Prevent multiple simultaneous fetches
    if (refresh) {
      if (_isLoading) return;
    } else {
      if (_isLoading || _isLoadingMore) return;
    }

    // Start timing the operation
    PerformanceMonitor.startTiming('fetchWallpapers');

    try {
      if (refresh) {
        _isLoading = true;
        _page = 1;
        _hasMoreWallpapers = true;
        _wallpapers = [];
      } else {
        _isLoadingMore = true;
      }

      _hasError = false;
      _errorMessage = null;
      notifyListeners();

      // Time the API call specifically
      final newWallpapers = await PerformanceMonitor.timeAsync(
        'getWallpapers_API_call',
        () => _getWallpapers.execute(
          page: _page,
          perPage: 10,
          category: _selectedCategory == 'All' ? null : _selectedCategory,
        ),
      );

      // If we couldn't get any new wallpapers, we've reached the end
      if (newWallpapers.isEmpty) {
        _hasMoreWallpapers = false;
        _isLoading = false;
        _isLoadingMore = false;
        notifyListeners();
        return;
      }

      // Add new wallpapers to the existing list
      if (refresh) {
        _wallpapers = newWallpapers;
      } else {
        _wallpapers.addAll(newWallpapers);
      }

      // Increment page for next fetch
      _page++;

      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();

      // Save wallpapers for offline use
      if (refresh) {
        await _offlineManager.saveWallpapers(_wallpapers);
      }

      // End timing the operation
      PerformanceMonitor.endTiming('fetchWallpapers');
    } catch (e) {
      _isLoading = false;
      _isLoadingMore = false;
      _hasError = true;
      _errorMessage = ErrorHandler.handleError(e, context: 'fetchWallpapers');
      notifyListeners();

      // End timing the operation even if there's an error
      PerformanceMonitor.endTiming('fetchWallpapers');
    }
  }

  /// Change category
  Future<void> changeCategory(String category) async {
    if (_selectedCategory == category) return;

    _selectedCategory = category;
    notifyListeners();

    await fetchWallpapers(refresh: true);
  }

  /// Fetch wallpapers by category
  Future<void> fetchWallpapersByCategory(String category) async {
    if (_isLoading) return;

    // Start timing the operation
    PerformanceMonitor.startTiming('fetchWallpapersByCategory');

    try {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
      _selectedCategory = category;
      notifyListeners();

      // Time the API call specifically
      final wallpapers = await PerformanceMonitor.timeAsync(
        'getWallpapersByCategory_API_call',
        () => _getWallpapersByCategory.execute(
          category: category,
          page: 1,
          perPage: 20,
        ),
      );

      _wallpapers = wallpapers;
      _isLoading = false;
      notifyListeners();

      // Save wallpapers for offline use
      await _offlineManager.saveWallpapers(_wallpapers);

      // End timing the operation
      PerformanceMonitor.endTiming('fetchWallpapersByCategory');
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = ErrorHandler.handleError(e, context: 'fetchWallpapersByCategory');
      notifyListeners();

      // End timing the operation even if there's an error
      PerformanceMonitor.endTiming('fetchWallpapersByCategory');
    }
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(Wallpaper wallpaper) async {
    try {
      final success = await _toggleFavorite.execute(wallpaper);

      if (success) {
        // Update the wallpaper in the list
        final index = _wallpapers.indexWhere((w) => w.id == wallpaper.id);
        if (index != -1) {
          _wallpapers[index] = _wallpapers[index].copyWith(
            isFavorite: !_wallpapers[index].isFavorite,
          );
          notifyListeners();
        }
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = ErrorHandler.handleError(e, context: 'toggleFavorite');
      notifyListeners();
    }
  }

  /// Download a wallpaper
  Future<String?> downloadWallpaper(Wallpaper wallpaper) async {
    try {
      _downloadProgress[wallpaper.id] = true;
      notifyListeners();

      final path = await _downloadWallpaper.execute(wallpaper);

      _downloadProgress[wallpaper.id] = false;
      notifyListeners();

      return path;
    } catch (e) {
      _downloadProgress[wallpaper.id] = false;
      _hasError = true;
      _errorMessage = ErrorHandler.handleError(e, context: 'downloadWallpaper');
      notifyListeners();
      return null;
    }
  }

  /// Set a wallpaper
  Future<bool> setWallpaper(Wallpaper wallpaper, int location) async {
    try {
      return await _setWallpaper.execute(wallpaper, location);
    } catch (e) {
      _hasError = true;
      _errorMessage = ErrorHandler.handleError(e, context: 'setWallpaper');
      notifyListeners();
      return false;
    }
  }

  /// Check if a wallpaper is downloading
  bool isDownloading(String wallpaperId) {
    return _downloadProgress[wallpaperId] ?? false;
  }

  /// Clear error
  void clearError() {
    _hasError = false;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    // Remove connectivity listener
    _connectivityService.removeListener(_onConnectivityChanged);
    super.dispose();
  }
}
