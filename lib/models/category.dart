import 'package:flutter/material.dart';

/// Model class for wallpaper categories
class Category {
  /// Unique identifier for the category
  final String id;

  /// Display name for the category
  final String name;

  /// URL for the category thumbnail image
  final String thumbnailUrl;

  /// Icon to represent the category (optional)
  final IconData? icon;

  /// Constructor for Category
  const Category({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    this.icon,
  });

  /// Factory method to create a Category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      icon: json['icon'] != null ? IconData(json['icon'] as int, fontFamily: 'MaterialIcons') : null,
    );
  }

  /// Convert Category to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'thumbnailUrl': thumbnailUrl,
      'icon': icon?.codePoint,
    };
  }

  /// Get all available categories
  static List<Category> getAllCategories() {
    return [
      const Category(
        id: 'abstract',
        name: 'Abstract',
        thumbnailUrl: 'https://images.unsplash.com/photo-1557672172-298e090bd0f1?w=500&q=80',
        icon: Icons.bubble_chart,
      ),
      const Category(
        id: 'nature',
        name: 'Nature',
        thumbnailUrl: 'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=500&q=80',
        icon: Icons.landscape,
      ),
      const Category(
        id: 'animals',
        name: 'Animals',
        thumbnailUrl: 'https://images.unsplash.com/photo-1474511320723-9a56873867b5?w=500&q=80',
        icon: Icons.pets,
      ),
      const Category(
        id: 'architecture',
        name: 'Architecture',
        thumbnailUrl: 'https://images.unsplash.com/photo-1487958449943-2429e8be8625?w=500&q=80',
        icon: Icons.apartment,
      ),
      const Category(
        id: 'space',
        name: 'Space',
        thumbnailUrl: 'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=500&q=80',
        icon: Icons.star,
      ),
      const Category(
        id: 'minimal',
        name: 'Minimal',
        thumbnailUrl: 'https://images.unsplash.com/photo-1473186578172-c141e6798cf4?w=500&q=80',
        icon: Icons.crop_square,
      ),
      // Additional categories to match those in WallpaperService
      const Category(
        id: 'dark',
        name: 'Dark',
        thumbnailUrl: 'https://images.unsplash.com/photo-1478760329108-5c3ed9d495a0?w=500&q=80',
        icon: Icons.nights_stay,
      ),
      const Category(
        id: 'ocean',
        name: 'Ocean',
        thumbnailUrl: 'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=500&q=80',
        icon: Icons.water,
      ),
      const Category(
        id: 'art',
        name: 'Art',
        thumbnailUrl: 'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=500&q=80',
        icon: Icons.palette,
      ),
      const Category(
        id: 'food',
        name: 'Food',
        thumbnailUrl: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=500&q=80',
        icon: Icons.restaurant,
      ),
      const Category(
        id: 'travel',
        name: 'Travel',
        thumbnailUrl: 'https://images.unsplash.com/photo-1503220317375-aaad61436b1b?w=500&q=80',
        icon: Icons.flight,
      ),
      const Category(
        id: 'sports',
        name: 'Sports',
        thumbnailUrl: 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=500&q=80',
        icon: Icons.sports_basketball,
      ),
      const Category(
        id: 'technology',
        name: 'Technology',
        thumbnailUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=500&q=80',
        icon: Icons.devices,
      ),
      const Category(
        id: 'vehicles',
        name: 'Vehicles',
        thumbnailUrl: 'https://images.unsplash.com/photo-1511919884226-fd3cad34687c?w=500&q=80',
        icon: Icons.directions_car,
      ),
    ];
  }

  /// Get a category by ID
  static Category? getCategoryById(String id) {
    final categories = getAllCategories();
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }
}
