import 'package:flutter/material.dart';
import '../../data/models/unsplash_topic.dart';

/// Model class representing a wallpaper category in the app
class Category {
  /// Unique identifier for the category
  final String id;

  /// Display name for the category
  final String name;

  /// URL for the category thumbnail image
  final String thumbnailUrl;

  /// Icon to represent the category (optional)
  final IconData? icon;

  /// Description of the category (optional)
  final String? description;

  /// Constructor
  const Category({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    this.icon,
    this.description,
  });

  /// Create a Category from an UnsplashTopic
  factory Category.fromUnsplashTopic(UnsplashTopic topic) {
    return Category(
      id: topic.slug,
      name: topic.title,
      thumbnailUrl: topic.coverPhoto.urls['small'] ?? '',
      description: topic.description,
    );
  }

  /// Create a Category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      icon: json['icon'] != null ? IconData(json['icon'] as int, fontFamily: 'MaterialIcons') : null,
      description: json['description'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'thumbnailUrl': thumbnailUrl,
      'icon': icon?.codePoint,
      'description': description,
    };
  }

  /// Get all predefined categories
  static List<Category> getPredefinedCategories() {
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
    ];
  }
}
