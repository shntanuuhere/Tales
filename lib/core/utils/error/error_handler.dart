import 'dart:developer' as developer;

/// Utility class for handling errors
class ErrorHandler {
  /// Handle an error and return a user-friendly error message
  static String handleError(dynamic error, {String? context}) {
    // Log the error
    developer.log(
      'Error ${context != null ? 'in $context' : ''}: $error',
      name: 'error',
      error: error,
    );
    
    // Return a user-friendly error message
    if (error.toString().contains('SocketException') ||
        error.toString().contains('Connection refused') ||
        error.toString().contains('Network is unreachable')) {
      return 'Network error. Please check your internet connection.';
    } else if (error.toString().contains('timed out')) {
      return 'Request timed out. Please try again.';
    } else if (error.toString().contains('Permission denied')) {
      return 'Permission denied. Please grant the required permissions.';
    } else if (error.toString().contains('Not found')) {
      return 'Resource not found. Please try again later.';
    } else if (error.toString().contains('Unauthorized') ||
               error.toString().contains('401')) {
      return 'Authentication error. Please sign in again.';
    } else if (error.toString().contains('Forbidden') ||
               error.toString().contains('403')) {
      return 'You do not have permission to access this resource.';
    } else if (error.toString().contains('Too many requests') ||
               error.toString().contains('429')) {
      return 'Too many requests. Please try again later.';
    } else if (error.toString().contains('Server error') ||
               error.toString().contains('500')) {
      return 'Server error. Please try again later.';
    } else if (error.toString().contains('Bad request') ||
               error.toString().contains('400')) {
      return 'Invalid request. Please try again.';
    } else {
      return 'An error occurred. Please try again.';
    }
  }
}
