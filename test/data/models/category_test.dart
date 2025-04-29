import 'package:flutter_test/flutter_test.dart';
import 'package:tales/features/categories/domain/entities/category.dart';

void main() {
  group('Category Model Tests', () {
    test('Create category from constructor', () {
      const category = Category(
        id: 'nature',
        name: 'Nature',
        thumbnailUrl: 'https://example.com/nature.jpg',
      );

      expect(category.id, 'nature');
      expect(category.name, 'Nature');
      expect(category.thumbnailUrl, 'https://example.com/nature.jpg');
    });

    test('Get predefined categories', () {
      final categories = Category.getPredefinedCategories();

      // Should have at least some predefined categories
      expect(categories.isNotEmpty, true);

      // Check if common categories exist
      final categoryNames = categories.map((c) => c.name).toList();
      expect(categoryNames.contains('Nature'), true);
      expect(categoryNames.contains('Abstract'), true);
    });

    test('Category equality', () {
      const category1 = Category(
        id: 'nature',
        name: 'Nature',
        thumbnailUrl: 'https://example.com/nature.jpg',
      );

      const category2 = Category(
        id: 'nature', // Same ID
        name: 'Nature',
        thumbnailUrl: 'https://example.com/nature.jpg',
      );

      const category3 = Category(
        id: 'abstract', // Different ID
        name: 'Abstract',
        thumbnailUrl: 'https://example.com/abstract.jpg',
      );

      // Categories with the same ID should be equal
      expect(category1 == category2, true);

      // Categories with different IDs should not be equal
      expect(category1 == category3, false);
    });
  });
}
