import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../wallpapers/presentation/providers/wallpaper_provider.dart';
import '../../domain/entities/category.dart';
import '../../../../presentation/common/widgets/app_header.dart';
import '../../../wallpapers/presentation/widgets/wallpaper_grid.dart';

/// A screen to display wallpapers for a specific category
class CategoryWallpapersScreen extends StatefulWidget {
  final Category category;

  const CategoryWallpapersScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryWallpapersScreen> createState() => _CategoryWallpapersScreenState();
}

class _CategoryWallpapersScreenState extends State<CategoryWallpapersScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Add scroll listener for pagination
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 500) {
      final wallpaperProvider = Provider.of<WallpaperProvider>(context, listen: false);
      if (!wallpaperProvider.isLoading && !wallpaperProvider.isLoadingMore && wallpaperProvider.hasMoreWallpapers) {
        wallpaperProvider.fetchWallpapersByCategory(widget.category.name);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wallpaperProvider = Provider.of<WallpaperProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Header with back button
            AppHeader(
              title: widget.category.name,
              showProfileIcon: false,
              onBackPressed: () {
                Navigator.pop(context);
              },
            ),

            // Wallpapers grid
            Expanded(
              child: WallpaperGrid(
                wallpapers: wallpaperProvider.wallpapers,
                hasMoreWallpapers: wallpaperProvider.hasMoreWallpapers,
                isLoading: wallpaperProvider.isLoading && wallpaperProvider.wallpapers.isEmpty,
                onRefresh: () => wallpaperProvider.fetchWallpapersByCategory(widget.category.name),
                scrollController: _scrollController,
                categoryName: widget.category.name,
              ),
            ),
          ],
        ),
      ),
    );
  }


}
