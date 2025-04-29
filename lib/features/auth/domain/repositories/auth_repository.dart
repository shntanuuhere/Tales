import 'package:firebase_auth/firebase_auth.dart';

/// Interface for authentication repository
abstract class AuthRepository {
  /// Current user
  User? get user;
  
  /// Whether the user is authenticated
  bool get isAuthenticated;
  
  /// Whether authentication is in progress
  bool get isLoading;
  
  /// Error message
  String? get errorMessage;
  
  /// Sign in with Google
  Future<bool> signInWithGoogle();
  
  /// Sign out
  Future<bool> signOut();
  
  /// Clear error message
  void clearError();
}
