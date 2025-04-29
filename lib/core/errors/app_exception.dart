/// Base exception class for the application
class AppException implements Exception {
  /// Exception message
  final String message;

  /// Exception code
  final String? code;

  /// Original exception that caused this exception
  final dynamic originalException;

  /// Constructor
  AppException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() {
    return 'AppException: $message${code != null ? ' (code: $code)' : ''}';
  }
}

/// Network-related exceptions
class NetworkException extends AppException {
  /// Constructor
  NetworkException({
    required super.message,
    super.code,
    super.originalException,
  });
}

/// API-related exceptions
class ApiException extends AppException {
  /// HTTP status code
  final int? statusCode;

  /// Constructor
  ApiException({
    required super.message,
    this.statusCode,
    super.code,
    super.originalException,
  });

  @override
  String toString() {
    return 'ApiException: $message${statusCode != null ? ' (status: $statusCode)' : ''}${code != null ? ' (code: $code)' : ''}';
  }
}

/// Cache-related exceptions
class CacheException extends AppException {
  /// Constructor
  CacheException({
    required super.message,
    super.code,
    super.originalException,
  });
}

/// Authentication-related exceptions
class AuthException extends AppException {
  /// Constructor
  AuthException({
    required super.message,
    super.code,
    super.originalException,
  });
}
