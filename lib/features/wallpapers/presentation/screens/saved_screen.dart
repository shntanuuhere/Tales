import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../../../../presentation/common/widgets/app_header.dart';
import '../widgets/wallpaper_grid.dart';

/// A screen to display saved/favorite wallpapers
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Header
            AppHeader(
              title: 'Saved',
              onProfileTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),

            // Favorites grid
            Expanded(
              child: favoritesProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : favoritesProvider.favorites.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 64,
                            color: theme.colorScheme.onSurfaceVariant.withAlpha(127), // 0.5 opacity
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No saved wallpapers yet',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant.withAlpha(179), // 0.7 opacity
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the heart icon on any wallpaper to save it',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant.withAlpha(127), // 0.5 opacity
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : WallpaperGrid(
                      wallpapers: favoritesProvider.favorites,
                      isLoading: favoritesProvider.isLoading,
                      onRefresh: () => favoritesProvider.loadFavorites(),
                      isInFavorites: true,
                    ),
            ),
          ],
        ),
      ),
    );
  }


}
