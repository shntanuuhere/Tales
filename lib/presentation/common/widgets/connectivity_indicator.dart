import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/network/connectivity_service.dart';

/// A widget that shows the current connectivity status
class ConnectivityIndicator extends StatelessWidget {
  /// Constructor
  const ConnectivityIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityService>(
      builder: (context, connectivityService, child) {
        // If connected, don't show anything
        if (connectivityService.isConnected) {
          return const SizedBox.shrink();
        }

        // Show offline indicator
        return Container(
          width: double.infinity,
          color: Colors.red.shade700,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off,
                color: Colors.white,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'You are offline. Some features may be limited.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A widget that shows a snackbar when connectivity changes
class ConnectivitySnackbar extends StatefulWidget {
  /// The child widget
  final Widget child;

  /// Constructor
  const ConnectivitySnackbar({
    super.key,
    required this.child,
  });

  @override
  State<ConnectivitySnackbar> createState() => _ConnectivitySnackbarState();
}

class _ConnectivitySnackbarState extends State<ConnectivitySnackbar> {
  ConnectivityService? _connectivityService;
  bool _wasConnected = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get connectivity service
    final connectivityService = Provider.of<ConnectivityService>(context);

    // If connectivity service changed, update subscription
    if (_connectivityService != connectivityService) {
      _connectivityService = connectivityService;
      _wasConnected = connectivityService.isConnected;

      // Listen for connectivity changes
      connectivityService.addListener(_onConnectivityChanged);
    }
  }

  @override
  void dispose() {
    // Remove listener
    _connectivityService?.removeListener(_onConnectivityChanged);
    super.dispose();
  }

  /// Handle connectivity changes
  void _onConnectivityChanged() {
    if (!mounted) return;

    final isConnected = _connectivityService?.isConnected ?? false;

    // Only show snackbar when connectivity changes
    if (isConnected != _wasConnected) {
      _wasConnected = isConnected;

      // Show snackbar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isConnected ? Icons.wifi : Icons.wifi_off,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                isConnected
                    ? 'You are back online'
                    : 'You are offline. Some features may be limited.',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          backgroundColor: isConnected ? Colors.green.shade700 : Colors.red.shade700,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
