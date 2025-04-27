import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tales/models/wallpaper.dart';
import 'package:tales/services/wallpaper_service.dart';
import 'package:tales/screens/wallpaper_detail_screen.dart';

class WallpaperCard extends StatelessWidget {
  final Wallpaper wallpaper;
  final bool showCategory;
  final bool showFavoriteButton;
  final double borderRadius;
  final VoidCallback? onTap;

  const WallpaperCard({
    super.key,
    required this.wallpaper,
    this.showCategory = true,
    this.showFavoriteButton = true,
    this.borderRadius = 12.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final wallpaperService = Provider.of<WallpaperService>(context);
    final isFavorite = wallpaperService.isFavorite(wallpaper.id);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust font size and padding based on available width
        final isSmallScreen = constraints.maxWidth < 200;
        final fontSize = isSmallScreen ? 10.0 : 12.0;
        final iconSize = isSmallScreen ? 16.0 : 20.0;
        final padding = isSmallScreen ? 6.0 : 8.0;

        return GestureDetector(
          onTap: onTap ?? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WallpaperDetailScreen(wallpaper: wallpaper),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Stack(
              fit: StackFit.expand,
              children: [
            // Wallpaper image
            Hero(
              tag: 'wallpaper_${wallpaper.id}',
              child: CachedNetworkImage(
                imageUrl: wallpaper.thumbnailUrl,
                fit: BoxFit.cover,
                memCacheWidth: 300, // Limit memory cache size
                memCacheHeight: 300,
                maxWidthDiskCache: 600, // Limit disk cache size
                maxHeightDiskCache: 600,
                fadeInDuration: const Duration(milliseconds: 200), // Faster fade-in
                placeholder: (context, url) {
                  return Container(
                    color: Colors.grey.shade200,
                  ).animate()
                    .shimmer(duration: const Duration(milliseconds: 800), color: Colors.white.withAlpha(127))
                    .animate(onPlay: (controller) => controller.repeat());
                },
                errorWidget: (context, url, error) {
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.broken_image, size: 40),
                  );
                },
              ),
            ),

            // Category label
            if (showCategory)
              Positioned(
                bottom: padding,
                left: padding,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(153), // 0.6 * 255 = 153
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    wallpaper.category,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            // Favorite button
            if (showFavoriteButton)
              Positioned(
                top: padding,
                right: padding,
                child: GestureDetector(
                  onTap: () {
                    wallpaperService.toggleFavorite(wallpaper);
                  },
                  child: Container(
                    padding: EdgeInsets.all(padding / 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(153), // 0.6 * 255 = 153
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: const Duration(milliseconds: 300));
      },
    );
  }
}