import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for theme settings
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'app_theme_mode';
  static const String _isDarkModeKey = 'isDarkMode';
  
  /// Whether the app is in dark mode
  bool _isDarkMode;
  
  /// Current theme mode
  ThemeMode _themeMode;
  
  /// Error message
  String? _errorMessage;
  
  /// Constructor
  ThemeProvider(this._isDarkMode)
      : _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light {
    _loadThemePreference();
  }
  
  /// Getters
  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _themeMode;
  String? get errorMessage => _errorMessage;
  
  /// Load theme preference from shared preferences
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if theme mode is saved
      final themeModeString = prefs.getString(_themeKey);
      if (themeModeString != null) {
        _themeMode = _getThemeModeFromString(themeModeString);
        _isDarkMode = _themeMode == ThemeMode.dark;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to load theme preference: ${e.toString()}';
      notifyListeners();
    }
  }
  
  /// Toggle between light and dark theme
  Future<bool> toggleTheme() async {
    try {
      _isDarkMode = !_isDarkMode;
      _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
      _errorMessage = null;
      notifyListeners();
      
      // Save theme preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isDarkModeKey, _isDarkMode);
      await prefs.setString(_themeKey, _getStringFromThemeMode(_themeMode));
      return true;
    } catch (e) {
      _errorMessage = 'Failed to save theme preference: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
  
  /// Set theme mode directly
  Future<bool> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return true;
    
    try {
      _themeMode = mode;
      _isDarkMode = mode == ThemeMode.dark;
      _errorMessage = null;
      notifyListeners();
      
      // Save theme preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isDarkModeKey, _isDarkMode);
      await prefs.setString(_themeKey, _getStringFromThemeMode(mode));
      return true;
    } catch (e) {
      _errorMessage = 'Failed to save theme preference: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
  
  /// Clear error message
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
  
  /// Convert ThemeMode to string
  String _getStringFromThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
  
  /// Convert string to ThemeMode
  ThemeMode _getThemeModeFromString(String themeModeString) {
    switch (themeModeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }
}
