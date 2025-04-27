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
import 'package:flutter_animate/flutter_animate.dart';
import 'category_wallpapers_screen.dart';
import '../models/category.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // Use the centralized Category model
  final List<Category> _categories = Category.getAllCategories();

  // Map of category colors for consistent UI
  final Map<String, Color> _categoryColors = {
    'abstract': Colors.purple,
    'nature': Colors.green,
    'animals': Colors.blue,
    'architecture': Colors.grey,
    'space': Colors.deepPurple,
    'minimal': Colors.pink,
    'dark': Colors.blueGrey.shade800,
    'ocean': Colors.blue.shade700,
    'art': Colors.pink.shade300,
    'food': Colors.orange,
    'travel': Colors.amber,
    'sports': Colors.red,
    'technology': Colors.teal,
    'vehicles': Colors.indigo,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // User profile icon
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: theme.colorScheme.onSurface,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Categories List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return _buildCategoryCard(
                    context,
                    category,
                    index,
                    isDark,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    Category category,
    int index,
    bool isDark,
  ) {
    // Get the color for this category or use a default color
    final categoryColor = _categoryColors[category.id] ?? Colors.blueGrey;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          final wallpaperService = Provider.of<WallpaperService>(context, listen: false);
          wallpaperService.changeCategory(category.name);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryWallpapersScreen(category: category.name),
            ),
          );
        },
        child: Container(
          height: 120,
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
                // Background image with CachedNetworkImage for better performance
                CachedNetworkImage(
                  imageUrl: category.thumbnailUrl,
                  fit: BoxFit.cover,
                  memCacheWidth: 600, // Limit memory cache size
                  memCacheHeight: 240,
                  fadeInDuration: const Duration(milliseconds: 200), // Faster fade-in
                  placeholder: (context, url) => Container(
                    color: categoryColor,
                    child: const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            categoryColor,
                            categoryColor.withAlpha(179), // 0.7 * 255 = 179
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          category.icon ?? Icons.image,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),

                // Dark overlay for better text visibility
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(77), // 0.3 * 255 = 77
                  ),
                ),

                // Category name centered
                Center(
                  child: Text(
                    category.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate(delay: Duration(milliseconds: 50 * index))
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.1, end: 0),
    );
  }


}