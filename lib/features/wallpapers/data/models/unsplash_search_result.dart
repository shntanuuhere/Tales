import 'unsplash_photo.dart';

/// Model class representing search results from the Unsplash API
class UnsplashSearchResult {
  /// Total number of results
  final int total;
  
  /// Total number of pages
  final int totalPages;
  
  /// List of photos in the current page
  final List<UnsplashPhoto> results;
  
  /// Constructor
  UnsplashSearchResult({
    required this.total,
    required this.totalPages,
    required this.results,
  });
  
  /// Create an UnsplashSearchResult from JSON
  factory UnsplashSearchResult.fromJson(Map<String, dynamic> json) {
    return UnsplashSearchResult(
      total: json['total'] as int,
      totalPages: json['total_pages'] as int,
      results: (json['results'] as List)
          .map((result) => UnsplashPhoto.fromJson(result as Map<String, dynamic>))
          .toList(),
    );
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'total_pages': totalPages,
      'results': results.map((photo) => photo.toJson()).toList(),
    };
  }
}
