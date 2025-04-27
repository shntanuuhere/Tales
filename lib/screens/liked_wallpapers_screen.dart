import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tales/services/wallpaper_service.dart';
import 'package:tales/widgets/wallpaper_card.dart';

class LikedWallpapersScreen extends StatefulWidget {
  const LikedWallpapersScreen({super.key});

  @override
  State<LikedWallpapersScreen> createState() => _LikedWallpapersScreenState();
}

class _LikedWallpapersScreenState extends State<LikedWallpapersScreen> {
  @override
  void initState() {
    super.initState();
    // Load favorite wallpapers when the screen is opened
    Future.microtask(() {
      if (mounted) {
        final wallpaperService = Provider.of<WallpaperService>(context, listen: false);
        wallpaperService.getFavoriteWallpapers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Wallpapers'),
        elevation: 0,
      ),
      body: Consumer<WallpaperService>(
        builder: (context, wallpaperService, child) {
          if (wallpaperService.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final favorites = wallpaperService.wallpapers.where(
            (wallpaper) => wallpaperService.isFavorite(wallpaper.id)
          ).toList();

          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No liked wallpapers yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the heart icon on wallpapers you like',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final wallpaper = favorites[index];
              return WallpaperCard(
                wallpaper: wallpaper,
                borderRadius: 12,
              );
            },
          );
        },
      ),
    );
  }
}
