/// Model class representing URLs for different sizes of a photo from the Unsplash API
class UnsplashUrls {
  /// Raw image URL
  final String raw;
  
  /// Full size image URL
  final String full;
  
  /// Regular size image URL (1080px)
  final String regular;
  
  /// Small size image URL (400px)
  final String small;
  
  /// Thumbnail image URL (200px)
  final String thumb;
  
  /// Constructor
  UnsplashUrls({
    required this.raw,
    required this.full,
    required this.regular,
    required this.small,
    required this.thumb,
  });
  
  /// Create an UnsplashUrls from JSON
  factory UnsplashUrls.fromJson(Map<String, dynamic> json) {
    return UnsplashUrls(
      raw: json['raw'] as String,
      full: json['full'] as String,
      regular: json['regular'] as String,
      small: json['small'] as String,
      thumb: json['thumb'] as String,
    );
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'raw': raw,
      'full': full,
      'regular': regular,
      'small': small,
      'thumb': thumb,
    };
  }
}
