// Stub implementations for authentication-related classes
// These are used to satisfy the analyzer while the actual implementations
// are provided by the respective packages at runtime.
//
// IMPORTANT: These stubs should never be used in production code.
// They are only meant to be used during development and testing when
// the actual Firebase packages are not available or when running tests.
//
// In a real app, these would be replaced by the actual implementations
// from the respective packages at runtime.

import 'dart:developer' as developer;

/// Stub implementation of GoogleSignIn
///
/// This class provides stub methods that mimic the behavior of the actual
/// GoogleSignIn class from the google_sign_in package.
class GoogleSignIn {
  /// Stub implementation of signIn method
  ///
  /// Always returns null to simulate a canceled sign-in.
  /// In a real implementation, this would return a GoogleSignInAccount
  /// if the sign-in was successful, or null if it was canceled.
  Future<GoogleSignInAccount?> signIn() async {
    developer.log('WARNING: Using stub GoogleSignIn.signIn()', name: 'auth_stubs');
    return null;
  }

  /// Stub implementation of signOut method
  ///
  /// Does nothing in this stub implementation.
  Future<void> signOut() async {
    developer.log('WARNING: Using stub GoogleSignIn.signOut()', name: 'auth_stubs');
  }
}

/// Stub implementation of GoogleSignInAccount
///
/// This class provides stub properties that mimic the behavior of the actual
/// GoogleSignInAccount class from the google_sign_in package.
class GoogleSignInAccount {
  /// Stub email property
  final String email = 'stub@example.com';

  /// Stub id property
  final String id = 'stub_user_id';

  /// Stub displayName property
  final String displayName = 'Stub User';

  /// Stub photoUrl property
  final String photoUrl = 'https://via.placeholder.com/150';

  /// Stub authentication getter
  ///
  /// Returns a stub GoogleSignInAuthentication object.
  Future<GoogleSignInAuthentication> get authentication async {
    developer.log('WARNING: Using stub GoogleSignInAccount.authentication', name: 'auth_stubs');
    return GoogleSignInAuthentication();
  }
}

/// Stub implementation of GoogleSignInAuthentication
///
/// This class provides stub properties that mimic the behavior of the actual
/// GoogleSignInAuthentication class from the google_sign_in package.
class GoogleSignInAuthentication {
  /// Stub accessToken property
  final String? accessToken = 'stub_access_token';

  /// Stub idToken property
  final String? idToken = 'stub_id_token';
}

/// Stub implementation of LocalAuthentication
///
/// This class provides stub methods that mimic the behavior of the actual
/// LocalAuthentication class from the local_auth package.
class LocalAuthentication {
  /// Stub canCheckBiometrics property
  ///
  /// Always returns false to indicate biometrics are not available.
  Future<bool> canCheckBiometrics = Future.value(false);

  /// Stub isDeviceSupported method
  ///
  /// Always returns false to indicate the device does not support biometrics.
  Future<bool> isDeviceSupported() async {
    developer.log('WARNING: Using stub LocalAuthentication.isDeviceSupported()', name: 'auth_stubs');
    return false;
  }

  /// Stub authenticate method
  ///
  /// Always returns false to indicate authentication failed.
  /// In a real implementation, this would attempt to authenticate the user
  /// using biometrics and return true if successful.
  Future<bool> authenticate({
    required String localizedReason,
    AuthenticationOptions options = const AuthenticationOptions(),
  }) async {
    developer.log('WARNING: Using stub LocalAuthentication.authenticate()', name: 'auth_stubs');
    developer.log('  localizedReason: $localizedReason', name: 'auth_stubs');
    developer.log('  options: stickyAuth=${options.stickyAuth}, biometricOnly=${options.biometricOnly}',
      name: 'auth_stubs');
    return false;
  }

  /// Stub getAvailableBiometrics method
  ///
  /// Always returns an empty list to indicate no biometrics are available.
  Future<List<BiometricType>> getAvailableBiometrics() async {
    developer.log('WARNING: Using stub LocalAuthentication.getAvailableBiometrics()', name: 'auth_stubs');
    return [];
  }
}

/// Stub implementation of AuthenticationOptions
///
/// This class provides stub properties that mimic the behavior of the actual
/// AuthenticationOptions class from the local_auth package.
class AuthenticationOptions {
  /// Whether to keep the authentication session open
  final bool stickyAuth;

  /// Whether to use only biometric authentication
  final bool biometricOnly;

  /// Constructor for AuthenticationOptions
  const AuthenticationOptions({
    this.stickyAuth = false,
    this.biometricOnly = false,
  });

  @override
  String toString() => 'AuthenticationOptions(stickyAuth: $stickyAuth, biometricOnly: $biometricOnly)';
}

/// Stub implementation of BiometricType enum
///
/// This enum mimics the behavior of the actual BiometricType enum
/// from the local_auth package.
enum BiometricType {
  /// Face authentication (e.g., Face ID)
  face,

  /// Fingerprint authentication (e.g., Touch ID)
  fingerprint,

  /// Iris authentication
  iris,

  /// Weak biometric authentication
  weak,

  /// Strong biometric authentication
  strong,
}