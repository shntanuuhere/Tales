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


// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // App colors - Modern palette
  static const Color primaryColor = Color(0xFF6200EA); // Deep Purple
  static const Color accentColor = Color(0xFF03DAC6); // Teal
  static const Color darkBackground = Color(0xFF121212);
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color errorColor = Color(0xFFCF6679);
  static const Color splashLogoColor = Color(0xFF6200EA);

  // Additional accent colors
  static const Color yellowAccent = Color(0xFFFFD54F); // Amber
  static const Color secondaryAccent = Color(0xFFBB86FC); // Light Purple
  static const Color greenAccent = Color(0xFF69F0AE); // Green
  static const Color pinkAccent = Color(0xFFFF4081); // Pink
  static const Color darkSurface = Color(0xFF1E1E1E); // Dark surface
  static const Color darkCard = Color(0xFF252525); // Card dark

  // Glass Effect Colors
  static final Color glassLight = Colors.white.withAlpha(20); // 0.08 * 255 = ~20
  static final Color glassDark = Colors.black.withAlpha(51); // 0.2 * 255 = 51

  // Common styles for cards
  static final cardDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    color: darkCard,
  );

  // Card styles
  static final noteCardDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    color: accentColor,
  );

  static final yellowCardDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    color: yellowAccent,
  );

  static final purpleCardDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    color: secondaryAccent.withAlpha(51), // 0.2 * 255 = 51
  );

  // Light theme
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      error: errorColor,
      surface: lightBackground,
    ),
    scaffoldBackgroundColor: lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      headlineMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: Color(0xFF333333),
      ),
      bodyLarge: GoogleFonts.poppins(
        color: Color(0xFF555555),
      ),
      titleLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: Color(0xFF333333),
      ),
      titleMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        color: Color(0xFF333333),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: accentColor,
      unselectedItemColor: Colors.black.withAlpha(153), // 0.6 * 255 = 153
      selectedIconTheme: const IconThemeData(color: accentColor, size: 28),
      unselectedIconTheme: IconThemeData(color: Colors.black.withAlpha(153), size: 24),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey[200]!,
      disabledColor: Colors.grey[300]!,
      selectedColor: accentColor.withAlpha(51), // 0.2 * 255 = 51
      secondarySelectedColor: accentColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: GoogleFonts.spaceMono(
        color: Colors.black,
        fontSize: 12,
      ),
      secondaryLabelStyle: GoogleFonts.spaceMono(
        color: Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accentColor, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
    ),
  );

  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      error: errorColor,
      surface: darkBackground,
    ),
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      headlineMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.poppins(
        color: Color(0xFFDDDDDD),
      ),
      titleLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkBackground,
      selectedItemColor: accentColor,
      unselectedItemColor: Colors.white.withAlpha(153), // 0.6 * 255 = 153
      selectedIconTheme: const IconThemeData(color: accentColor, size: 28),
      unselectedIconTheme: IconThemeData(color: Colors.white.withAlpha(153), size: 24),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: darkBackground,
      indicatorColor: accentColor.withAlpha(51), // 0.2 * 255 = 51
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: accentColor);
        }
        return IconThemeData(color: Colors.white.withAlpha(179)); // 0.7 * 255 = 179
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.spaceMono(color: accentColor, fontWeight: FontWeight.w500);
        }
        return GoogleFonts.spaceMono(color: Colors.white.withAlpha(179)); // 0.7 * 255 = 179
      }),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkCard,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accentColor, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: darkSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      titleTextStyle: GoogleFonts.spaceMono(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      contentTextStyle: GoogleFonts.spaceMono(
        color: Colors.white70,
        fontSize: 14,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: darkCard,
      disabledColor: darkSurface,
      selectedColor: accentColor.withAlpha(51), // 0.2 * 255 = 51
      secondarySelectedColor: accentColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: GoogleFonts.spaceMono(
        color: Colors.white,
        fontSize: 12,
      ),
      secondaryLabelStyle: GoogleFonts.spaceMono(
        color: accentColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
