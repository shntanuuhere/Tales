import 'package:flutter/material.dart';

/// A reusable app header widget with title and optional user profile icon
class AppHeader extends StatelessWidget {
  /// The title to display
  final String title;
  
  /// Whether to show the user profile icon
  final bool showProfileIcon;
  
  /// Callback for when the profile icon is tapped
  final VoidCallback? onProfileTap;
  
  /// Optional back button callback
  final VoidCallback? onBackPressed;

  /// Constructor
  const AppHeader({
    super.key,
    required this.title,
    this.showProfileIcon = true,
    this.onProfileTap,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          // Back button if provided
          if (onBackPressed != null) ...[
            GestureDetector(
              onTap: onBackPressed,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: theme.colorScheme.onSurface,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
          
          // Title
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // User profile icon
          if (showProfileIcon)
            GestureDetector(
              onTap: onProfileTap ?? () {
                Navigator.pushNamed(context, '/settings');
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: theme.colorScheme.onSurface,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
