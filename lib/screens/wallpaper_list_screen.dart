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
import '../services/wallpaper_service.dart';
import '../models/wallpaper.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'wallpaper_detail_screen.dart';

class WallpaperListScreen extends StatefulWidget {
  final String category;

  const WallpaperListScreen({
    super.key,
    required this.category,
  });

  @override
  State<WallpaperListScreen> createState() => _WallpaperListScreenState();
}

class _WallpaperListScreenState extends State<WallpaperListScreen> {
  bool _isLoading = true;
  List<Wallpaper> _wallpapers = [];

  @override
  void initState() {
    super.initState();
    _loadWallpapers();
  }

  Future<void> _loadWallpapers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final wallpaperService = Provider.of<WallpaperService>(context, listen: false);
      final wallpapers = await wallpaperService.getWallpapersByCategory(widget.category);

      setState(() {
        _wallpapers = wallpapers;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load wallpapers: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: RefreshIndicator(
        onRefresh: _loadWallpapers,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            SliverAppBar(
              backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
              floating: true,
              pinned: false,
              elevation: 0,
              title: Text(
                widget.category,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: isDark ? Colors.white : Colors.black,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),

            // Loading indicator
            if (_isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_wallpapers.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported_outlined,
                        size: 64,
                        color: isDark ? Colors.grey[700] : Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No wallpapers found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadWallpapers,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childCount: _wallpapers.length,
                  itemBuilder: (context, index) {
                    return _buildWallpaperItem(
                      context,
                      _wallpapers[index],
                      index,
                      isDark,
                    );
                  },
                ),
              ),

            // Bottom padding for navigation
            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWallpaperItem(
    BuildContext context,
    Wallpaper wallpaper,
    int index,
    bool isDark,
  ) {
    // Calculate a random height between 150 and 280
    final height = 150.0 + (index % 3) * 65.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WallpaperDetailScreen(
              wallpaper: wallpaper,
            ),
          ),
        );
      },
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
              // Wallpaper image
              Image.network(
                wallpaper.thumbnailUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),

              // Bottom gradient
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
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
                ),
              ),

              // Wallpaper info
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
                      Expanded(
                        child: Text(
                          wallpaper.photographer,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),

                      // Favorite button
                      GestureDetector(
                        onTap: () {
                          final wallpaperService = Provider.of<WallpaperService>(context, listen: false);
                          wallpaperService.toggleFavorite(wallpaper);
                          setState(() {});
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(77), // 0.3 * 255 = 77
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            wallpaper.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: wallpaper.isFavorite
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
            ],
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: 50 * index))
      .fadeIn(duration: 400.ms)
      .slideY(begin: 0.1, end: 0);
  }
}
