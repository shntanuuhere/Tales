/// Exception thrown when an API request fails
class ApiException implements Exception {
  /// HTTP status code
  final int? statusCode;
  
  /// Error message
  final String message;
  
  /// Original exception
  final dynamic originalException;
  
  /// Constructor
  ApiException({
    this.statusCode,
    required this.message,
    this.originalException,
  });
  
  @override
  String toString() {
    return 'ApiException: $message${statusCode != null ? ' (Status code: $statusCode)' : ''}';
  }
}
