import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';

/// A utility class for handling errors in the app
class ErrorHandler {
  /// Private constructor to prevent instantiation
  ErrorHandler._();

  /// Handle an error and return a user-friendly message
  static String handleError(dynamic error, {String? context}) {
    // Log the error
    developer.log(
      'Error: ${error.toString()}',
      name: 'error_handler',
      error: error,
      stackTrace: error is Error ? error.stackTrace : StackTrace.current,
    );

    // Return a user-friendly message based on the error type
    if (error is SocketException || error is TimeoutException) {
      return 'Network error. Please check your connection and try again.';
    } else if (error is FormatException) {
      return 'Data format error. Please try again later.';
    } else if (error is HttpException) {
      return 'Server error. Please try again later.';
    } else {
      return 'An unexpected error occurred. Please try again later.';
    }
  }

  /// Show an error snackbar
  static void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Theme.of(context).colorScheme.onError,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Run a function with error handling
  static Future<T?> run<T>(
    Future<T> Function() function, {
    String? context,
    Function(String)? onError,
  }) async {
    try {
      return await function();
    } catch (e) {
      final message = handleError(e, context: context);
      if (onError != null) {
        onError(message);
      }
      return null;
    }
  }
}
