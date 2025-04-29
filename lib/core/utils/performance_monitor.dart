import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A utility class for monitoring performance in the app
class PerformanceMonitor {
  /// Private constructor to prevent instantiation
  PerformanceMonitor._();

  /// Map to store start times for different operations
  static final Map<String, int> _startTimes = {};

  /// Start timing an operation
  static void startTiming(String operationName) {
    _startTimes[operationName] = DateTime.now().millisecondsSinceEpoch;
  }

  /// End timing an operation and log the result
  static void endTiming(String operationName) {
    final startTime = _startTimes[operationName];
    if (startTime == null) {
      developer.log('Error: No start time found for operation: $operationName',
          name: 'performance');
      return;
    }

    final endTime = DateTime.now().millisecondsSinceEpoch;
    final duration = endTime - startTime;

    developer.log('$operationName completed in $duration ms',
        name: 'performance');

    // Remove the start time from the map
    _startTimes.remove(operationName);

    // Log a warning if the operation took too long
    if (duration > 500) {
      developer.log('Warning: $operationName took $duration ms to complete',
          name: 'performance', level: 900);
    }
  }

  /// Wrap a function with timing
  static Future<T> timeAsync<T>(String operationName, Future<T> Function() operation) async {
    startTiming(operationName);
    try {
      final result = await operation();
      endTiming(operationName);
      return result;
    } catch (e) {
      endTiming(operationName);
      rethrow;
    }
  }

  /// Wrap a synchronous function with timing
  static T timeSync<T>(String operationName, T Function() operation) {
    startTiming(operationName);
    try {
      final result = operation();
      endTiming(operationName);
      return result;
    } catch (e) {
      endTiming(operationName);
      rethrow;
    }
  }

  /// Log memory usage
  static void logMemoryUsage() {
    if (kDebugMode) {
      developer.log('Memory usage: ${(WidgetsBinding.instance.runtimeType)}',
          name: 'performance');
    }
  }
}
