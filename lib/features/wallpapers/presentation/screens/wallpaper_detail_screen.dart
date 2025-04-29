import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/wallpaper_provider.dart';
import '../../domain/entities/wallpaper.dart';

/// A screen to display a wallpaper in detail
class WallpaperDetailScreen extends StatelessWidget {
  final Wallpaper wallpaper;

  const WallpaperDetailScreen({
    super.key,
    required this.wallpaper,
  });

  @override
  Widget build(BuildContext context) {
    final wallpaperProvider = Provider.of<WallpaperProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Wallpaper image
          Hero(
            tag: 'wallpaper_${wallpaper.id}',
            child: CachedNetworkImage(
              imageUrl: wallpaper.url,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return Container(
                  color: Colors.black,
                  child: CachedNetworkImage(
                    imageUrl: wallpaper.thumbnailUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Container(
                        color: Colors.black,
                      ).animate()
                        .shimmer(duration: const Duration(milliseconds: 800), color: Colors.white.withAlpha(77))
                        .animate(onPlay: (controller) => controller.repeat());
                    },
                  ),
                );
              },
              errorWidget: (context, url, error) {
                return Container(
                  color: Colors.black,
                  child: const Icon(
                    Icons.broken_image,
                    size: 64,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),

          // Top controls
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(127), // 0.5 opacity
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),

                  // Favorite button
                  GestureDetector(
                    onTap: () {
                      wallpaperProvider.toggleFavorite(wallpaper);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(127), // 0.5 opacity
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        wallpaper.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: wallpaper.isFavorite ? Colors.red : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withAlpha(179), // 0.7 opacity
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Info button
                    _buildActionButton(
                      context,
                      icon: Icons.info_outline,
                      label: 'Info',
                      onTap: () {
                        _showInfoDialog(context, wallpaper);
                      },
                    ),

                    // Download button
                    _buildActionButton(
                      context,
                      icon: Icons.download_outlined,
                      label: 'Download',
                      onTap: () {
                        wallpaperProvider.downloadWallpaper(wallpaper);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Downloading wallpaper...'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),

                    // Set wallpaper button
                    _buildActionButton(
                      context,
                      icon: Icons.wallpaper_outlined,
                      label: 'Apply',
                      onTap: () {
                        _showSetWallpaperDialog(context, wallpaper, wallpaperProvider);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.black,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context, Wallpaper wallpaper) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wallpaper Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (wallpaper.description != null && wallpaper.description!.isNotEmpty) ...[
              const Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(wallpaper.description!),
              const SizedBox(height: 16),
            ],
            const Text(
              'Photographer:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(wallpaper.photographer),
            const SizedBox(height: 16),
            const Text(
              'Category:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(wallpaper.category),
            const SizedBox(height: 16),
            const Text(
              'Resolution:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('${wallpaper.width} x ${wallpaper.height}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSetWallpaperDialog(
    BuildContext context,
    Wallpaper wallpaper,
    WallpaperProvider wallpaperProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set as Wallpaper'),
        content: const Text('Where would you like to set this wallpaper?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              wallpaperProvider.setWallpaper(wallpaper, 1);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Setting as home screen wallpaper...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Home Screen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              wallpaperProvider.setWallpaper(wallpaper, 2);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Setting as lock screen wallpaper...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Lock Screen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              wallpaperProvider.setWallpaper(wallpaper, 3);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Setting as both home and lock screen wallpaper...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Both'),
          ),
        ],
      ),
    );
  }
}
