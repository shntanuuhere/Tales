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
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;
// Import the stub implementations to fix analyzer errors
// The actual implementations will be used at runtime from the packages
import 'auth_stubs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart' as google;

class AuthService extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final google.GoogleSignIn _googleSignIn;
  final LocalAuthentication _localAuth = LocalAuthentication();
  User? _user;
  bool _isLoading = false;
  String? _error;
  final bool _isFirebaseInitialized;

  AuthService({bool isFirebaseInitialized = true})
      : _isFirebaseInitialized = isFirebaseInitialized {

    if (_isFirebaseInitialized) {
      _auth = FirebaseAuth.instance;
      _googleSignIn = google.GoogleSignIn();

      _auth.authStateChanges().listen((User? user) {
        _user = user;
        notifyListeners();
      });
    } else {
      // Create dummy instances when Firebase is not initialized
      _auth = FirebaseAuth.instance;
      _googleSignIn = google.GoogleSignIn();

      // Set error message to indicate Firebase is not available
      _error = 'Firebase is not initialized. Some features may not work.';
    }
  }

  // Getters
  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get userId => _user?.uid ?? '';

  // Register user with email and password
  Future<UserCredential?> registerWithEmailAndPassword(String email, String password) async {
    if (!_isFirebaseInitialized) {
      _error = 'Firebase is not initialized. Cannot register.';
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set flag to show biometric auth screen upon successful registration
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('should_show_user_details', true);

      _isLoading = false;
      notifyListeners();
      return result;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = _getErrorMessage(e.code);
      notifyListeners();
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    if (!_isFirebaseInitialized) {
      _error = 'Firebase is not initialized. Cannot sign in.';
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set flag to show biometric auth screen upon successful login
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('should_show_user_details', true);

      _isLoading = false;
      notifyListeners();
      return result;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = _getErrorMessage(e.code);
      notifyListeners();
      rethrow;
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    if (!_isFirebaseInitialized) {
      _error = 'Firebase is not initialized. Cannot sign in with Google.';
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final google.GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return null; // User canceled the sign-in process
      }

      final google.GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential result = await _auth.signInWithCredential(credential);

      // Set flag to show biometric auth screen upon successful login
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('should_show_user_details', true);

      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      developer.log('Google sign in error: $e', name: 'auth_service', error: e);

      // Provide more specific error messages based on exception type
      if (e is FirebaseAuthException) {
        _error = _getErrorMessage(e.code);
      } else if (e.toString().contains('network')) {
        _error = 'Network error during Google sign in. Please check your connection.';
      } else if (e.toString().contains('canceled') || e.toString().contains('cancel')) {
        _error = 'Google sign in was canceled.';
      } else if (e.toString().contains('credential')) {
        _error = 'Invalid credentials. Please try again.';
      } else {
        _error = 'Google sign in error: ${e.toString().substring(0, e.toString().length > 50 ? 50 : e.toString().length)}...';
      }

      notifyListeners();
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    if (!_isFirebaseInitialized) {
      _error = 'Firebase is not initialized. Cannot sign out.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _googleSignIn.signOut();
      await _auth.signOut();

      // Reset user details screen flag
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('should_show_user_details', false);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      developer.log('Sign out error: $e', name: 'auth_service', error: e);
      _error = 'Sign out error';
      notifyListeners();
      rethrow;
    }
  }

  // Check if biometrics is available
  Future<bool> isBiometricsAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics &&
             await _localAuth.isDeviceSupported();
    } catch (e) {
      developer.log('Biometrics check error: $e', name: 'auth_service', error: e);
      _error = 'Biometrics check error: ${e.toString()}';
      notifyListeners(); // Notify listeners about the error
      return false;
    }
  }

  // Authenticate with biometrics
  Future<bool> authenticateWithBiometrics() async {
    try {
      _error = null; // Clear any previous errors
      notifyListeners();

      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to access your account',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      developer.log('Biometric authentication error: $e', name: 'auth_service', error: e);
      _error = 'Biometric authentication error: ${e.toString()}';
      notifyListeners(); // Notify listeners about the error
      return false;
    }
  }

  // Check if user details screen should be shown
  Future<bool> shouldShowUserDetailsScreen() async {
    if (!isAuthenticated) return false;

    try {
      _error = null; // Clear any previous errors
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('should_show_user_details') ?? false;
    } catch (e) {
      developer.log('Preference check error: $e', name: 'auth_service', error: e);
      _error = 'Preference check error: ${e.toString()}';
      notifyListeners(); // Notify listeners about the error
      return false;
    }
  }

  // Reset the user details screen flag
  Future<bool> resetUserDetailsScreenFlag() async {
    try {
      _error = null; // Clear any previous errors
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('should_show_user_details', false);
      return true;
    } catch (e) {
      developer.log('Reset preference error: $e', name: 'auth_service', error: e);
      _error = 'Reset preference error: ${e.toString()}';
      notifyListeners(); // Notify listeners about the error
      return false;
    }
  }

  // Password reset
  Future<bool> resetPassword(String email) async {
    if (!_isFirebaseInitialized) {
      _error = 'Firebase is not initialized. Cannot reset password.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = _getErrorMessage(e.code);
      notifyListeners();
      return false;
    }
  }

  // Handle error messages
  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'Email is already in use by another account.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Email address is invalid.';
      case 'operation-not-allowed':
        return 'Operation not allowed.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  // Clear errors
  void clearError() {
    _error = null;
    notifyListeners();
  }
}