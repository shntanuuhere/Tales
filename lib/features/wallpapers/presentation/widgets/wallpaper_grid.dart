import 'package:flutter/material.dart';

import '../../domain/entities/wallpaper.dart';
import 'wallpaper_card.dart';

/// A reusable widget for displaying a grid of wallpapers
class WallpaperGrid extends StatelessWidget {
  /// The list of wallpapers to display
  final List<Wallpaper> wallpapers;

  /// Whether more wallpapers are available
  final bool hasMoreWallpapers;

  /// Whether the grid is loading
  final bool isLoading;

  /// Callback for refreshing the grid
  final Future<void> Function() onRefresh;

  /// Scroll controller for pagination
  final ScrollController? scrollController;

  /// Whether this grid is in the favorites screen
  final bool isInFavorites;

  /// Optional category name to display on wallpaper cards
  final String? categoryName;

  /// Constructor
  const WallpaperGrid({
    super.key,
    required this.wallpapers,
    this.hasMoreWallpapers = false,
    this.isLoading = false,
    required this.onRefresh,
    this.scrollController,
    this.isInFavorites = false,
    this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && wallpapers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: GridView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        cacheExtent: 500,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: wallpapers.length + (hasMoreWallpapers ? 1 : 0),
        itemBuilder: (context, index) {
          // Show loading indicator at the end
          if (hasMoreWallpapers && index == wallpapers.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
            );
          }

          final wallpaper = wallpapers[index];
          return WallpaperCard(
            wallpaper: wallpaper,
            isInFavorites: isInFavorites,
            categoryName: categoryName,
          );
        },
      ),
    );
  }
}
