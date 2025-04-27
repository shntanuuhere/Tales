import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  bool _isDarkMode;
  String? _error;

  ThemeService(this._isDarkMode);

  bool get isDarkMode => _isDarkMode;
  String? get error => _error;

  Future<bool> toggleTheme() async {
    try {
      _isDarkMode = !_isDarkMode;
      _error = null;
      notifyListeners();

      // Save theme preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', _isDarkMode);
      return true;
    } catch (e) {
      _error = 'Failed to save theme preference: ${e.toString()}';
      developer.log('Theme toggle error: $e', name: 'theme_service', error: e);
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }
}