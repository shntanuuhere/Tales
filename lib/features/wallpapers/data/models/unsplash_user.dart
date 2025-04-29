/// Model class representing a user from the Unsplash API
class UnsplashUser {
  /// Unique identifier for the user
  final String id;
  
  /// Username of the user
  final String username;
  
  /// Display name of the user
  final String name;
  
  /// Profile image URLs
  final UnsplashProfileImages profileImages;
  
  /// Links related to the user
  final UnsplashUserLinks links;
  
  /// Constructor
  UnsplashUser({
    required this.id,
    required this.username,
    required this.name,
    required this.profileImages,
    required this.links,
  });
  
  /// Create an UnsplashUser from JSON
  factory UnsplashUser.fromJson(Map<String, dynamic> json) {
    return UnsplashUser(
      id: json['id'] as String,
      username: json['username'] as String,
      name: json['name'] as String,
      profileImages: UnsplashProfileImages.fromJson(json['profile_image'] as Map<String, dynamic>),
      links: UnsplashUserLinks.fromJson(json['links'] as Map<String, dynamic>),
    );
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'profile_image': profileImages.toJson(),
      'links': links.toJson(),
    };
  }
}

/// Model class representing profile images for a user from the Unsplash API
class UnsplashProfileImages {
  /// Small profile image URL
  final String small;
  
  /// Medium profile image URL
  final String medium;
  
  /// Large profile image URL
  final String large;
  
  /// Constructor
  UnsplashProfileImages({
    required this.small,
    required this.medium,
    required this.large,
  });
  
  /// Create an UnsplashProfileImages from JSON
  factory UnsplashProfileImages.fromJson(Map<String, dynamic> json) {
    return UnsplashProfileImages(
      small: json['small'] as String,
      medium: json['medium'] as String,
      large: json['large'] as String,
    );
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'small': small,
      'medium': medium,
      'large': large,
    };
  }
}

/// Model class representing links for a user from the Unsplash API
class UnsplashUserLinks {
  /// Self link
  final String self;
  
  /// HTML link
  final String html;
  
  /// Photos link
  final String photos;
  
  /// Likes link
  final String likes;
  
  /// Constructor
  UnsplashUserLinks({
    required this.self,
    required this.html,
    required this.photos,
    required this.likes,
  });
  
  /// Create an UnsplashUserLinks from JSON
  factory UnsplashUserLinks.fromJson(Map<String, dynamic> json) {
    return UnsplashUserLinks(
      self: json['self'] as String,
      html: json['html'] as String,
      photos: json['photos'] as String,
      likes: json['likes'] as String,
    );
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'self': self,
      'html': html,
      'photos': photos,
      'likes': likes,
    };
  }
}
