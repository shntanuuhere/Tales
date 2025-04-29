/// Application constants
class AppConstants {
  /// Private constructor to prevent instantiation
  AppConstants._();
  
  /// App name
  static const String appName = 'Tales';
  
  /// App version
  static const String appVersion = '1.1.0';
  
  /// API constants
  static const String unsplashBaseUrl = 'https://api.unsplash.com';
  
  /// Cache constants
  static const int defaultCacheExpirationMinutes = 60;
  static const int shortCacheExpirationMinutes = 10;
  static const int longCacheExpirationMinutes = 120;
  
  /// Storage keys
  static const String themePreferenceKey = 'theme_preference';
  static const String isDarkModeKey = 'is_dark_mode';
  
  /// Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 300);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);
}
