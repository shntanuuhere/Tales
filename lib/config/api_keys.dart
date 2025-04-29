/// API keys for external services.
///
/// This file loads API keys from the .env file
/// See .env.example for the required environment variables
library api_keys;

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Class containing API keys for external services
class ApiKeys {
  /// Unsplash API access key
  /// Get one at https://unsplash.com/developers
  static String get unsplashAccessKey =>
      dotenv.env['UNSPLASH_ACCESS_KEY'] ?? 'YOUR_UNSPLASH_ACCESS_KEY_HERE';    

  /// Fallback method to get API keys if .env file is not loaded
  static String getUnsplashAccessKey() {
    try {
      return dotenv.env['UNSPLASH_ACCESS_KEY'] ?? 'YOUR_UNSPLASH_ACCESS_KEY_HERE';
    } catch (e) {
      // Return placeholder key if dotenv is not initialized
      // You must set up your own key in the .env file
      return 'YOUR_UNSPLASH_ACCESS_KEY_HERE';
    }
  }
}
