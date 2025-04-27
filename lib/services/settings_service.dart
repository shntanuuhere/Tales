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

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:developer' as developer;

class SettingsService extends ChangeNotifier {
  // Settings keys
  static const String _darkModeKey = 'isDarkMode';
  static const String _fontSizeKey = 'fontSize';
  static const String _notificationsKey = 'enableNotifications';
  static const String _autoplayPodcastsKey = 'autoplayPodcasts';
  static const String _streamQualityKey = 'streamQuality';
  static const String _downloadOnWifiOnlyKey = 'downloadOnWifiOnly';

  // Default values
  bool _isDarkMode = false;
  double _fontSize = 16.0;
  bool _enableNotifications = true;
  bool _autoplayPodcasts = false;
  String _streamQuality = 'high';
  bool _downloadOnWifiOnly = true;

  // Loading status
  bool _isLoading = true;

  // Private fields
  bool _notificationsEnabled = true;
  bool _highQualityStreaming = true;
  bool _autoDownload = false;
  int _cacheSize = 0; // In MB

  // Getters
  bool get isDarkMode => _isDarkMode;
  double get fontSize => _fontSize;
  bool get enableNotifications => _enableNotifications;
  bool get autoplayPodcasts => _autoplayPodcasts;
  String get streamQuality => _streamQuality;
  bool get downloadOnWifiOnly => _downloadOnWifiOnly;
  bool get isLoading => _isLoading;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get highQualityStreaming => _highQualityStreaming;
  bool get wifiOnlyDownloads => _downloadOnWifiOnly;
  bool get autoDownload => _autoDownload;
  int get cacheSize => _cacheSize;

  // Constructor loads settings
  SettingsService() {
    _loadSettings();
    _calculateCacheSize();
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(_darkModeKey) ?? _isDarkMode;
      _fontSize = prefs.getDouble(_fontSizeKey) ?? _fontSize;
      _enableNotifications = prefs.getBool(_notificationsKey) ?? _enableNotifications;
      _autoplayPodcasts = prefs.getBool(_autoplayPodcastsKey) ?? _autoplayPodcasts;
      _streamQuality = prefs.getString(_streamQualityKey) ?? _streamQuality;
      _downloadOnWifiOnly = prefs.getBool(_downloadOnWifiOnlyKey) ?? _downloadOnWifiOnly;
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _highQualityStreaming = prefs.getBool('high_quality_streaming') ?? true;
      _autoDownload = prefs.getBool('auto_download') ?? false;
    } catch (e) {
      debugPrint('Error loading settings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save a setting
  Future<void> _saveSetting(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is String) {
        await prefs.setString(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      }
    } catch (e) {
      debugPrint('Error saving setting ($key): $e');
    }
  }

  // Toggle dark mode
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _saveSetting(_darkModeKey, _isDarkMode);
    await _saveSetting('dark_mode', _isDarkMode);
    notifyListeners();
  }

  // Set font size
  Future<void> setFontSize(double size) async {
    if (size >= 12.0 && size <= 24.0) {
      _fontSize = size;
      await _saveSetting(_fontSizeKey, _fontSize);
      notifyListeners();
    }
  }

  // Toggle notifications
  Future<void> toggleNotifications() async {
    _enableNotifications = !_enableNotifications;
    await _saveSetting(_notificationsKey, _enableNotifications);
    await _saveSetting('notifications_enabled', _enableNotifications);
    notifyListeners();
  }

  // Toggle autoplay podcasts
  Future<void> toggleAutoplayPodcasts() async {
    _autoplayPodcasts = !_autoplayPodcasts;
    await _saveSetting(_autoplayPodcastsKey, _autoplayPodcasts);
    notifyListeners();
  }

  // Set stream quality
  Future<void> setStreamQuality(String quality) async {
    if (['low', 'medium', 'high'].contains(quality)) {
      _streamQuality = quality;
      await _saveSetting(_streamQualityKey, _streamQuality);
      notifyListeners();
    }
  }

  // Toggle download on WiFi only
  Future<void> toggleDownloadOnWifiOnly() async {
    _downloadOnWifiOnly = !_downloadOnWifiOnly;
    await _saveSetting(_downloadOnWifiOnlyKey, _downloadOnWifiOnly);
    await _saveSetting('wifi_only_downloads', _downloadOnWifiOnly);
    notifyListeners();
  }

  // Set WiFi only downloads
  Future<void> setWifiOnlyDownloads(bool value) async {
    _downloadOnWifiOnly = value;
    await _saveSetting(_downloadOnWifiOnlyKey, _downloadOnWifiOnly);
    await _saveSetting('wifi_only_downloads', _downloadOnWifiOnly);
    notifyListeners();
  }

  // Set high quality streaming
  Future<void> setHighQualityStreaming(bool value) async {
    _highQualityStreaming = value;
    await _saveSetting('high_quality_streaming', _highQualityStreaming);
    notifyListeners();
  }

  // Set auto download
  Future<void> setAutoDownload(bool value) async {
    _autoDownload = value;
    await _saveSetting('auto_download', _autoDownload);
    notifyListeners();
  }

  // Reset all settings to defaults
  Future<void> resetSettings() async {
    _isDarkMode = false;
    _fontSize = 16.0;
    _enableNotifications = true;
    _autoplayPodcasts = false;
    _streamQuality = 'high';
    _downloadOnWifiOnly = true;
    _notificationsEnabled = true;
    _highQualityStreaming = true;
    _autoDownload = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  // Get app version (hardcoded)
  String getAppVersion() {
    return 'Tales v1.0.1';
  }

  // Launch URL helper
  Future<bool> launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      return await launchUrl(uri);
    } catch (e) {
      debugPrint('Error launching URL: $e');
      return false;
    }
  }

  // Send email
  Future<bool> sendEmail(String email, String subject) async {
    try {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {'subject': subject},
      );
      return await launchUrl(emailUri);
    } catch (e) {
      developer.log('Error sending email: $e', name: 'settings_service', error: e);
      return false;
    }
  }

  // Social media links
  Future<bool> openWebsite() async {
    const String websiteUrl = 'https://example.com/tales';
    return launchURL(websiteUrl);
  }

  // Calculate cache size
  Future<void> _calculateCacheSize() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final appCacheDir = Directory('${cacheDir.path}/flutter_cache_manager');

      if (await appCacheDir.exists()) {
        int totalSize = 0;
        await for (final FileSystemEntity entity in appCacheDir.list(recursive: true)) {
          if (entity is File) {
            totalSize += await entity.length();
          }
        }

        // Convert to MB
        _cacheSize = (totalSize / (1024 * 1024)).round();
        notifyListeners();
      }
    } catch (e) {
      developer.log('Error calculating cache size: $e', name: 'settings_service', error: e);
      _cacheSize = 0;
    }
  }

  // Clear cache
  Future<void> clearCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final appCacheDir = Directory('${cacheDir.path}/flutter_cache_manager');

      if (await appCacheDir.exists()) {
        await appCacheDir.delete(recursive: true);
      }

      _cacheSize = 0;
      notifyListeners();
    } catch (e) {
      developer.log('Error clearing cache: $e', name: 'settings_service', error: e);
    }
  }
}
