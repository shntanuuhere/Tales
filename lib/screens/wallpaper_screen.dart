// Copyright 2025 Shantanu Sen Gupta
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/wallpaper_service.dart';
import '../models/wallpaper.dart';
import 'wallpaper_detail_screen.dart';
import 'categories_screen.dart';
import 'saved_wallpapers_screen.dart';
import 'liked_wallpapers_screen.dart';
import 'settings_screen.dart';

class WallpaperScreen extends StatefulWidget {
  const WallpaperScreen({super.key});

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    // Use Future.microtask to avoid potential memory leaks
    Future.microtask(() {
      if (mounted) {
        final wallpaperService = Provider.of<WallpaperService>(context, listen: false);
        // Use useDelay=false in tests to avoid timer issues
        wallpaperService.fetchWallpapers(useDelay: !_isInTest(), refresh: true);
      }
    });

    // Add scroll listener for infinite scrolling
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 500) {
      _loadMoreWallpapers();
    }
  }

  void _loadMoreWallpapers() {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final wallpaperService = Provider.of<WallpaperService>(context, listen: false);
    if (wallpaperService.hasMoreWallpapers && !wallpaperService.isLoading) {
      wallpaperService.fetchWallpapers().then((_) {
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
        }
      });
    } else {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  // Helper method to detect if we're running in a test environment
  bool _isInTest() {
    // A simple way to detect test environment without relying on Zone
    return const bool.fromEnvironment('FLUTTER_TEST', defaultValue: false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallpaperService = Provider.of<WallpaperService>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Tales',
                style: TextStyle(
            fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _showDrawer(context);
            },
          ),
            ),
            actions: [
              IconButton(
            icon: const Icon(Icons.settings),
                onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: wallpaperService.isLoading && wallpaperService.wallpapers.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () async {
                    await wallpaperService.fetchWallpapers(refresh: true);
                  },
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    // Use cacheExtent to improve scrolling performance
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
                    // Reduce the number of items rendered at once for better performance
                    itemCount: wallpaperService.wallpapers.length + (wallpaperService.hasMoreWallpapers ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Show loading indicator at the end
                      if (index == wallpaperService.wallpapers.length) {
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

                      final wallpaper = wallpaperService.wallpapers[index];
                      // Use RepaintBoundary to optimize rendering
                      return RepaintBoundary(
                        child: _buildWallpaperCard(context, wallpaper),
                      );
                    },
                  ),
                ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(
                  icon: Icons.cached,
                  onTap: () {
                    wallpaperService.fetchWallpapers(refresh: true);
                  },
                ),
                const SizedBox(width: 16),
                _buildActionButton(
                  icon: Icons.download,
                  onTap: () {
                    if (wallpaperService.wallpapers.isNotEmpty) {
                      final wallpaper = wallpaperService.wallpapers[0];
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Downloading ${wallpaper.photographer}\'s wallpaper')),
                      );
                    }
                  },
                ),
                const SizedBox(width: 16),
                _buildActionButton(
                  icon: Icons.favorite_border,
                  onTap: () {
                    if (wallpaperService.wallpapers.isNotEmpty) {
                      final wallpaper = wallpaperService.wallpapers[0];
                      wallpaperService.toggleFavorite(wallpaper);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        icon: Icon(icon, color: theme.colorScheme.onSurface),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildWallpaperCard(BuildContext context, Wallpaper wallpaper) {
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
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Wallpaper image - optimized for performance
              CachedNetworkImage(
                imageUrl: wallpaper.thumbnailUrl, // Use smaller thumbnail image
                fit: BoxFit.cover,
                memCacheWidth: 400, // Limit memory cache size
                memCacheHeight: 600,
                fadeInDuration: const Duration(milliseconds: 200), // Faster fade-in
                placeholder: (context, url) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                ),
                errorWidget: (context, url, error) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  child: Icon(
                    Icons.broken_image,
                    size: 40,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),

              // Favorite button
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(77),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      wallpaper.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: wallpaper.isFavorite ? Colors.red : Colors.white,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      final wallpaperService = Provider.of<WallpaperService>(context, listen: false);
                      wallpaperService.toggleFavorite(wallpaper);
                    },
                  ),
                ),
              ),

              // Photographer name
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withAlpha(179),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Category label
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(102), // 0.4 * 255 = 102
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          wallpaper.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Photographer name
                      Text(
                        wallpaper.photographer,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              color: Color(0x80000000), // 0.5 opacity black
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.grid_view),
              title: const Text('Categories'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoriesScreen()),
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Saved Wallpapers'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SavedWallpapersScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.thumb_up),
              title: const Text('Liked Wallpapers'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LikedWallpapersScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}