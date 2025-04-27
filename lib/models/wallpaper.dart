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

import 'category.dart';

class Wallpaper {
  final String id;
  final String url;
  final String thumbnailUrl;
  final String category;
  final String photographer;
  final int width;
  final int height;
  final bool isFavorite;

  Wallpaper({
    required this.id,
    required this.url,
    required this.thumbnailUrl,
    required this.category,
    required this.photographer,
    required this.width,
    required this.height,
    this.isFavorite = false,
  });

  Wallpaper copyWith({
    String? id,
    String? url,
    String? thumbnailUrl,
    String? category,
    String? photographer,
    int? width,
    int? height,
    bool? isFavorite,
  }) {
    return Wallpaper(
      id: id ?? this.id,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      category: category ?? this.category,
      photographer: photographer ?? this.photographer,
      width: width ?? this.width,
      height: height ?? this.height,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'category': category,
      'photographer': photographer,
      'width': width,
      'height': height,
      'isFavorite': isFavorite,
    };
  }

  factory Wallpaper.fromMap(Map<String, dynamic> map) {
    return Wallpaper(
      id: map['id'],
      url: map['url'],
      thumbnailUrl: map['thumbnailUrl'],
      category: map['category'],
      photographer: map['photographer'],
      width: map['width'],
      height: map['height'],
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  // Demo wallpapers
  static List<Wallpaper> getDemoWallpapers() {
    return [
      Wallpaper(
        id: '1',
        url: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
        thumbnailUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
        category: 'Nature',
        photographer: 'John Doe',
        width: 2070,
        height: 1380,
        isFavorite: true,
      ),
      Wallpaper(
        id: '2',
        url: 'https://images.unsplash.com/photo-1518837695005-2083093ee35b',
        thumbnailUrl: 'https://images.unsplash.com/photo-1518837695005-2083093ee35b',
        category: 'Nature',
        photographer: 'Jane Smith',
        width: 2070,
        height: 1380,
        isFavorite: false,
      ),
      Wallpaper(
        id: '3',
        url: 'https://images.unsplash.com/photo-1477959858617-67f85cf4f1df',
        thumbnailUrl: 'https://images.unsplash.com/photo-1477959858617-67f85cf4f1df',
        category: 'Architecture',
        photographer: 'Mike Johnson',
        width: 2144,
        height: 1429,
        isFavorite: true,
      ),
      Wallpaper(
        id: '4',
        url: 'https://images.unsplash.com/photo-1462331940025-496dfbfc7564',
        thumbnailUrl: 'https://images.unsplash.com/photo-1462331940025-496dfbfc7564',
        category: 'Space',
        photographer: 'Sarah Williams',
        width: 2127,
        height: 1418,
        isFavorite: false,
      ),
      Wallpaper(
        id: '5',
        url: 'https://images.unsplash.com/photo-1508193638397-1c4234db14d8',
        thumbnailUrl: 'https://images.unsplash.com/photo-1508193638397-1c4234db14d8',
        category: 'Nature',
        photographer: 'David Brown',
        width: 2070,
        height: 1380,
        isFavorite: true,
      ),
      Wallpaper(
        id: '6',
        url: 'https://images.unsplash.com/photo-1541701494587-cb58502866ab',
        thumbnailUrl: 'https://images.unsplash.com/photo-1541701494587-cb58502866ab',
        category: 'Abstract',
        photographer: 'Lisa Chen',
        width: 2070,
        height: 1380,
        isFavorite: false,
      ),
    ];
  }

  // Get wallpapers by category
  static List<Wallpaper> getByCategory(String category) {
    return getDemoWallpapers()
        .where((wallpaper) => wallpaper.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  // Get all categories
  static List<String> getAllCategories() {
    // Use the centralized Category model
    final categories = Category.getAllCategories()
        .map((category) => category.name)
        .toList();

    // Add any categories from demo wallpapers that might not be in the Category model
    final demoCategories = getDemoWallpapers()
        .map((wallpaper) => wallpaper.category)
        .toSet()
        .toList();

    // Combine both lists
    categories.addAll(demoCategories);

    // Return unique categories
    return categories.toSet().toList()..sort();
  }

  // Search wallpapers by query
  static List<Wallpaper> searchWallpapers(String query) {
    if (query.isEmpty) {
      return getDemoWallpapers();
    }

    final lowercaseQuery = query.toLowerCase();
    return getDemoWallpapers().where((wallpaper) {
      return wallpaper.photographer.toLowerCase().contains(lowercaseQuery) ||
             wallpaper.category.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}