// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color accentColor = Color(0xFF1DB954); // Spotify green
  static const Color secondaryAccent = Color(0xFF1ED760); // Lighter green
  static const Color pitchBlack = Color(0xFF000000); // Pure black
  static const Color darkGrey = Color(0xFF121212); // Spotify dark
  static const Color darkSurface = Color(0xFF282828); // Card surface dark
  static const Color lightGrey = Color(0xFFF8F8F8); // Light surface
  
  // Glass Effect Colors
  static final Color glassLight = Colors.white.withOpacity(0.1);
  static final Color glassDark = Colors.black.withOpacity(0.2);
  static final Color glassStroke = Colors.white.withOpacity(0.2);

  // Common styles
  static final cardDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    color: darkSurface,
    border: Border.all(color: glassStroke, width: 0.5),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 15,
        offset: const Offset(0, 8),
      ),
    ],
  );

  static final glassDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    color: glassLight,
    border: Border.all(color: glassStroke, width: 0.5),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ],
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: pitchBlack,
    canvasColor: pitchBlack,
    cardColor: darkSurface,
    primaryColor: accentColor,
    colorScheme: ColorScheme.dark(
      primary: accentColor,
      secondary: secondaryAccent,
      surface: darkSurface,
      background: pitchBlack,
      onBackground: Colors.white.withOpacity(0.87),
      onSurface: Colors.white.withOpacity(0.87),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: Colors.white70),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      selectedItemColor: accentColor,
      unselectedItemColor: Colors.white.withOpacity(0.6),
      selectedIconTheme: const IconThemeData(color: accentColor, size: 28),
      unselectedIconTheme: IconThemeData(color: Colors.white.withOpacity(0.6), size: 24),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkGrey,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: Colors.white.withOpacity(0.87)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  static ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    canvasColor: Colors.white,
    cardColor: lightGrey,
    primaryColor: accentColor,
    colorScheme: ColorScheme.light(
      primary: accentColor,
      secondary: secondaryAccent,
      surface: Colors.white,
      background: lightGrey,
      onBackground: Colors.black87,
      onSurface: Colors.black87,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: Colors.black54),
      bodyMedium: TextStyle(color: Colors.black54),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: accentColor,
      unselectedItemColor: Colors.black.withOpacity(0.5),
      selectedIconTheme: const IconThemeData(color: accentColor),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: Colors.black87),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
