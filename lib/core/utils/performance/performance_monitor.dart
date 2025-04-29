import 'dart:developer' as developer;

/// Utility class for monitoring performance
class PerformanceMonitor {
  /// Start time of the operation
  final DateTime _startTime;

  /// Name of the operation being monitored
  final String _operationName;

  /// Map of operation names to start times
  static final Map<String, DateTime> _timings = {};

  /// Constructor
  PerformanceMonitor(this._operationName) : _startTime = DateTime.now() {
    developer.log('Starting operation: $_operationName', name: 'performance');
  }

  /// Stop monitoring and log the elapsed time
  void stop() {
    final endTime = DateTime.now();
    final duration = endTime.difference(_startTime);
    developer.log(
      'Operation $_operationName completed in ${duration.inMilliseconds}ms',
      name: 'performance',
    );
  }

  /// Create a new instance with the given operation name
  static PerformanceMonitor start(String operationName) {
    return PerformanceMonitor(operationName);
  }

  /// Start timing an operation
  static void startTiming(String operationName) {
    _timings[operationName] = DateTime.now();
    developer.log('Starting timing: $operationName', name: 'performance');
  }

  /// End timing an operation and log the elapsed time
  static void endTiming(String operationName) {
    final startTime = _timings[operationName];
    if (startTime == null) {
      developer.log('Error: No start time found for operation $operationName', name: 'performance');
      return;
    }

    final endTime = DateTime.now();
    final duration = endTime.difference(startTime);
    developer.log(
      'Operation $operationName completed in ${duration.inMilliseconds}ms',
      name: 'performance',
    );

    _timings.remove(operationName);
  }

  /// Time an async operation and return its result
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
}
