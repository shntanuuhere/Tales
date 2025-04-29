import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// A utility class for caching API responses
class ApiCache {
  /// Cache expiration time in minutes
  static const int _defaultCacheExpirationMinutes = 60;
  
  /// Singleton instance
  static final ApiCache _instance = ApiCache._internal();
  
  /// Factory constructor
  factory ApiCache() => _instance;
  
  /// Internal constructor
  ApiCache._internal();
  
  /// Get cached data for a given key
  /// Returns null if cache is expired or not found
  Future<dynamic> get(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = prefs.getString('api_cache_$key');
      
      if (cacheData == null) {
        return null;
      }
      
      final cacheMap = json.decode(cacheData) as Map<String, dynamic>;
      final timestamp = cacheMap['timestamp'] as int;
      final expirationMinutes = cacheMap['expirationMinutes'] as int? ?? _defaultCacheExpirationMinutes;
      
      // Check if cache is expired
      final now = DateTime.now().millisecondsSinceEpoch;
      final expirationTime = timestamp + (expirationMinutes * 60 * 1000);
      
      if (now > expirationTime) {
        // Cache expired, remove it
        await prefs.remove('api_cache_$key');
        return null;
      }
      
      return cacheMap['data'];
    } catch (e) {
      // If any error occurs, return null to fetch fresh data
      return null;
    }
  }
  
  /// Set cache data for a given key
  Future<bool> set(String key, dynamic data, {int expirationMinutes = _defaultCacheExpirationMinutes}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheMap = {
        'data': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'expirationMinutes': expirationMinutes,
      };
      
      return await prefs.setString('api_cache_$key', json.encode(cacheMap));
    } catch (e) {
      // If any error occurs, return false
      return false;
    }
  }
  
  /// Clear all cached data
  Future<bool> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith('api_cache_'));
      
      for (final key in keys) {
        await prefs.remove(key);
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Clear cached data for a given key
  Future<bool> clear(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove('api_cache_$key');
    } catch (e) {
      return false;
    }
  }
}
