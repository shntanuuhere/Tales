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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart' as google;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

/// A service for handling authentication
class AuthService extends ChangeNotifier {
  /// Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Google Sign In instance
  final google.GoogleSignIn _googleSignIn = google.GoogleSignIn();

  /// Whether Firebase is initialized
  final bool _isFirebaseInitialized;

  /// Current user
  User? _user;

  /// Error message
  String? _error;

  /// Loading state
  bool _isLoading = false;

  /// Constructor
  AuthService({bool isFirebaseInitialized = true})
      : _isFirebaseInitialized = isFirebaseInitialized {
    // Initialize the service
    _init();
  }

  /// Initialize the service
  void _init() {
    if (!_isFirebaseInitialized) {
      _error = 'Firebase is not initialized. Authentication will not work.';
      notifyListeners();
      return;
    }

    // Get current user
    _user = _auth.currentUser;

    // Listen for auth state changes
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Getters
  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get userId => _user?.uid ?? '';

  /// Get error message for Firebase Auth error code
  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'Operation not allowed.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email address but different sign-in credentials.';
      case 'invalid-credential':
        return 'The credential is malformed or has expired.';
      case 'network-request-failed':
        return 'A network error occurred. Please check your connection.';
      case 'popup-closed-by-user':
        return 'The popup was closed before authentication could be completed.';
      default:
        return 'An error occurred: $code';
    }
  }

  /// Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    if (!_isFirebaseInitialized) {
      _error = 'Firebase is not initialized. Cannot sign in with email and password.';
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _isLoading = false;
      notifyListeners();
      return credential;
    } catch (e) {
      _isLoading = false;
      developer.log('Email/password sign in error: $e', name: 'auth_service', error: e);

      if (e is FirebaseAuthException) {
        _error = _getErrorMessage(e.code);
      } else {
        _error = 'An error occurred during sign in: ${e.toString()}';
      }

      notifyListeners();
      return null;
    }
  }

  /// Sign in with Google
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

  /// Register with email and password
  Future<UserCredential?> registerWithEmailAndPassword(String email, String password) async {
    if (!_isFirebaseInitialized) {
      _error = 'Firebase is not initialized. Cannot register with email and password.';
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _isLoading = false;
      notifyListeners();
      return credential;
    } catch (e) {
      _isLoading = false;
      developer.log('Email/password registration error: $e', name: 'auth_service', error: e);

      if (e is FirebaseAuthException) {
        _error = _getErrorMessage(e.code);
      } else {
        _error = 'An error occurred during registration: ${e.toString()}';
      }

      notifyListeners();
      return null;
    }
  }

  /// Sign out
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

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    if (!_isFirebaseInitialized) {
      _error = 'Firebase is not initialized. Cannot send password reset email.';
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
    } catch (e) {
      _isLoading = false;
      developer.log('Password reset error: $e', name: 'auth_service', error: e);

      if (e is FirebaseAuthException) {
        _error = _getErrorMessage(e.code);
      } else {
        _error = 'An error occurred while sending password reset email: ${e.toString()}';
      }

      notifyListeners();
      return false;
    }
  }

  /// Update user profile
  Future<bool> updateProfile({String? displayName, String? photoURL}) async {
    if (!_isFirebaseInitialized) {
      _error = 'Firebase is not initialized. Cannot update profile.';
      notifyListeners();
      return false;
    }

    if (_user == null) {
      _error = 'No user is signed in.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _user!.updateDisplayName(displayName);
      await _user!.updatePhotoURL(photoURL);

      // Reload user to get updated profile
      await _user!.reload();
      _user = _auth.currentUser;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      developer.log('Profile update error: $e', name: 'auth_service', error: e);

      if (e is FirebaseAuthException) {
        _error = _getErrorMessage(e.code);
      } else {
        _error = 'An error occurred while updating profile: ${e.toString()}';
      }

      notifyListeners();
      return false;
    }
  }

  /// Update email
  Future<bool> updateEmail(String newEmail) async {
    if (!_isFirebaseInitialized) {
      _error = 'Firebase is not initialized. Cannot update email.';
      notifyListeners();
      return false;
    }

    if (_user == null) {
      _error = 'No user is signed in.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _user!.verifyBeforeUpdateEmail(newEmail);

      // Reload user to get updated email
      await _user!.reload();
      _user = _auth.currentUser;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      developer.log('Email update error: $e', name: 'auth_service', error: e);

      if (e is FirebaseAuthException) {
        _error = _getErrorMessage(e.code);
      } else {
        _error = 'An error occurred while updating email: ${e.toString()}';
      }

      notifyListeners();
      return false;
    }
  }

  /// Update password
  Future<bool> updatePassword(String newPassword) async {
    if (!_isFirebaseInitialized) {
      _error = 'Firebase is not initialized. Cannot update password.';
      notifyListeners();
      return false;
    }

    if (_user == null) {
      _error = 'No user is signed in.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _user!.updatePassword(newPassword);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      developer.log('Password update error: $e', name: 'auth_service', error: e);

      if (e is FirebaseAuthException) {
        _error = _getErrorMessage(e.code);
      } else {
        _error = 'An error occurred while updating password: ${e.toString()}';
      }

      notifyListeners();
      return false;
    }
  }

  /// Delete user account
  Future<bool> deleteAccount() async {
    if (!_isFirebaseInitialized) {
      _error = 'Firebase is not initialized. Cannot delete account.';
      notifyListeners();
      return false;
    }

    if (_user == null) {
      _error = 'No user is signed in.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _user!.delete();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      developer.log('Account deletion error: $e', name: 'auth_service', error: e);

      if (e is FirebaseAuthException) {
        _error = _getErrorMessage(e.code);
      } else {
        _error = 'An error occurred while deleting account: ${e.toString()}';
      }

      notifyListeners();
      return false;
    }
  }

  /// Clear errors
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
