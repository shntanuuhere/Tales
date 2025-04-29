import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import '../../../../config/api_keys.dart';

/// A utility class for securely storing sensitive information
class SecureStorage {
  /// Singleton instance
  static final SecureStorage _instance = SecureStorage._internal();

  /// Factory constructor
  factory SecureStorage() => _instance;

  /// Internal constructor
  SecureStorage._internal();

  /// Secure storage instance
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  /// Key for Unsplash API key in secure storage
  static const String _unsplashApiKeyKey = 'unsplash_api_key';

  /// Initialize secure storage with default values
  Future<void> initialize() async {
    try {
      // Check if Unsplash API key exists
      final unsplashApiKey = await _storage.read(key: _unsplashApiKeyKey);

      // If not, store the default one
      if (unsplashApiKey == null) {
        await _storage.write(
          key: _unsplashApiKeyKey,
          value: ApiKeys.unsplashAccessKey,
        );
      }
    } catch (e) {
      debugPrint('Failed to initialize secure storage: $e');
    }
  }

  /// Get Unsplash API key
  Future<String> getUnsplashApiKey() async {
    try {
      final apiKey = await _storage.read(key: _unsplashApiKeyKey);
      return apiKey ?? ApiKeys.unsplashAccessKey;
    } catch (e) {
      debugPrint('Failed to get Unsplash API key: $e');
      return ApiKeys.unsplashAccessKey;
    }
  }

  /// Set Unsplash API key
  Future<bool> setUnsplashApiKey(String apiKey) async {
    try {
      await _storage.write(key: _unsplashApiKeyKey, value: apiKey);
      return true;
    } catch (e) {
      debugPrint('Failed to set Unsplash API key: $e');
      return false;
    }
  }

  /// Clear all secure storage
  Future<bool> clearAll() async {
    try {
      await _storage.deleteAll();
      return true;
    } catch (e) {
      debugPrint('Failed to clear secure storage: $e');
      return false;
    }
  }
}
