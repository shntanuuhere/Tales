import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/category_provider.dart';
import '../../../wallpapers/presentation/providers/wallpaper_provider.dart';
import '../../domain/entities/category.dart';
import '../../../../presentation/common/widgets/app_header.dart';
import 'category_wallpapers_screen.dart';

/// A screen to display categories
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Header
            AppHeader(
              title: 'Categories',
              onProfileTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),

            // Categories grid
            Expanded(
              child: categoryProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async {
                      await categoryProvider.fetchCategories();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: categoryProvider.categories.length,
                      itemBuilder: (context, index) {
                        // Skip the "All" category as it's not a real category
                        if (categoryProvider.categories[index].id == 'all') {
                          return const SizedBox.shrink();
                        }

                        return _buildCategoryCard(
                          context,
                          categoryProvider.categories[index],
                        );
                      },
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category category) {
    final theme = Theme.of(context);
    final wallpaperProvider = Provider.of<WallpaperProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          // Use the new fetchWallpapersByCategory method for better performance
          wallpaperProvider.fetchWallpapersByCategory(category.name);

          // Navigate to the category wallpapers screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider.value(
                value: wallpaperProvider,
                child: CategoryWallpapersScreen(category: category),
              ),
            ),
          );
        },
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Category image
                CachedNetworkImage(
                  imageUrl: category.thumbnailUrl,
                  fit: BoxFit.cover,
                  memCacheWidth: 600,
                  fadeInDuration: const Duration(milliseconds: 200),
                  placeholder: (context, url) {
                    return Container(
                      color: theme.colorScheme.surfaceContainerLow,
                    ).animate()
                      .shimmer(duration: const Duration(milliseconds: 800), color: Colors.white.withAlpha(127))
                      .animate(onPlay: (controller) => controller.repeat());
                  },
                  errorWidget: (context, url, error) {
                    return Container(
                      color: theme.colorScheme.surfaceContainerLow,
                      child: Icon(
                        category.icon ?? Icons.image,
                        size: 40,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),

                // Gradient overlay
                Container(
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

                // Category name
                Center(
                  child: Text(
                    category.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: const Duration(milliseconds: 300)),
      ),
    );
  }
}
