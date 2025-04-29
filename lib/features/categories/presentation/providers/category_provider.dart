import 'package:flutter/foundation.dart' hide Category;

import '../../domain/entities/category.dart';
import '../../domain/usecases/get_categories.dart';
import '../../../../core/network/offline_manager.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../di/service_locator.dart';

/// Provider for categories
class CategoryProvider extends ChangeNotifier {
  /// Use case for getting categories
  final GetCategories _getCategories;

  /// List of categories
  List<Category> _categories = [];

  /// Whether the provider is loading
  bool _isLoading = false;

  /// Error message
  String? _errorMessage;

  /// Whether there is an error
  bool _hasError = false;

  /// Offline manager
  final OfflineManager _offlineManager = OfflineManager();

  /// Connectivity service
  late final ConnectivityService _connectivityService;

  /// Whether the app is in offline mode
  bool _isOfflineMode = false;

  /// Constructor
  CategoryProvider({
    required GetCategories getCategories,
  }) : _getCategories = getCategories {
    // Initialize connectivity service
    _connectivityService = serviceLocator<ConnectivityService>();
    _connectivityService.addListener(_onConnectivityChanged);

    // Check if we're offline
    _isOfflineMode = !_connectivityService.isConnected;

    fetchCategories();
  }

  /// Handle connectivity changes
  void _onConnectivityChanged() {
    final isConnected = _connectivityService.isConnected;

    // If we're going from offline to online, refresh data
    if (isConnected && _isOfflineMode) {
      _isOfflineMode = false;
      fetchCategories();
    } else if (!isConnected && !_isOfflineMode) {
      // If we're going from online to offline, switch to offline mode
      _isOfflineMode = true;
      _loadOfflineCategories();
    }
  }

  /// Load categories from offline storage
  Future<void> _loadOfflineCategories() async {
    try {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
      notifyListeners();

      // Get categories from offline storage
      final offlineCategories = await _offlineManager.getCategories();

      // If we have offline categories, use them
      if (offlineCategories.isNotEmpty) {
        // Add "All" category at the beginning if it doesn't exist
        if (!offlineCategories.any((category) => category.id == 'all')) {
          _categories = [
            const Category(
              id: 'all',
              name: 'All',
              thumbnailUrl: '',
            ),
            ...offlineCategories,
          ];
        } else {
          _categories = List<Category>.from(offlineCategories);
        }

        _isLoading = false;
        notifyListeners();
      } else {
        // If we don't have offline categories, fall back to predefined categories
        _isLoading = false;
        _categories = [
          const Category(
            id: 'all',
            name: 'All',
            thumbnailUrl: '',
          ),
          ...Category.getPredefinedCategories(),
        ];
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = 'Failed to load offline categories: ${e.toString()}';

      // Fall back to predefined categories
      _categories = [
        const Category(
          id: 'all',
          name: 'All',
          thumbnailUrl: '',
        ),
        ...Category.getPredefinedCategories(),
      ];

      notifyListeners();
    }
  }

  /// Getters
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _hasError;
  bool get isOfflineMode => _isOfflineMode;

  /// Fetch categories
  Future<void> fetchCategories() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
      notifyListeners();

      final categories = await _getCategories.execute();

      // Add "All" category at the beginning if it doesn't exist
      if (!categories.any((category) => category.id == 'all')) {
        _categories = [
          const Category(
            id: 'all',
            name: 'All',
            thumbnailUrl: '',
          ),
          ...categories,
        ];
      } else {
        _categories = categories;
      }

      _isLoading = false;
      notifyListeners();

      // Save categories for offline use
      await _offlineManager.saveCategories(_categories);
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = 'Failed to load categories: ${e.toString()}';

      // Fall back to predefined categories
      _categories = [
        const Category(
          id: 'all',
          name: 'All',
          thumbnailUrl: '',
        ),
        ...Category.getPredefinedCategories(),
      ];

      notifyListeners();
    }
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
