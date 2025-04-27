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
import 'package:tales/services/theme_service.dart';
import 'package:tales/services/wallpaper_service.dart';
import 'package:tales/services/auth_service.dart';
import 'package:tales/screens/splash_screen.dart';
import 'package:tales/screens/wallpaper_screen.dart';
import 'firebase_options.dart';
import 'dart:developer' as developer;

void main() {
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

  // Launch the app with minimal initialization
  // We'll load the rest in the splash screen
  runApp(const MyApp());
}

// Initialize app resources asynchronously
Future<Map<String, dynamic>> _initializeApp() async {
  // Start loading preferences in parallel with Firebase initialization
  final prefsLoader = SharedPreferences.getInstance();

  // Try to initialize Firebase with proper error handling and recovery
  bool firebaseInitialized = false;
  String? firebaseError;

  try {
    // First attempt
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseInitialized = true;
    firebaseError = null; // Clear any previous errors
    developer.log('Firebase initialized successfully', name: 'tales.firebase');
  } catch (e) {
    developer.log('Failed to initialize Firebase on first attempt: $e',
      name: 'tales.firebase', error: e);

    // Store first error message in case second attempt also fails
    final firstErrorMessage = e.toString();

    // Try again with a delay (network might be temporarily unavailable)
    try {
      await Future.delayed(const Duration(seconds: 2));
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      firebaseInitialized = true;
      firebaseError = null; // Clear any previous errors
      developer.log('Firebase initialized successfully on second attempt',
        name: 'tales.firebase');
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
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
      // Optimize for performance
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
      colorScheme: ColorScheme.dark(
        primary: Colors.deepPurple.shade300,
        secondary: Colors.deepPurple.shade200,
      ),
      useMaterial3: true,
      // Optimize for performance
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
          final isDarkMode = data['isDarkMode'] as bool;
          final firebaseInitialized = data['firebaseInitialized'] as bool;
          final firebaseError = data['firebaseError'] as String?;

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
              ChangeNotifierProvider(create: (_) => ThemeService(isDarkMode)),
              // Lazy load services that aren't needed immediately
              ChangeNotifierProvider(create: (_) => WallpaperService()),
              ChangeNotifierProvider(create: (_) => AuthService(isFirebaseInitialized: firebaseInitialized)),
            ],
            child: Consumer<ThemeService>(
              builder: (context, themeService, _) {
                // Update theme mode based on user preference
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  if (themeService.isDarkMode != (Theme.of(context).brightness == Brightness.dark)) {
                    final success = await themeService.toggleTheme();
                    if (!success && themeService.error != null) {
                      // Show error message if theme toggle failed
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(themeService.error!),
                            duration: const Duration(seconds: 3),
                            action: SnackBarAction(
                              label: 'Dismiss',
                              onPressed: () {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                themeService.clearError();
                              },
                            ),
                          ),
                        );
                      }
                    }
                  }
                });

                // Import screens here to avoid circular dependencies
                return const WallpaperScreen();
              },
            ),
          );
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Placeholder widgets for tabs
class WallpapersTab extends StatelessWidget {
  const WallpapersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallpapers'),
      ),
      body: const Center(
        child: Text('Wallpapers Coming Soon'),
      ),
    );
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeService.isDarkMode,
            onChanged: (bool value) {
              themeService.toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}
