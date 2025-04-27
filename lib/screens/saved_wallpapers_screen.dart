import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tales/services/wallpaper_service.dart';
import 'package:tales/models/wallpaper.dart';
import 'package:tales/screens/wallpaper_detail_screen.dart';

class SavedWallpapersScreen extends StatefulWidget {
  const SavedWallpapersScreen({super.key});

  @override
  State<SavedWallpapersScreen> createState() => _SavedWallpapersScreenState();
}

class _SavedWallpapersScreenState extends State<SavedWallpapersScreen> {
  List<Wallpaper> _favoriteWallpapers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });

    final wallpaperService = Provider.of<WallpaperService>(context, listen: false);
    final favorites = await wallpaperService.getFavoriteWallpapers();

    setState(() {
      _favoriteWallpapers = favorites;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wallpaperService = Provider.of<WallpaperService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteWallpapers.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 64),
                      SizedBox(height: 16),
                      Text('No saved wallpapers'),
                      SizedBox(height: 8),
                      Text(
                        'Wallpapers you save will appear here',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _favoriteWallpapers.length,
                  itemBuilder: (context, index) {
                    final wallpaper = _favoriteWallpapers[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WallpaperDetailScreen(wallpaper: wallpaper),
                          ),
                        ).then((_) => _loadFavorites()); // Refresh on return
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Wallpaper image
                            Image.network(
                              wallpaper.thumbnailUrl,
                              fit: BoxFit.cover,
                            ),
                            // Favorite icon
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  wallpaperService.toggleFavorite(wallpaper);
                                  _loadFavorites(); // Refresh after toggle
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            // Category info
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withAlpha(179), // 0.7 * 255 = 179
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: const Text(
                                  'Category',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}