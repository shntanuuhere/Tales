/// Model class representing a topic from the Unsplash API
class UnsplashTopic {
  /// Unique identifier for the topic
  final String id;
  
  /// Slug for the topic (used in URLs)
  final String slug;
  
  /// Title of the topic
  final String title;
  
  /// Description of the topic
  final String description;
  
  /// Cover photo for the topic
  final UnsplashTopicCoverPhoto coverPhoto;
  
  /// Constructor
  UnsplashTopic({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.coverPhoto,
  });
  
  /// Create an UnsplashTopic from JSON
  factory UnsplashTopic.fromJson(Map<String, dynamic> json) {
    return UnsplashTopic(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      coverPhoto: UnsplashTopicCoverPhoto.fromJson(json['cover_photo'] as Map<String, dynamic>),
    );
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'title': title,
      'description': description,
      'cover_photo': coverPhoto.toJson(),
    };
  }
}

/// Model class representing a cover photo for a topic from the Unsplash API
class UnsplashTopicCoverPhoto {
  /// Unique identifier for the photo
  final String id;
  
  /// URLs for different sizes of the photo
  final Map<String, String> urls;
  
  /// Constructor
  UnsplashTopicCoverPhoto({
    required this.id,
    required this.urls,
  });
  
  /// Create an UnsplashTopicCoverPhoto from JSON
  factory UnsplashTopicCoverPhoto.fromJson(Map<String, dynamic> json) {
    final urlsJson = json['urls'] as Map<String, dynamic>;
    return UnsplashTopicCoverPhoto(
      id: json['id'] as String,
      urls: {
        'raw': urlsJson['raw'] as String,
        'full': urlsJson['full'] as String,
        'regular': urlsJson['regular'] as String,
        'small': urlsJson['small'] as String,
        'thumb': urlsJson['thumb'] as String,
      },
    );
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'urls': urls,
    };
  }
}
