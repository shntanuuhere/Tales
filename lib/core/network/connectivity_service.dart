import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Service for monitoring network connectivity
class ConnectivityService extends ChangeNotifier {
  /// Connectivity instance
  final Connectivity _connectivity = Connectivity();
  
  /// Current connectivity status
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  
  /// Subscription to connectivity changes
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  
  /// Constructor
  ConnectivityService() {
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
  
  /// Get current connectivity status
  ConnectivityResult get connectionStatus => _connectionStatus;
  
  /// Check if device is connected to the internet
  bool get isConnected => _connectionStatus != ConnectivityResult.none;
  
  /// Check if device is connected to WiFi
  bool get isWifi => _connectionStatus == ConnectivityResult.wifi;
  
  /// Check if device is connected to mobile data
  bool get isMobile => _connectionStatus == ConnectivityResult.mobile;
  
  /// Initialize connectivity
  Future<void> _initConnectivity() async {
    try {
      _connectionStatus = await _connectivity.checkConnectivity();
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to get connectivity: $e');
    }
  }
  
  /// Update connection status
  void _updateConnectionStatus(ConnectivityResult result) {
    if (_connectionStatus != result) {
      _connectionStatus = result;
      notifyListeners();
    }
  }
  
  /// Check current connectivity
  Future<bool> checkConnectivity() async {
    try {
      _connectionStatus = await _connectivity.checkConnectivity();
      notifyListeners();
      return isConnected;
    } catch (e) {
      debugPrint('Failed to check connectivity: $e');
      return false;
    }
  }
  
  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
