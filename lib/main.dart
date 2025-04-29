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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tales/features/auth/data/repositories/auth_repository_impl.dart';
import 'firebase_options.dart';
import 'dart:developer' as developer;

// Import new architecture components
import 'di/service_locator.dart';
import 'features/wallpapers/presentation/providers/wallpaper_provider.dart';
import 'features/categories/presentation/providers/category_provider.dart';
import 'features/wallpapers/presentation/providers/favorites_provider.dart';
import 'features/settings/presentation/providers/theme_provider.dart';
import 'presentation/app/home_screen.dart';
import 'presentation/app/splash_screen.dart';
import 'core/network/connectivity_service.dart';
import 'core/utils/storage/secure_storage.dart';

void main() async {
  // Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations to portrait only for better performance
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Optimize system UI for better performance
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black,
    ),
  );

  // Load environment variables from .env file
  try {
    await dotenv.load(fileName: '.env');
    developer.log('Environment variables loaded successfully', name: 'tales.env');
  } catch (e) {
    developer.log('Failed to load environment variables: $e', name: 'tales.env', error: e);
    // Continue with default values if .env file is not found
  }

  // Initialize service locator for dependency injection
  initServiceLocator();

  // Initialize connectivity service early
  final connectivityService = serviceLocator<ConnectivityService>();

  // Initialize secure storage
  await SecureStorage().initialize();

  // Launch the app with minimal initialization
  // We'll load the rest in the splash screen
  runApp(
    // Provide the connectivity service to the entire app
    ChangeNotifierProvider.value(
      value: connectivityService,
      child: const MyApp(),
    ),
  );
}

// Initialize app resources asynchronously
Future<Map<String, dynamic>> _initializeApp() async {
  // Start loading preferences in parallel with Firebase initialization
  final prefsLoader = SharedPreferences.getInstance();

  // Try to initialize Firebase with proper error handling and recovery
  bool firebaseInitialized = false;
  String? firebaseError;

  try {
    // Check if Firebase is already initialized to prevent duplicate initialization
    if (Firebase.apps.isNotEmpty) {
      // Firebase is already initialized, just use the existing app
      developer.log('Firebase already initialized, using existing app', name: 'tales.firebase');
      firebaseInitialized = true;
    } else {
      // First attempt - Firebase is not initialized yet
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
        name: 'tales', // Use a specific name instead of DEFAULT
      );
      firebaseInitialized = true;
      firebaseError = null; // Clear any previous errors
      developer.log('Firebase initialized successfully', name: 'tales.firebase');
    }
  } catch (e) {
    developer.log('Failed to initialize Firebase on first attempt: $e',
      name: 'tales.firebase', error: e);

    // Store first error message in case second attempt also fails
    final firstErrorMessage = e.toString();

    // Try again with a delay (network might be temporarily unavailable)
    try {
      await Future.delayed(const Duration(seconds: 2));

      // Check again if Firebase is already initialized
      if (Firebase.apps.isNotEmpty) {
        // Firebase is already initialized, just use the existing app
        developer.log('Firebase already initialized on second attempt, using existing app', name: 'tales.firebase');
        firebaseInitialized = true;
      } else {
        // Second attempt
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
          name: 'tales', // Use a specific name instead of DEFAULT
        );
        firebaseInitialized = true;
        firebaseError = null; // Clear any previous errors
        developer.log('Firebase initialized successfully on second attempt',
          name: 'tales.firebase');
      }
    } catch (e2) {
      // Store error message for display to user
      // Include both errors for better debugging
      firebaseError = 'Second attempt: ${e2.toString()}\nFirst attempt: $firstErrorMessage';
      developer.log('Failed to initialize Firebase on second attempt: $e2',
        name: 'tales.firebase', error: e2);

      // Report to crash analytics if available
      try {
        // This would normally use Firebase Crashlytics, but we'll just log for now
        developer.log('CRASH REPORT: Firebase initialization failed: $e2',
          name: 'tales.crashlytics');
      } catch (_) {
        // Ignore errors in crash reporting
      }
    }
  }

  // Wait for preferences to load
  final prefs = await prefsLoader;
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;

  return {
    'isDarkMode': isDarkMode,
    'firebaseInitialized': firebaseInitialized,
    'firebaseError': firebaseError,
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define themes once to avoid rebuilding them
    final lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF40BFFF),
        primary: const Color(0xFF40BFFF),
        secondary: const Color(0xFF40BFFF),
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF40BFFF),
        unselectedItemColor: Color(0xFFADADAD),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
      useMaterial3: true,
      visualDensity: VisualDensity.compact,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );

    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF40BFFF),
        secondary: Color(0xFF40BFFF),
        surface: Color(0xFF1E1E1E),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: Color(0xFF40BFFF),
        unselectedItemColor: Color(0xFF8E8E8E),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.white70,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
      useMaterial3: true,
      visualDensity: VisualDensity.compact,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );

    return MaterialApp(
      title: 'Tales',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, // Start with system theme for faster startup
      home: FutureBuilder<Map<String, dynamic>>(
        future: _initializeApp(),
        builder: (context, snapshot) {
          // Show splash screen while loading
          if (!snapshot.hasData) {
            return const SplashScreen();
          }

          // Once loaded, setup providers and navigate to main screen
          final data = snapshot.data!;
          final firebaseInitialized = data['firebaseInitialized'] as bool;
          final firebaseError = data['firebaseError'] as String?;

          // Update the theme provider with the saved dark mode preference
          final isDarkMode = data['isDarkMode'] as bool;
          serviceLocator<ThemeProvider>().setThemeMode(
            isDarkMode ? ThemeMode.dark : ThemeMode.light
          );

          // Show a snackbar with Firebase error if there is one
          if (firebaseError != null) {
            // Use a post-frame callback to show the snackbar after the UI is built
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Firebase error: $firebaseError'),
                  duration: const Duration(seconds: 10),
                  action: SnackBarAction(
                    label: 'Dismiss',
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                ),
              );
            });
          }

          return MultiProvider(
            providers: [
              // Providers from the new architecture
              ChangeNotifierProvider<ThemeProvider>(
                create: (_) => serviceLocator<ThemeProvider>(),
              ),
              ChangeNotifierProvider<WallpaperProvider>(
                create: (_) => serviceLocator<WallpaperProvider>(),
              ),
              ChangeNotifierProvider<CategoryProvider>(
                create: (_) => serviceLocator<CategoryProvider>(),
              ),
              ChangeNotifierProvider<FavoritesProvider>(
                create: (_) => serviceLocator<FavoritesProvider>(),
              ),
              // Connectivity service is already provided at the app level
              // but we include it here for consistency
              ChangeNotifierProvider<ConnectivityService>.value(
                value: serviceLocator<ConnectivityService>(),
              ),
              // Auth repository
              ChangeNotifierProvider(create: (_) => AuthRepositoryImpl(isFirebaseInitialized: firebaseInitialized)),
            ],
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                // Update theme mode based on user preference
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  if (themeProvider.isDarkMode != (Theme.of(context).brightness == Brightness.dark)) {
                    final success = await themeProvider.toggleTheme();
                    if (!success && themeProvider.errorMessage != null) {
                      // Show error message if theme toggle failed
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(themeProvider.errorMessage!),
                            duration: const Duration(seconds: 3),
                            action: SnackBarAction(
                              label: 'Dismiss',
                              onPressed: () {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                themeProvider.clearError();
                              },
                            ),
                          ),
                        );
                      }
                    }
                  }
                });

                // Return the home screen
                return const HomeScreen();
              },
            ),
          );
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

// End of file
