import 'unsplash_urls.dart';
import 'unsplash_user.dart';

/// Model class representing a photo from the Unsplash API
class UnsplashPhoto {
  /// Unique identifier for the photo
  final String id;
  
  /// URLs for different sizes of the photo
  final UnsplashUrls urls;
  
  /// User who uploaded the photo
  final UnsplashUser user;
  
  /// Width of the photo in pixels
  final int width;
  
  /// Height of the photo in pixels
  final int height;
  
  /// Description of the photo (can be null)
  final String? description;
  
  /// Alt text for the photo (can be null)
  final String? altDescription;
  
  /// Tags associated with the photo
  final List<UnsplashTag> tags;
  
  /// Constructor
  UnsplashPhoto({
    required this.id,
    required this.urls,
    required this.user,
    required this.width,
    required this.height,
    this.description,
    this.altDescription,
    this.tags = const [],
  });
  
  /// Create an UnsplashPhoto from JSON
  factory UnsplashPhoto.fromJson(Map<String, dynamic> json) {
    return UnsplashPhoto(
      id: json['id'] as String,
      urls: UnsplashUrls.fromJson(json['urls'] as Map<String, dynamic>),
      user: UnsplashUser.fromJson(json['user'] as Map<String, dynamic>),
      width: json['width'] as int,
      height: json['height'] as int,
      description: json['description'] as String?,
      altDescription: json['alt_description'] as String?,
      tags: json['tags'] != null 
          ? (json['tags'] as List).map((tag) => UnsplashTag.fromJson(tag as Map<String, dynamic>)).toList()
          : [],
    );
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'urls': urls.toJson(),
      'user': user.toJson(),
      'width': width,
      'height': height,
      'description': description,
      'alt_description': altDescription,
      'tags': tags.map((tag) => tag.toJson()).toList(),
    };
  }
}

/// Model class representing a tag from the Unsplash API
class UnsplashTag {
  /// Title of the tag
  final String title;
  
  /// Constructor
  UnsplashTag({
    required this.title,
  });
  
  /// Create an UnsplashTag from JSON
  factory UnsplashTag.fromJson(Map<String, dynamic> json) {
    return UnsplashTag(
      title: json['title'] as String,
    );
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
    };
  }
}
