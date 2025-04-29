import 'package:flutter/material.dart';

/// A widget to show download progress
class DownloadProgressIndicator extends StatelessWidget {
  /// The progress value (0.0 to 1.0)
  final double progress;
  
  /// Whether the download is complete
  final bool isComplete;
  
  /// Whether there was an error
  final bool hasError;
  
  /// Callback when the retry button is pressed
  final VoidCallback? onRetry;
  
  /// Constructor
  const DownloadProgressIndicator({
    super.key,
    required this.progress,
    this.isComplete = false,
    this.hasError = false,
    this.onRetry,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Show error state
    if (hasError) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: theme.colorScheme.error,
              size: 16,
            ),
            const SizedBox(width: 8),
            const Text('Error'),
            if (onRetry != null) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 0),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      );
    }
    
    // Show complete state
    if (isComplete) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: theme.colorScheme.primary,
              size: 16,
            ),
            const SizedBox(width: 8),
            const Text('Complete'),
          ],
        ),
      );
    }
    
    // Show progress state
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              value: progress > 0 ? progress : null,
              strokeWidth: 2,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          Text('${(progress * 100).toInt()}%'),
        ],
      ),
    );
  }
}
