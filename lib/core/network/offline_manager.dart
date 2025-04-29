import 'dart:convert';
import 'package:flutter/foundation.dart' hide Category;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/wallpapers/domain/entities/wallpaper.dart';
import '../../features/categories/domain/entities/category.dart';

/// A utility class for managing offline content
class OfflineManager {

  /// Singleton instance
  static final OfflineManager _instance = OfflineManager._internal();

  /// Factory constructor
  factory OfflineManager() => _instance;

  /// Internal constructor
  OfflineManager._internal();

  /// Key for storing wallpapers
  static const String _wallpapersKey = 'offline_wallpapers';

  /// Key for storing categories
  static const String _categoriesKey = 'offline_categories';

  /// Key for storing last update timestamp
  static const String _lastUpdateKey = 'offline_last_update';

  /// Save wallpapers for offline use
  Future<bool> saveWallpapers(List<Wallpaper> wallpapers) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert wallpapers to JSON
      final wallpapersJson = wallpapers.map((w) => w.toJson()).toList();

      // Save wallpapers
      final result = await prefs.setString(_wallpapersKey, json.encode(wallpapersJson));

      // Update last update timestamp
      if (result) {
        await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
      }

      return result;
    } catch (e) {
      debugPrint('Failed to save wallpapers for offline use: $e');
      return false;
    }
  }

  /// Save categories for offline use
  Future<bool> saveCategories(List<Category> categories) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert categories to JSON
      final categoriesJson = categories.map((c) => c.toJson()).toList();

      // Save categories
      final result = await prefs.setString(_categoriesKey, json.encode(categoriesJson));

      // Update last update timestamp
      if (result) {
        await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
      }

      return result;
    } catch (e) {
      debugPrint('Failed to save categories for offline use: $e');
      return false;
    }
  }

  /// Get wallpapers for offline use
  Future<List<Wallpaper>> getWallpapers() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get wallpapers
      final wallpapersJson = prefs.getString(_wallpapersKey);

      if (wallpapersJson == null) {
        return [];
      }

      // Convert JSON to wallpapers
      final wallpapersList = json.decode(wallpapersJson) as List;
      return wallpapersList.map((w) => Wallpaper.fromJson(w)).toList();
    } catch (e) {
      debugPrint('Failed to get wallpapers for offline use: $e');
      return [];
    }
  }

  /// Get categories for offline use
  Future<List<Category>> getCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get categories
      final categoriesJson = prefs.getString(_categoriesKey);

      if (categoriesJson == null) {
        return [];
      }

      // Convert JSON to categories
      final categoriesList = json.decode(categoriesJson) as List;
      return categoriesList.map((c) => Category.fromJson(c)).toList();
    } catch (e) {
      debugPrint('Failed to get categories for offline use: $e');
      return [];
    }
  }



  /// Get wallpapers by category for offline use
  Future<List<Wallpaper>> getWallpapersByCategory(String category) async {
    try {
      // Get all wallpapers
      final wallpapers = await getWallpapers();

      // Filter by category
      return wallpapers.where((w) => w.category == category).toList();
    } catch (e) {
      debugPrint('Failed to get wallpapers by category for offline use: $e');
      return [];
    }
  }

  /// Get last update timestamp
  Future<DateTime?> getLastUpdate() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get last update timestamp
      final lastUpdate = prefs.getInt(_lastUpdateKey);

      if (lastUpdate == null) {
        return null;
      }

      return DateTime.fromMillisecondsSinceEpoch(lastUpdate);
    } catch (e) {
      debugPrint('Failed to get last update timestamp: $e');
      return null;
    }
  }

  /// Clear all offline data
  Future<bool> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Clear all offline data
      await prefs.remove(_wallpapersKey);
      await prefs.remove(_categoriesKey);
      await prefs.remove(_lastUpdateKey);

      return true;
    } catch (e) {
      debugPrint('Failed to clear offline data: $e');
      return false;
    }
  }
}
