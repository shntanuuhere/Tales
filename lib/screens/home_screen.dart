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
import 'settings_screen.dart';
import 'wallpaper_detail_screen.dart';
import '../services/wallpaper_service.dart';
import '../models/wallpaper.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    // Load wallpapers if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wallpaperService = Provider.of<WallpaperService>(context, listen: false);
      if (wallpaperService.wallpapers.isEmpty) {
        wallpaperService.fetchWallpapers();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final wallpaperService = Provider.of<WallpaperService>(context);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar with Search and User Profile
          SliverAppBar(
            backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
            elevation: 0,
            floating: true,
            pinned: false,
            title: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[200],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search wallpapers...',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            actions: [
              // User profile icon
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: isDark ? Colors.white : Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          // Welcome/Greeting
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discover',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    'Find the perfect wallpaper for your screen',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fade(duration: 400.ms).slideY(begin: 0.2, end: 0),

          // New and trending section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New & Trending',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fade(duration: 400.ms, delay: 200.ms).slideY(begin: 0.2, end: 0),

          // Loading state
          if (wallpaperService.isLoading)
            const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),

          // Wallpaper grid (using staggered grid for more visual interest)
          if (!wallpaperService.isLoading)
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childCount: wallpaperService.wallpapers.length,
                itemBuilder: (context, index) {
                  final wallpaper = wallpaperService.wallpapers[index];
                  return _buildWallpaperCard(
                    context,
                    wallpaper,
                    index,
                    isDark,
                    wallpaperService
                  );
                },
              ),
            ),

          // Empty state
          if (!wallpaperService.isLoading && wallpaperService.wallpapers.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.image_not_supported,
                        size: 80,
                        color: isDark ? Colors.grey[700] : Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No wallpapers found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _searchQuery.isNotEmpty
                            ? 'Try a different search term'
                            : 'Check your internet connection',
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Bottom padding for navigation bar
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }

  Widget _buildWallpaperCard(
    BuildContext context,
    Wallpaper wallpaper,
    int index,
    bool isDark,
    WallpaperService wallpaperService
  ) {
    // Calculate a random height between 180 and 280
    final double height = 200.0 + (index % 3) * 30;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WallpaperDetailScreen(wallpaper: wallpaper),
          ),
        );
      },
      child: Hero(
        tag: 'wallpaper_image_${wallpaper.id}',
        child: Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26), // 0.1 * 255 = 26
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Wallpaper image with CachedNetworkImage for better performance
                CachedNetworkImage(
                  imageUrl: wallpaper.thumbnailUrl,
                  fit: BoxFit.cover,
                  memCacheWidth: 400, // Limit memory cache size
                  memCacheHeight: 600,
                  fadeInDuration: const Duration(milliseconds: 200),
                  placeholder: (context, url) => Container(
                    color: isDark ? Colors.grey[800] : Colors.grey[300],
                    child: const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: isDark ? Colors.grey[800] : Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 40),
                  ),
                ),

                // Bottom gradient and info
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withAlpha(179), // 0.7 * 255 = 179
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            wallpaper.photographer,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            wallpaperService.toggleFavorite(wallpaper);
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(77), // 0.3 * 255 = 77
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              wallpaperService.isFavorite(wallpaper.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: wallpaperService.isFavorite(wallpaper.id)
                                  ? Colors.red
                                  : Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // "New" tag for first few items
                if (index < 3)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'NEW',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: 50 * (index % 5)))
      .fadeIn(duration: 300.ms)
      .slideY(begin: 0.1, end: 0);
  }
}
