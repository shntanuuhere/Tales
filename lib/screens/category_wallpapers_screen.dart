import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tales/services/wallpaper_service.dart';
import 'package:tales/models/wallpaper.dart';
import 'package:tales/screens/wallpaper_detail_screen.dart';

class CategoryWallpapersScreen extends StatefulWidget {
  final String category;

  const CategoryWallpapersScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryWallpapersScreen> createState() => _CategoryWallpapersScreenState();
}

class _CategoryWallpapersScreenState extends State<CategoryWallpapersScreen> {
  List<Wallpaper> _wallpapers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWallpapers();
  }

  Future<void> _loadWallpapers() async {
    setState(() {
      _isLoading = true;
    });

    final wallpaperService = Provider.of<WallpaperService>(context, listen: false);
    final wallpapers = await wallpaperService.getWallpapersByCategory(widget.category);

    setState(() {
      _wallpapers = wallpapers;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wallpaperService = Provider.of<WallpaperService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _wallpapers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.image_not_supported, size: 64),
                      const SizedBox(height: 16),
                      Text('No wallpapers found in ${widget.category}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadWallpapers,
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
                )
              : MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  padding: const EdgeInsets.all(8),
                  // Use cacheExtent to improve scrolling performance
                  cacheExtent: 500,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemCount: _wallpapers.length,
                  itemBuilder: (context, index) {
                    final wallpaper = _wallpapers[index];
                    // Use RepaintBoundary to optimize rendering
                    return RepaintBoundary(
                      child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WallpaperDetailScreen(wallpaper: wallpaper),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            // Wallpaper image - optimized for performance
                            CachedNetworkImage(
                              imageUrl: wallpaper.thumbnailUrl,
                              fit: BoxFit.cover,
                              memCacheWidth: 400, // Limit memory cache size
                              memCacheHeight: 600,
                              fadeInDuration: const Duration(milliseconds: 200), // Faster fade-in
                              placeholder: (context, url) => Container(
                                color: Colors.grey.shade200,
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.broken_image, size: 40),
                              ),
                            ),
                            // Favorite icon
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () async {
                                  // Toggle favorite and let the provider handle the UI update
                                  await wallpaperService.toggleFavorite(wallpaper);
                                  // No need to call setState as we're using Provider
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface.withAlpha(77),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    wallpaperService.isFavorite(wallpaper.id)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: wallpaperService.isFavorite(wallpaper.id)
                                        ? Theme.of(context).colorScheme.error
                                        : Theme.of(context).colorScheme.onSurface,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            // Category label
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface.withAlpha(128),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  wallpaper.category,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    );
                  },
                ),
    );
  }
}