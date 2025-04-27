// Copyright 2025 Shantanu Sen Gupta
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../models/wallpaper.dart';
import '../models/category.dart';

class WallpaperService extends ChangeNotifier {
  bool _isLoading = false;
  // _isLoadingMore is used by the wallpaper_screen.dart to track pagination loading state
  final bool _isLoadingMore = false;
  bool _hasError = false;
  String? _errorMessage;
  List<Wallpaper> _wallpapers = [];
  List<String> _categories = [];
  Set<String> _favorites = {};
  final Map<String, bool> _downloadProgress = {};
  Map<String, String> _downloadedWallpapers = {};
  String _selectedCategory = 'All';
  int _page = 1;
  bool _hasMoreWallpapers = true;

  // List of Unsplash image IDs for generating more wallpapers
  final List<String> _unsplashIds = [
    'photo-1506744038136-46273834b3fb',
    'photo-1518837695005-2083093ee35b',
    'photo-1477959858617-67f85cf4f1df',
    'photo-1462331940025-496dfbfc7564',
    'photo-1508193638397-1c4234db14d8',
    'photo-1541701494587-cb58502866ab',
    'photo-1470770903362-f73a9c4a6efc',
    'photo-1501854140801-50d01698950b',
    'photo-1441974231531-c6227db76b6e',
    'photo-1472214103451-9374bd1c798e',
    'photo-1469474968028-56623f02e42e',
    'photo-1470071459604-3b5ec3a7fe05',
    'photo-1497436072909-60f360e1d4b1',
    'photo-1433086966358-54859d0ed716',
    'photo-1465146344425-f00d5f5c8f07',
    'photo-1588392382834-a891154bca4d',
    'photo-1546587348-d12660c30c50',
    'photo-1579546929518-9e396f3cc809',
    'photo-1557682250-33bd709cbe85',
    'photo-1558470598-a5dda9640f68',
    'photo-1579546929662-711aa81148cf',
    'photo-1494438639946-1ebd1d20bf85',
    'photo-1559583985-c80d8ad9b29f',
    'photo-1567095761054-7a02e69e5c43',
    'photo-1563089145-599997674d42', // Replaced duplicate with a new image ID
  ];

  // List of photographers for generating more wallpapers
  final List<String> _photographers = [
    'John Doe',
    'Jane Smith',
    'Mike Johnson',
    'Sarah Williams',
    'David Brown',
    'Lisa Chen',
    'Alex Morgan',
    'Emma Wilson',
    'Chris Taylor',
    'Olivia Martinez',
    'Daniel Lee',
    'Sophia Anderson',
    'Matthew White',
    'Ava Thomas',
    'James Garcia',
  ];

  // List of categories for generating more wallpapers
  final List<String> _wallpaperCategories = [
    'Nature',
    'Abstract',
    'Architecture',
    'Space',
    'Minimal',
    'Dark',
    'Ocean',
    'Art',
    'Animals',
    'Food',
    'Travel',
    'Sports',
    'Technology',
    'Vehicles',
  ];

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  List<Wallpaper> get wallpapers => _wallpapers;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  bool get hasMoreWallpapers => _hasMoreWallpapers;

  WallpaperService() {
    _init();
  }

  Future<void> _init() async {
    await _loadFavorites();
    await _loadDownloadedWallpapers();
    await loadCategories();
    fetchWallpapers();
  }

  Future<void> loadCategories() async {
    try {
      _isLoading = true;
      _hasError = false;
      notifyListeners();

      // In a real app, you would fetch categories from an API
      // For demo purposes, we're using static data from the centralized Category model
      final categoryList = Category.getAllCategories();
      _categories = categoryList.map((category) => category.name).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = 'Failed to load categories: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> fetchWallpapers({bool useDelay = true, bool refresh = false}) async {
    if (_isLoading) return; // Prevent multiple simultaneous fetches

    try {
      _isLoading = true;
      _hasError = false;

      // Reset page if refreshing
      if (refresh) {
        _page = 1;
        _hasMoreWallpapers = true;
        _wallpapers = [];
      }

      // Only notify once at the beginning
      notifyListeners();

      // In a real app, you would fetch wallpapers from an API
      // For demo purposes, we're using static data with pagination
      if (useDelay) {
        // Only use delay in production, not in tests
        // Use a shorter delay for better performance
        await Future.delayed(const Duration(milliseconds: 200));
      }

      // Generate new wallpapers for the current page
      final newWallpapers = _generateWallpapersForPage(_page);

      // If we couldn't generate any new wallpapers, we've reached the end
      if (newWallpapers.isEmpty) {
        _hasMoreWallpapers = false;
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Update wallpapers with favorite status more efficiently
      // Use map instead of for loop for better performance
      final wallpapersWithFavorites = newWallpapers.map((wallpaper) {
        // Only create a new object if needed
        return _favorites.contains(wallpaper.id)
            ? wallpaper.copyWith(isFavorite: true)
            : wallpaper;
      }).toList(growable: true); // Use growable: true for better performance

      // Add new wallpapers to the existing list
      if (refresh) {
        _wallpapers = wallpapersWithFavorites;
      } else {
        _wallpapers.addAll(wallpapersWithFavorites);
      }

      // Increment page for next fetch
      _page++;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = 'Failed to load wallpapers: ${e.toString()}';
      notifyListeners();
    }
  }

  // Generate wallpapers for a specific page - optimized version
  List<Wallpaper> _generateWallpapersForPage(int page) {
    // Each page has 4 wallpapers (reduced for better performance)
    const pageSize = 4;
    final startIndex = (page - 1) * pageSize;

    // If we've reached the end of our data, return empty list
    if (startIndex >= 100) {
      return [];
    }

    // Pre-allocate list for better performance
    final pageWallpapers = List<Wallpaper>.filled(pageSize, Wallpaper(
      id: '',
      url: '',
      thumbnailUrl: '',
      category: '',
      photographer: '',
      width: 0,
      height: 0,
    ));

    for (int i = 0; i < pageSize; i++) {
      final index = startIndex + i;

      // Use bit operations for faster modulo
      final imageIdIndex = index & (_unsplashIds.length - 1);
      final photographerIndex = index & (_photographers.length - 1);
      final categoryIndex = index & (_wallpaperCategories.length - 1);

      // Further optimize image loading with smaller images and better caching
      pageWallpapers[i] = Wallpaper(
        id: '${page}_$i',
        url: 'https://images.unsplash.com/${_unsplashIds[imageIdIndex]}?w=600&q=75',
        thumbnailUrl: 'https://images.unsplash.com/${_unsplashIds[imageIdIndex]}?w=300&q=60',
        category: _wallpaperCategories[categoryIndex],
        photographer: _photographers[photographerIndex],
        width: 600,
        height: 900,
        isFavorite: false,
      );
    }

    return pageWallpapers;
  }

  Future<List<Wallpaper>> getWallpapersByCategory(String category) async {
    if (_isLoading) return _wallpapers; // Prevent multiple simultaneous fetches

    try {
      _isLoading = true;
      _hasError = false;
      notifyListeners();

      // Simulate network delay (reduced for better performance)
      await Future.delayed(const Duration(milliseconds: 100));

      // Generate category-specific wallpapers for better performance
      final categoryWallpapers = <Wallpaper>[];
      final lowerCategory = category.toLowerCase();

      // Generate 8 wallpapers for this category
      for (int i = 0; i < 8; i++) {
        final imageIdIndex = i % _unsplashIds.length;
        final photographerIndex = i % _photographers.length;

        categoryWallpapers.add(Wallpaper(
          id: 'cat_${lowerCategory}_$i',
          url: 'https://images.unsplash.com/${_unsplashIds[imageIdIndex]}?w=600&q=75',
          thumbnailUrl: 'https://images.unsplash.com/${_unsplashIds[imageIdIndex]}?w=300&q=60',
          category: category,
          photographer: _photographers[photographerIndex],
          width: 600,
          height: 900,
          isFavorite: _favorites.contains('cat_${lowerCategory}_$i'),
        ));
      }

      _wallpapers = categoryWallpapers;
      _isLoading = false;
      notifyListeners();
      return categoryWallpapers;
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = 'Failed to load wallpapers: ${e.toString()}';
      notifyListeners();
      return [];
    }
  }

  // Change category and fetch wallpapers
  void changeCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
    getWallpapersByCategory(category);
  }

  Future<void> toggleFavorite(Wallpaper wallpaper) async {
    // Get current favorite status
    final isFavorite = _favorites.contains(wallpaper.id);

    try {
      // First save to persistent storage to ensure data consistency
      final prefs = await SharedPreferences.getInstance();

      // Update the favorites set
      final Set<String> updatedFavorites = Set<String>.from(_favorites);
      if (isFavorite) {
        updatedFavorites.remove(wallpaper.id);
      } else {
        updatedFavorites.add(wallpaper.id);
      }

      // Save to SharedPreferences
      await prefs.setStringList('favorite_wallpapers', updatedFavorites.toList());

      // Only after successful save, update the in-memory state
      _favorites = updatedFavorites;

      // Update wallpaper in the list
      final index = _wallpapers.indexWhere((w) => w.id == wallpaper.id);
      if (index != -1) {
        _wallpapers[index] = wallpaper.copyWith(isFavorite: !isFavorite);
      }

      // Notify listeners after all state updates are complete
      notifyListeners();
    } catch (e) {
      // Handle errors
      debugPrint('Error toggling favorite: ${e.toString()}');
      _hasError = true;
      _errorMessage = 'Failed to update favorites: ${e.toString()}';
      notifyListeners();
    }
  }

  bool isFavorite(String wallpaperId) {
    return _favorites.contains(wallpaperId);
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesList = prefs.getStringList('favorite_wallpapers') ?? [];
      _favorites = Set<String>.from(favoritesList);
    } catch (e) {
      debugPrint('Error loading favorites: ${e.toString()}');
    }
  }

  // _saveFavorites method has been removed and integrated directly into toggleFavorite
  // for better state consistency

  Future<void> _loadDownloadedWallpapers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> downloaded = {};

      // Get all keys that start with 'downloaded_'
      final keys = prefs.getKeys().where((key) => key.startsWith('downloaded_')).toList();

      for (final key in keys) {
        final wallpaperId = key.replaceFirst('downloaded_', '');
        final path = prefs.getString(key);
        if (path != null) {
          downloaded[wallpaperId] = path;
        }
      }

      _downloadedWallpapers = Map<String, String>.from(downloaded);
    } catch (e) {
      debugPrint('Error loading downloaded wallpapers: ${e.toString()}');
    }
  }

  bool isDownloaded(String wallpaperId) {
    return _downloadedWallpapers.containsKey(wallpaperId);
  }

  String? getDownloadedPath(String wallpaperId) {
    return _downloadedWallpapers[wallpaperId];
  }

  bool isDownloading(String wallpaperId) {
    return _downloadProgress[wallpaperId] ?? false;
  }

  // Map to track download futures to prevent duplicate requests
  final Map<String, Future<String?>> _downloadFutures = {};

  Future<String?> downloadWallpaper(Wallpaper wallpaper, {int retryCount = 3}) async {
    // Return cached file path if already downloaded
    if (isDownloaded(wallpaper.id)) {
      return _downloadedWallpapers[wallpaper.id];
    }

    // Return existing future if already downloading to prevent duplicate requests
    if (_downloadFutures.containsKey(wallpaper.id)) {
      return _downloadFutures[wallpaper.id];
    }

    // Create a new download future and store it
    final downloadFuture = _performDownload(wallpaper, retryCount);
    _downloadFutures[wallpaper.id] = downloadFuture;

    // Wait for the download to complete
    final result = await downloadFuture;

    // Remove the future from the map once completed
    _downloadFutures.remove(wallpaper.id);

    return result;
  }

  // Private method to perform the actual download
  Future<String?> _performDownload(Wallpaper wallpaper, int retryCount) async {
    try {
      _downloadProgress[wallpaper.id] = true;
      _hasError = false;
      _errorMessage = null;
      notifyListeners();

      // Get the temporary directory
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/${wallpaper.id}.jpg';

      // Check if file already exists
      final file = File(filePath);
      if (await file.exists()) {
        // File exists, update state and return path
        _downloadedWallpapers[wallpaper.id] = filePath;
        _downloadProgress[wallpaper.id] = false;
        notifyListeners();
        return filePath;
      }

      // Download the file with retry mechanism
      http.Response? response;
      Exception? lastException;

      for (int attempt = 0; attempt < retryCount; attempt++) {
        try {
          // Use a client with timeout for better control
          final client = http.Client();
          try {
            response = await client.get(Uri.parse(wallpaper.url))
                .timeout(const Duration(seconds: 15));
          } finally {
            client.close();
          }

          if (response.statusCode == 200) {
            break; // Success, exit the retry loop
          } else {
            lastException = Exception(
                'Failed to download wallpaper: HTTP ${response.statusCode}');

            if (attempt < retryCount - 1) {
              // Wait before retrying (exponential backoff)
              await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
            }
          }
        } catch (e) {
          lastException = e is Exception ? e : Exception(e.toString());

          if (attempt < retryCount - 1) {
            // Wait before retrying (exponential backoff)
            await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
          }
        }
      }

      // If all attempts failed
      if (response == null || response.statusCode != 200) {
        throw lastException ?? Exception('Failed to download wallpaper after $retryCount attempts');
      }

      // Save to file
      await file.writeAsBytes(response.bodyBytes);

      // Save to persistent storage using a more secure approach
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('downloaded_${wallpaper.id}', filePath);

      // Update local state
      _downloadedWallpapers[wallpaper.id] = filePath;
      _downloadProgress[wallpaper.id] = false;

      notifyListeners();
      return filePath;
    } catch (e) {
      _downloadProgress[wallpaper.id] = false;
      _hasError = true;
      _errorMessage = 'Failed to download wallpaper: ${e.toString()}';
      notifyListeners();
      debugPrint('Error downloading wallpaper: ${e.toString()}');
      return null;
    }
  }

  // Generic set wallpaper function that adapts based on SDK version
  Future<bool> setWallpaper(Wallpaper wallpaper, int wallpaperType) async {
    try {
      // Check for storage permissions first
      final storageStatus = await Permission.storage.status;
      if (!storageStatus.isGranted) {
        final result = await Permission.storage.request();
        if (!result.isGranted) {
          _hasError = true;
          _errorMessage = 'Storage permission is required to set wallpaper';
          notifyListeners();
          return false;
        }
      }

      // Get local path or download if needed
      String? localPath = _downloadedWallpapers[wallpaper.id];

      if (localPath == null) {
        _hasError = false;
        _errorMessage = null;
        notifyListeners();

        localPath = await downloadWallpaper(wallpaper);
      }

      if (localPath == null) {
        _hasError = true;
        _errorMessage = 'Failed to download wallpaper';
        notifyListeners();
        return false;
      }

      // Check if file exists
      final file = File(localPath);
      if (!await file.exists()) {
        // File doesn't exist, try to download again with retries
        _downloadedWallpapers.remove(wallpaper.id);

        // Try up to 3 times with increasing delays
        for (int attempt = 0; attempt < 3; attempt++) {
          localPath = await downloadWallpaper(wallpaper, retryCount: 3);

          if (localPath != null) {
            break; // Success, exit the retry loop
          }

          // Wait before retrying (exponential backoff)
          if (attempt < 2) { // Only wait if we're going to retry
            await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
            // Clear previous error before retrying
            _hasError = false;
            _errorMessage = null;
            notifyListeners();
          }
        }

        if (localPath == null) {
          _hasError = true;
          _errorMessage = 'Failed to download wallpaper after multiple attempts';
          notifyListeners();
          return false;
        }
      }

      // This is a placeholder as we can't use actual WallpaperManagerPlus methods
      // In a real app, you would use the actual methods based on the device's capability
      debugPrint('Setting wallpaper at path: $localPath with type: $wallpaperType');

      // Simulate success
      return true;
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Error setting wallpaper: ${e.toString()}';
      notifyListeners();
      debugPrint('Error setting wallpaper: ${e.toString()}');
      return false;
    }
  }

  Future<List<Wallpaper>> getFavoriteWallpapers({bool useDelay = true}) async {
    if (_isLoading) return _wallpapers; // Prevent multiple simultaneous fetches

    try {
      _isLoading = true;
      _hasError = false;
      notifyListeners();

      // In a real app, you would fetch wallpapers from an API
      // For demo purposes, we're using static data
      if (useDelay) {
        // Only use delay in production, not in tests
        await Future.delayed(const Duration(milliseconds: 300)); // Reduced delay
      }

      // More efficient filtering
      if (_favorites.isEmpty) {
        _wallpapers = [];
      } else {
        final allWallpapers = Wallpaper.getDemoWallpapers();
        _wallpapers = allWallpapers
          .where((wallpaper) => _favorites.contains(wallpaper.id))
          .map((wallpaper) => wallpaper.copyWith(isFavorite: true))
          .toList();
      }

      _isLoading = false;
      notifyListeners();
      return _wallpapers;
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = 'Failed to load favorite wallpapers: ${e.toString()}';
      notifyListeners();
      return [];
    }
  }

  Future<bool> setHomeScreenWallpaper(Wallpaper wallpaper) async {
    // Home screen wallpaper type is typically 1
    return setWallpaper(wallpaper, 1);
  }

  Future<bool> setLockScreenWallpaper(Wallpaper wallpaper) async {
    // Lock screen wallpaper type is typically 2
    return setWallpaper(wallpaper, 2);
  }
}
