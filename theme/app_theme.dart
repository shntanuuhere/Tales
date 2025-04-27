// lib/theme/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryOrange = Color(0xFFFF5722); // vibrant orange
  static const Color accentOrange = Color(0xFFFF8A65); // light orange
  static const Color pitchBlack = Color(0xFF000000); // AMOLED black
  static const Color darkGrey = Color(0xFF1A1A1A); // card-like dark

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: pitchBlack,
    canvasColor: pitchBlack,
    cardColor: darkGrey,
    primaryColor: primaryOrange,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: primaryOrange,
      surface: pitchBlack,
      secondary: accentOrange,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: pitchBlack,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      selectedIconTheme: IconThemeData(color: primaryOrange),
      showSelectedLabels: true,
    ),
  );

  static ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    canvasColor: Colors.white,
    cardColor: Colors.grey[100],
    primaryColor: primaryOrange,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryOrange,
      unselectedItemColor: Colors.grey,
      selectedIconTheme: IconThemeData(color: primaryOrange),
      showSelectedLabels: true,
    ),
  );
}
