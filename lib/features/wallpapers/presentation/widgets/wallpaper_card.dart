import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/wallpaper_provider.dart';
import '../providers/favorites_provider.dart';
import '../../domain/entities/wallpaper.dart';
import '../screens/wallpaper_detail_screen.dart';

/// A reusable widget for displaying a wallpaper card
class WallpaperCard extends StatelessWidget {
  /// The wallpaper to display
  final Wallpaper wallpaper;

  /// Whether this card is in the favorites screen
  final bool isInFavorites;

  /// Optional category name to display
  final String? categoryName;

  /// Constructor
  const WallpaperCard({
    super.key,
    required this.wallpaper,
    this.isInFavorites = false,
    this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wallpaperProvider = Provider.of<WallpaperProvider>(context, listen: false);
    final favoritesProvider = isInFavorites
        ? Provider.of<FavoritesProvider>(context, listen: false)
        : null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WallpaperDetailScreen(wallpaper: wallpaper),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Wallpaper image
              Hero(
                tag: 'wallpaper_${wallpaper.id}',
                child: CachedNetworkImage(
                  imageUrl: wallpaper.thumbnailUrl,
                  fit: BoxFit.cover,
                  memCacheWidth: 300,
                  memCacheHeight: 300,
                  fadeInDuration: const Duration(milliseconds: 200),
                  placeholder: (context, url) {
                    return Container(
                      color: theme.colorScheme.surfaceContainerLow,
                    ).animate()
                      .shimmer(duration: const Duration(milliseconds: 800), color: Colors.white.withAlpha(127))
                      .animate(onPlay: (controller) => controller.repeat());
                  },
                  errorWidget: (context, url, error) {
                    return Container(
                      color: theme.colorScheme.surfaceContainerLow,
                      child: const Icon(
                        Icons.broken_image,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),

              // Category label
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(128),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    categoryName ?? wallpaper.category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // Favorite button
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    if (isInFavorites && favoritesProvider != null) {
                      favoritesProvider.toggleFavorite(wallpaper);
                    } else {
                      wallpaperProvider.toggleFavorite(wallpaper);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(128),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      wallpaper.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: wallpaper.isFavorite ? Colors.red : Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: const Duration(milliseconds: 300)),
    );
  }
}
