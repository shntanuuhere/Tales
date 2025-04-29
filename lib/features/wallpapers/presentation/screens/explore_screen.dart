import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/wallpaper_provider.dart';
import '../../../../presentation/common/widgets/app_header.dart';
import '../widgets/wallpaper_grid.dart';

/// An explore screen with tabs for Popular and New Walls
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Add scroll listener for pagination
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 500) {
      final wallpaperProvider = Provider.of<WallpaperProvider>(context, listen: false);
      if (!wallpaperProvider.isLoading && !wallpaperProvider.isLoadingMore && wallpaperProvider.hasMoreWallpapers) {
        wallpaperProvider.fetchWallpapers();
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
            // App Header
            AppHeader(
              title: 'Explore',
              onProfileTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),

            // Tab Bar
            TabBar(
              controller: _tabController,
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
              indicatorColor: theme.colorScheme.primary,
              tabs: const [
                Tab(text: 'Popular'),
                Tab(text: 'New Walls'),
              ],
            ),

            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Popular Tab
                  WallpaperGrid(
                    wallpapers: wallpaperProvider.wallpapers,
                    hasMoreWallpapers: wallpaperProvider.hasMoreWallpapers,
                    isLoading: wallpaperProvider.isLoading,
                    onRefresh: () => wallpaperProvider.fetchWallpapers(refresh: true),
                    scrollController: _scrollController,
                  ),

                  // New Walls Tab
                  WallpaperGrid(
                    wallpapers: wallpaperProvider.wallpapers,
                    hasMoreWallpapers: wallpaperProvider.hasMoreWallpapers,
                    isLoading: wallpaperProvider.isLoading,
                    onRefresh: () => wallpaperProvider.fetchWallpapers(refresh: true),
                    scrollController: _scrollController,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}
