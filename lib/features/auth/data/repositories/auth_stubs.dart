/// Stub implementation of LocalAuthentication for platforms that don't support it
class LocalAuthentication {
  /// Check if biometrics is available
  Future<bool> canCheckBiometrics = Future.value(false);
  
  /// Check if device supports biometrics
  Future<bool> isDeviceSupported() async => false;
  
  /// Authenticate with biometrics
  Future<bool> authenticate({
    required String localizedReason,
    required AuthenticationOptions options,
  }) async => false;
}

/// Stub implementation of AuthenticationOptions
class AuthenticationOptions {
  /// Whether to use sticky authentication
  final bool stickyAuth;
  
  /// Whether to use biometric authentication only
  final bool biometricOnly;
  
  /// Constructor
  const AuthenticationOptions({
    this.stickyAuth = false,
    this.biometricOnly = false,
  });
}
