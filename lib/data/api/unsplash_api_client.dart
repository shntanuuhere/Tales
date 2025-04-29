import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../features/wallpapers/data/models/unsplash_photo.dart';
import '../../features/categories/data/models/unsplash_topic.dart';
import '../../features/wallpapers/data/models/unsplash_search_result.dart';
import 'api_exception.dart';
import '../../config/api_keys.dart';
import '../../core/utils/api/api_cache.dart';
import '../../core/utils/storage/secure_storage.dart';
import '../../core/utils/security/certificate_pinning.dart';
import '../../core/network/connectivity_service.dart';
import '../../di/service_locator.dart';

/// Client for interacting with the Unsplash API
class UnsplashApiClient {
  /// Base URL for Unsplash API
  static const String _baseUrl = 'https://api.unsplash.com';

  /// HTTP client for making API requests
  final http.Client _httpClient;

  /// API key for Unsplash
  late String _apiKey;

  /// API cache instance
  final ApiCache _cache = ApiCache();

  /// Secure storage instance
  final SecureStorage _secureStorage = SecureStorage();

  /// Whether to use caching (default: true)
  final bool _useCache;

  /// Cache expiration time in minutes
  final int _cacheExpirationMinutes;

  /// Connectivity service
  final ConnectivityService _connectivityService;

  /// Constructor
  UnsplashApiClient({
    http.Client? httpClient,
    String? apiKey,
    bool useCache = true,
    int cacheExpirationMinutes = 60,
    ConnectivityService? connectivityService,
  }) :
    // Use certificate pinning for HTTP client in production
    _httpClient = httpClient ?? CertificatePinningHttpClient.getUnsplashClient(),
    _useCache = useCache,
    _cacheExpirationMinutes = cacheExpirationMinutes,
    _connectivityService = connectivityService ?? serviceLocator<ConnectivityService>() {

    // Set initial API key (will be updated from secure storage)
    _apiKey = apiKey ?? ApiKeys.unsplashAccessKey;

    // Load API key from secure storage
    _loadApiKey();
  }

  /// Load API key from secure storage
  Future<void> _loadApiKey() async {
    try {
      final apiKey = await _secureStorage.getUnsplashApiKey();
      if (apiKey.isNotEmpty) {
        _apiKey = apiKey;
      }
    } catch (e) {
      debugPrint('Failed to load API key from secure storage: $e');
    }
  }

  /// Get headers for API requests
  Map<String, String> get _headers => {
    'Authorization': 'Client-ID $_apiKey',
    'Accept-Version': 'v1',
  };

  /// Get a list of photos
  /// [page] - Page number to retrieve (default: 1)
  /// [perPage] - Number of items per page (default: 10)
  /// [orderBy] - How to sort photos (default: 'latest')
  Future<List<UnsplashPhoto>> getPhotos({
    int page = 1,
    int perPage = 10,
    String orderBy = 'latest',
  }) async {
    try {
      // Create a cache key based on the request parameters
      final cacheKey = 'photos_${page}_${perPage}_$orderBy';

      // Try to get data from cache first if caching is enabled
      // Always check cache if connectivity is poor
      bool shouldUseCache = _useCache;

      // If we're not on WiFi, prefer using cache
      shouldUseCache = shouldUseCache || !_connectivityService.isWifi;

      if (shouldUseCache) {
        final cachedData = await _cache.get(cacheKey);
        if (cachedData != null) {
          // Return cached data
          return (cachedData as List).map((item) => UnsplashPhoto.fromJson(item)).toList();
        }
      }

      // If no cached data or caching is disabled, make the API request
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/photos?page=$page&per_page=$perPage&order_by=$orderBy'),
        headers: _headers,
      );

      // Handle the response
      final photos = _handleResponse<List<UnsplashPhoto>>(
        response,
        (data) => (data as List).map((item) => UnsplashPhoto.fromJson(item)).toList(),
      );

      // Cache the raw data if caching is enabled
      if (_useCache) {
        await _cache.set(
          cacheKey,
          response.statusCode == 200 ? json.decode(response.body) : null,
          expirationMinutes: _cacheExpirationMinutes,
        );
      }

      return photos;
    } catch (e) {
      // If there's an error, try to return cached data as a fallback
      if (_useCache) {
        try {
          final cacheKey = 'photos_${page}_${perPage}_$orderBy';
          final cachedData = await _cache.get(cacheKey);
          if (cachedData != null) {
            debugPrint('Using cached data due to error: $e');
            return (cachedData as List).map((item) => UnsplashPhoto.fromJson(item)).toList();
          }
        } catch (_) {
          // Ignore cache fallback errors
        }
      }

      throw _handleException(e);
    }
  }

  /// Search for photos
  /// [query] - Search query
  /// [page] - Page number to retrieve (default: 1)
  /// [perPage] - Number of items per page (default: 10)
  Future<UnsplashSearchResult> searchPhotos({
    required String query,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      // Create a cache key based on the request parameters
      final cacheKey = 'search_${query}_${page}_$perPage';

      // Try to get data from cache first if caching is enabled
      if (_useCache) {
        final cachedData = await _cache.get(cacheKey);
        if (cachedData != null) {
          // Return cached data
          return UnsplashSearchResult.fromJson(cachedData);
        }
      }

      // If no cached data or caching is disabled, make the API request
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/search/photos?query=$query&page=$page&per_page=$perPage'),
        headers: _headers,
      );

      // Handle the response
      final searchResult = _handleResponse<UnsplashSearchResult>(
        response,
        (data) => UnsplashSearchResult.fromJson(data),
      );

      // Cache the raw data if caching is enabled
      if (_useCache) {
        await _cache.set(
          cacheKey,
          response.statusCode == 200 ? json.decode(response.body) : null,
          expirationMinutes: _cacheExpirationMinutes,
        );
      }

      return searchResult;
    } catch (e) {
      // If there's an error, try to return cached data as a fallback
      if (_useCache) {
        try {
          final cacheKey = 'search_${query}_${page}_$perPage';
          final cachedData = await _cache.get(cacheKey);
          if (cachedData != null) {
            debugPrint('Using cached data due to error: $e');
            return UnsplashSearchResult.fromJson(cachedData);
          }
        } catch (_) {
          // Ignore cache fallback errors
        }
      }

      throw _handleException(e);
    }
  }

  /// Get a list of topics
  /// [page] - Page number to retrieve (default: 1)
  /// [perPage] - Number of items per page (default: 10)
  Future<List<UnsplashTopic>> getTopics({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      // Create a cache key based on the request parameters
      final cacheKey = 'topics_${page}_$perPage';

      // Try to get data from cache first if caching is enabled
      if (_useCache) {
        final cachedData = await _cache.get(cacheKey);
        if (cachedData != null) {
          // Return cached data
          return (cachedData as List).map((item) => UnsplashTopic.fromJson(item)).toList();
        }
      }

      // If no cached data or caching is disabled, make the API request
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/topics?page=$page&per_page=$perPage'),
        headers: _headers,
      );

      // Handle the response
      final topics = _handleResponse<List<UnsplashTopic>>(
        response,
        (data) => (data as List).map((item) => UnsplashTopic.fromJson(item)).toList(),
      );

      // Cache the raw data if caching is enabled
      if (_useCache) {
        await _cache.set(
          cacheKey,
          response.statusCode == 200 ? json.decode(response.body) : null,
          // Use a longer expiration for topics since they don't change often
          expirationMinutes: _cacheExpirationMinutes * 2,
        );
      }

      return topics;
    } catch (e) {
      // If there's an error, try to return cached data as a fallback
      if (_useCache) {
        try {
          final cacheKey = 'topics_${page}_$perPage';
          final cachedData = await _cache.get(cacheKey);
          if (cachedData != null) {
            debugPrint('Using cached data due to error: $e');
            return (cachedData as List).map((item) => UnsplashTopic.fromJson(item)).toList();
          }
        } catch (_) {
          // Ignore cache fallback errors
        }
      }

      throw _handleException(e);
    }
  }

  /// Get photos by topic
  /// [topicIdOrSlug] - Topic ID or slug
  /// [page] - Page number to retrieve (default: 1)
  /// [perPage] - Number of items per page (default: 10)
  Future<List<UnsplashPhoto>> getPhotosByTopic({
    required String topicIdOrSlug,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      // Create a cache key based on the request parameters
      final cacheKey = 'topic_${topicIdOrSlug}_${page}_$perPage';

      // Try to get data from cache first if caching is enabled
      if (_useCache) {
        final cachedData = await _cache.get(cacheKey);
        if (cachedData != null) {
          // Return cached data
          return (cachedData as List).map((item) => UnsplashPhoto.fromJson(item)).toList();
        }
      }

      // If no cached data or caching is disabled, make the API request
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/topics/$topicIdOrSlug/photos?page=$page&per_page=$perPage'),
        headers: _headers,
      );

      // Handle the response
      final photos = _handleResponse<List<UnsplashPhoto>>(
        response,
        (data) => (data as List).map((item) => UnsplashPhoto.fromJson(item)).toList(),
      );

      // Cache the raw data if caching is enabled
      if (_useCache) {
        await _cache.set(
          cacheKey,
          response.statusCode == 200 ? json.decode(response.body) : null,
          expirationMinutes: _cacheExpirationMinutes,
        );
      }

      return photos;
    } catch (e) {
      // If there's an error, try to return cached data as a fallback
      if (_useCache) {
        try {
          final cacheKey = 'topic_${topicIdOrSlug}_${page}_$perPage';
          final cachedData = await _cache.get(cacheKey);
          if (cachedData != null) {
            debugPrint('Using cached data due to error: $e');
            return (cachedData as List).map((item) => UnsplashPhoto.fromJson(item)).toList();
          }
        } catch (_) {
          // Ignore cache fallback errors
        }
      }

      throw _handleException(e);
    }
  }

  /// Get a random photo
  /// [query] - Search query (optional)
  /// [count] - Number of photos to return (default: 1)
  Future<List<UnsplashPhoto>> getRandomPhotos({
    String? query,
    int count = 1,
  }) async {
    try {
      // For random photos, we'll use a shorter cache expiration
      // since the whole point is to get different photos each time
      final shortCacheExpiration = (_cacheExpirationMinutes / 6).round();

      // Create a cache key based on the request parameters
      final cacheKey = 'random_${query ?? "none"}_$count';

      // Try to get data from cache first if caching is enabled
      // Only use cache for random photos if we're in a low connectivity situation
      if (_useCache) {
        final cachedData = await _cache.get(cacheKey);
        if (cachedData != null) {
          // Return cached data
          return (cachedData as List).map((item) => UnsplashPhoto.fromJson(item)).toList();
        }
      }

      // Build the URL
      String url = '$_baseUrl/photos/random?count=$count';
      if (query != null && query.isNotEmpty) {
        url += '&query=$query';
      }

      // If no cached data or caching is disabled, make the API request
      final response = await _httpClient.get(
        Uri.parse(url),
        headers: _headers,
      );

      // Handle the response
      final photos = _handleResponse<List<UnsplashPhoto>>(
        response,
        (data) => (data as List).map((item) => UnsplashPhoto.fromJson(item)).toList(),
      );

      // Cache the raw data if caching is enabled, but with a shorter expiration
      if (_useCache) {
        await _cache.set(
          cacheKey,
          response.statusCode == 200 ? json.decode(response.body) : null,
          expirationMinutes: shortCacheExpiration,
        );
      }

      return photos;
    } catch (e) {
      // If there's an error, try to return cached data as a fallback
      if (_useCache) {
        try {
          final cacheKey = 'random_${query ?? "none"}_$count';
          final cachedData = await _cache.get(cacheKey);
          if (cachedData != null) {
            debugPrint('Using cached data due to error: $e');
            return (cachedData as List).map((item) => UnsplashPhoto.fromJson(item)).toList();
          }
        } catch (_) {
          // Ignore cache fallback errors
        }
      }

      throw _handleException(e);
    }
  }

  /// Track a photo download
  /// This is required by Unsplash API guidelines
  Future<void> trackDownload(String photoId) async {
    try {
      await _httpClient.get(
        Uri.parse('$_baseUrl/photos/$photoId/download'),
        headers: _headers,
      );
    } catch (e) {
      // Log but don't throw as this shouldn't block the download
      debugPrint('Error tracking download: $e');
    }
  }

  /// Handle API response
  T _handleResponse<T>(http.Response response, T Function(dynamic data) parser) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = json.decode(response.body);
      return parser(data);
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'API request failed: ${response.reasonPhrase}',
      );
    }
  }

  /// Handle exceptions
  ApiException _handleException(dynamic e) {
    if (e is ApiException) {
      return e;
    } else {
      return ApiException(
        message: 'API request failed: ${e.toString()}',
        originalException: e,
      );
    }
  }

  /// Dispose of the HTTP client when no longer needed
  void dispose() {
    _httpClient.close();
  }
}
