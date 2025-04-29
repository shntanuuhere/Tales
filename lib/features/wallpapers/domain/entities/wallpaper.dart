import '../../data/models/unsplash_photo.dart';

/// Model class representing a wallpaper in the app
class Wallpaper {
  /// Unique identifier for the wallpaper
  final String id;

  /// URL for the full-size wallpaper
  final String url;

  /// URL for the thumbnail
  final String thumbnailUrl;

  /// Category of the wallpaper
  final String category;

  /// Photographer who took the photo
  final String photographer;

  /// Width of the wallpaper in pixels
  final int width;

  /// Height of the wallpaper in pixels
  final int height;

  /// Whether the wallpaper is marked as a favorite
  final bool isFavorite;

  /// URL to the photographer's profile
  final String? photographerUrl;

  /// Description of the wallpaper
  final String? description;

  /// Constructor
  Wallpaper({
    required this.id,
    required this.url,
    required this.thumbnailUrl,
    required this.category,
    required this.photographer,
    required this.width,
    required this.height,
    this.isFavorite = false,
    this.photographerUrl,
    this.description,
  });

  /// Create a copy of this wallpaper with some fields replaced
  Wallpaper copyWith({
    String? id,
    String? url,
    String? thumbnailUrl,
    String? category,
    String? photographer,
    int? width,
    int? height,
    bool? isFavorite,
    String? photographerUrl,
    String? description,
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
      photographerUrl: photographerUrl ?? this.photographerUrl,
      description: description ?? this.description,
    );
  }

  /// Create a Wallpaper from an UnsplashPhoto
  factory Wallpaper.fromUnsplashPhoto(UnsplashPhoto photo) {
    String category = 'Uncategorized';
    if (photo.tags.isNotEmpty) {
      category = photo.tags.first.title;
    }

    return Wallpaper(
      id: photo.id,
      url: photo.urls.regular,
      thumbnailUrl: photo.urls.small,
      category: category,
      photographer: photo.user.name,
      width: photo.width,
      height: photo.height,
      photographerUrl: photo.user.links.html,
      description: photo.description ?? photo.altDescription,
    );
  }

  /// Convert to a Map for storage
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
      'photographerUrl': photographerUrl,
      'description': description,
    };
  }

  /// Create a Wallpaper from a Map
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
      photographerUrl: map['photographerUrl'],
      description: map['description'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => toMap();

  /// Create a Wallpaper from JSON
  factory Wallpaper.fromJson(Map<String, dynamic> json) => Wallpaper.fromMap(json);

  /// Override equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Wallpaper &&
           other.id == id;
  }

  /// Override hashCode
  @override
  int get hashCode => id.hashCode;
}
