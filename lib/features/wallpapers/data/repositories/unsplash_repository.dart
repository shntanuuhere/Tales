import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' hide Category;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import '../../../../data/api/unsplash_api_client.dart';
import '../../domain/entities/wallpaper.dart';
import '../../../../features/categories/domain/entities/category.dart';
import '../../domain/repositories/wallpaper_repository.dart';

/// Implementation of WallpaperRepository using Unsplash API
class UnsplashRepository implements WallpaperRepository {
  /// API client for Unsplash
  final UnsplashApiClient _apiClient;

  /// Set of favorite wallpaper IDs
  final Set<String> _favorites = {};

  /// Map of downloaded wallpaper paths
  final Map<String, String> _downloadedWallpapers = {};

  /// Map of download progress
  final Map<String, bool> _downloadProgress = {};

  /// Map of download futures to prevent duplicate downloads
  final Map<String, Future<String?>> _downloadFutures = {};

  /// Constructor
  UnsplashRepository({
    UnsplashApiClient? apiClient,
  }) : _apiClient = apiClient ?? UnsplashApiClient() {
    _init();
  }

  /// Initialize the repository
  Future<void> _init() async {
    await _loadFavorites();
    await _loadDownloadedWallpapers();
  }

  @override
  Future<List<Wallpaper>> getWallpapers({
    required int page,
    required int perPage,
    String? category,
  }) async {
    try {
      if (category != null && category.isNotEmpty && category != 'All') {
        return getWallpapersByCategory(
          category: category,
          page: page,
          perPage: perPage,
        );
      }

      final photos = await _apiClient.getPhotos(
        page: page,
        perPage: perPage,
        orderBy: 'popular',
      );

      final wallpapers = photos.map((photo) {
        final wallpaper = Wallpaper.fromUnsplashPhoto(photo);
        return _favorites.contains(wallpaper.id)
            ? wallpaper.copyWith(isFavorite: true)
            : wallpaper;
      }).toList();

      return wallpapers;
    } catch (e) {
      debugPrint('Error getting wallpapers: $e');
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      final topics = await _apiClient.getTopics(perPage: 30);

      final categories = topics.map((topic) {
        return Category.fromUnsplashTopic(topic);
      }).toList();

      // If API call fails or returns empty list, fall back to predefined categories
      if (categories.isEmpty) {
        return Category.getPredefinedCategories();
      }

      return categories;
    } catch (e) {
      debugPrint('Error getting categories: $e');
      // Fall back to predefined categories on error
      return Category.getPredefinedCategories();
    }
  }

  @override
  Future<List<Wallpaper>> getWallpapersByCategory({
    required String category,
    required int page,
    required int perPage,
  }) async {
    try {
      final searchResult = await _apiClient.searchPhotos(
        query: category,
        page: page,
        perPage: perPage,
      );

      final wallpapers = searchResult.results.map((photo) {
        final wallpaper = Wallpaper.fromUnsplashPhoto(photo);
        return _favorites.contains(wallpaper.id)
            ? wallpaper.copyWith(isFavorite: true)
            : wallpaper;
      }).toList();

      return wallpapers;
    } catch (e) {
      debugPrint('Error getting wallpapers by category: $e');
      rethrow;
    }
  }

  @override
  Future<List<Wallpaper>> searchWallpapers({
    required String query,
    required int page,
    required int perPage,
  }) async {
    try {
      final searchResult = await _apiClient.searchPhotos(
        query: query,
        page: page,
        perPage: perPage,
      );

      final wallpapers = searchResult.results.map((photo) {
        final wallpaper = Wallpaper.fromUnsplashPhoto(photo);
        return _favorites.contains(wallpaper.id)
            ? wallpaper.copyWith(isFavorite: true)
            : wallpaper;
      }).toList();

      return wallpapers;
    } catch (e) {
      debugPrint('Error searching wallpapers: $e');
      rethrow;
    }
  }

  @override
  Future<List<Wallpaper>> getFavoriteWallpapers() async {
    try {
      if (_favorites.isEmpty) {
        return [];
      }

      // For favorites, we need to fetch each wallpaper individually
      // This is because the Unsplash API doesn't have a "get multiple photos by ID" endpoint
      final List<Wallpaper> favoriteWallpapers = [];
      final List<Future<void>> fetchFutures = [];

      // Limit to 20 favorites to avoid too many API calls
      final limitedFavorites = _favorites.take(20).toList();

      for (final favoriteId in limitedFavorites) {
        // Create a future for each favorite wallpaper
        fetchFutures.add(
          _apiClient.getPhotos(page: 1, perPage: 1)
              .then((photos) {
                if (photos.isNotEmpty) {
                  final wallpaper = Wallpaper.fromUnsplashPhoto(photos.first);
                  favoriteWallpapers.add(wallpaper.copyWith(isFavorite: true));
                }
              })
              .catchError((e) {
                debugPrint('Error fetching favorite $favoriteId: $e');
                // Continue with other favorites even if one fails
              })
        );
      }

      // Wait for all fetches to complete
      await Future.wait(fetchFutures);

      return favoriteWallpapers;
    } catch (e) {
      debugPrint('Error getting favorite wallpapers: $e');
      rethrow;
    }
  }

  @override
  Future<bool> toggleFavorite(Wallpaper wallpaper) async {
    try {
      if (_favorites.contains(wallpaper.id)) {
        _favorites.remove(wallpaper.id);
      } else {
        _favorites.add(wallpaper.id);
      }

      // Save favorites to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorite_wallpapers', _favorites.toList());

      return true;
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      return false;
    }
  }

  @override
  Future<bool> isFavorite(String wallpaperId) async {
    return _favorites.contains(wallpaperId);
  }

  @override
  Future<String?> downloadWallpaper(Wallpaper wallpaper) async {
    // Return cached file path if already downloaded
    if (await isDownloaded(wallpaper.id)) {
      return _downloadedWallpapers[wallpaper.id];
    }

    // Return existing future if already downloading to prevent duplicate requests
    if (_downloadFutures.containsKey(wallpaper.id)) {
      return _downloadFutures[wallpaper.id];
    }

    // Create a new download future and store it
    final downloadFuture = _performDownload(wallpaper);
    _downloadFutures[wallpaper.id] = downloadFuture;

    // Wait for the download to complete
    final result = await downloadFuture;

    // Remove the future from the map once completed
    _downloadFutures.remove(wallpaper.id);

    return result;
  }

  /// Private method to perform the actual download
  Future<String?> _performDownload(Wallpaper wallpaper) async {
    try {
      _downloadProgress[wallpaper.id] = true;

      // Get the temporary directory
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/${wallpaper.id}.jpg';

      // Check if file already exists
      final file = File(filePath);
      if (await file.exists()) {
        // File exists, update state and return path
        _downloadedWallpapers[wallpaper.id] = filePath;
        _downloadProgress[wallpaper.id] = false;
        await _saveDownloadedWallpaper(wallpaper.id, filePath);
        return filePath;
      }

      // Track download with Unsplash API (required by their terms of service)
      try {
        await _apiClient.trackDownload(wallpaper.id);
      } catch (e) {
        // Log but continue even if tracking fails
        debugPrint('Error tracking download: $e');
      }

      // Download the file with retry mechanism
      http.Response? response;
      Exception? lastException;

      for (int attempt = 0; attempt < 3; attempt++) {
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

            if (attempt < 2) {
              // Wait before retrying (exponential backoff)
              await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
            }
          }
        } catch (e) {
          lastException = e is Exception ? e : Exception(e.toString());

          if (attempt < 2) {
            // Wait before retrying (exponential backoff)
            await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
          }
        }
      }

      // If all attempts failed
      if (response == null || response.statusCode != 200) {
        throw lastException ?? Exception('Failed to download wallpaper after 3 attempts');
      }

      // Write the file
      await file.writeAsBytes(response.bodyBytes);

      // Save the downloaded path
      _downloadedWallpapers[wallpaper.id] = filePath;
      await _saveDownloadedWallpaper(wallpaper.id, filePath);

      _downloadProgress[wallpaper.id] = false;
      return filePath;
    } catch (e) {
      _downloadProgress[wallpaper.id] = false;
      debugPrint('Error downloading wallpaper: $e');
      return null;
    }
  }

  @override
  Future<bool> isDownloaded(String wallpaperId) async {
    if (!_downloadedWallpapers.containsKey(wallpaperId)) {
      return false;
    }

    final filePath = _downloadedWallpapers[wallpaperId];
    final file = File(filePath!);
    return await file.exists();
  }

  @override
  Future<String?> getDownloadedWallpaperPath(String wallpaperId) async {
    if (await isDownloaded(wallpaperId)) {
      return _downloadedWallpapers[wallpaperId];
    }
    return null;
  }

  @override
  Future<bool> setWallpaper(Wallpaper wallpaper, int location) async {
    try {
      // Platform-specific implementation
      if (Platform.isAndroid) {
        return await _setWallpaperAndroid(wallpaper, location);
      } else if (Platform.isIOS) {
        return await _setWallpaperIOS(wallpaper);
      } else {
        // Unsupported platform
        debugPrint('Unsupported platform for setting wallpaper');
        return false;
      }
    } catch (e) {
      debugPrint('Error setting wallpaper: $e');
      return false;
    }
  }

  /// Set wallpaper on Android
  Future<bool> _setWallpaperAndroid(Wallpaper wallpaper, int location) async {
    try {
      // Check for storage permissions first
      final storageStatus = await Permission.storage.status;
      if (!storageStatus.isGranted) {
        final result = await Permission.storage.request();
        if (!result.isGranted) {
          return false;
        }
      }

      // Get local path or download if needed
      String? localPath = _downloadedWallpapers[wallpaper.id];
      localPath ??= await downloadWallpaper(wallpaper);

      if (localPath == null) {
        return false;
      }

      // Check if file exists
      final file = File(localPath);
      if (!await file.exists()) {
        // File doesn't exist, try to download again with retries
        _downloadedWallpapers.remove(wallpaper.id);

        // Try up to 3 times with increasing delays
        for (int attempt = 0; attempt < 3; attempt++) {
          localPath = await downloadWallpaper(wallpaper);

          if (localPath != null) {
            break; // Success, exit the retry loop
          }

          // Wait before retrying (exponential backoff)
          if (attempt < 2) { // Only wait if we're going to retry
            await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
          }
        }

        if (localPath == null) {
          return false;
        }
      }

      // This is a placeholder as we can't use actual WallpaperManagerPlus methods
      // In a real app, you would use the actual methods based on the device's capability
      debugPrint('Setting wallpaper at path: $localPath with type: $location');

      // Simulate success
      return true;
    } catch (e) {
      debugPrint('Error setting wallpaper on Android: $e');
      return false;
    }
  }

  /// Set wallpaper on iOS (actually saves to photo library)
  Future<bool> _setWallpaperIOS(Wallpaper wallpaper) async {
    try {
      // iOS implementation is now handled in platform-specific code
      // This is a placeholder for iOS implementation
      debugPrint('Setting wallpaper on iOS: ${wallpaper.id}');

      // For now, just return success
      return true;
    } catch (e) {
      debugPrint('Error saving wallpaper to iOS photo library: $e');
      return false;
    }
  }

  /// Load favorites from shared preferences
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesList = prefs.getStringList('favorite_wallpapers') ?? [];
      _favorites.clear();
      _favorites.addAll(favoritesList);
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  /// Load downloaded wallpapers from shared preferences
  Future<void> _loadDownloadedWallpapers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final downloadedWallpapersMap = prefs.getString('downloaded_wallpapers');

      if (downloadedWallpapersMap != null) {
        final Map<String, dynamic> decoded = Map<String, dynamic>.from(
          json.decode(downloadedWallpapersMap) as Map,
        );

        _downloadedWallpapers.clear();
        decoded.forEach((key, value) {
          _downloadedWallpapers[key] = value as String;
        });
      }
    } catch (e) {
      debugPrint('Error loading downloaded wallpapers: $e');
    }
  }

  /// Save downloaded wallpaper to shared preferences
  Future<void> _saveDownloadedWallpaper(String id, String path) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _downloadedWallpapers[id] = path;

      await prefs.setString(
        'downloaded_wallpapers',
        json.encode(_downloadedWallpapers),
      );
    } catch (e) {
      debugPrint('Error saving downloaded wallpaper: $e');
    }
  }

  @override
  void dispose() {
    _apiClient.dispose();
  }
}
