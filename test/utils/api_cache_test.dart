import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tales/core/utils/api/api_cache.dart';

void main() {
  group('ApiCache', () {
    late ApiCache apiCache;

    setUp(() {
      apiCache = ApiCache();
      SharedPreferences.setMockInitialValues({});
    });

    test('set and get cache data', () async {
      // Set cache data
      final testData = {'test': 'data'};
      final result = await apiCache.set('test_key', testData);

      // Verify set was successful
      expect(result, true);

      // Get cache data
      final cachedData = await apiCache.get('test_key');

      // Verify data matches
      expect(cachedData, testData);
    });

    test('get returns null for non-existent key', () async {
      final cachedData = await apiCache.get('non_existent_key');
      expect(cachedData, null);
    });

    test('get returns null for expired cache', () async {
      // Set cache data with very short expiration
      final testData = {'test': 'data'};
      await apiCache.set('test_key', testData, expirationMinutes: 0);

      // Wait a moment to ensure cache expires
      await Future.delayed(const Duration(milliseconds: 100));

      // Get cache data
      final cachedData = await apiCache.get('test_key');

      // Verify cache is expired
      expect(cachedData, null);
    });

    test('clear removes specific cache entry', () async {
      // Set multiple cache entries
      await apiCache.set('key1', {'test': 'data1'});
      await apiCache.set('key2', {'test': 'data2'});

      // Clear one entry
      final result = await apiCache.clear('key1');

      // Verify clear was successful
      expect(result, true);

      // Verify cleared entry is gone
      expect(await apiCache.get('key1'), null);

      // Verify other entry still exists
      expect(await apiCache.get('key2'), {'test': 'data2'});
    });

    test('clearAll removes all cache entries', () async {
      // Set multiple cache entries
      await apiCache.set('key1', {'test': 'data1'});
      await apiCache.set('key2', {'test': 'data2'});

      // Clear all entries
      final result = await apiCache.clearAll();

      // Verify clearAll was successful
      expect(result, true);

      // Verify all entries are gone
      expect(await apiCache.get('key1'), null);
      expect(await apiCache.get('key2'), null);
    });

    test('set with different expiration times', () async {
      // Set cache data with short expiration
      final testData1 = {'test': 'data1'};
      await apiCache.set('key1', testData1, expirationMinutes: 1);

      // Set cache data with longer expiration
      final testData2 = {'test': 'data2'};
      await apiCache.set('key2', testData2, expirationMinutes: 60);

      // Verify both are initially available
      expect(await apiCache.get('key1'), testData1);
      expect(await apiCache.get('key2'), testData2);

      // Since we can't reliably test timing in unit tests,
      // we'll just verify that both were initially set correctly
      expect(await apiCache.get('key1'), testData1);
      expect(await apiCache.get('key2'), testData2);
    });

    test('handles complex data structures', () async {
      // Create a complex data structure
      final complexData = {
        'string': 'value',
        'number': 42,
        'boolean': true,
        'list': [1, 2, 3],
        'nested': {
          'key': 'value',
          'array': ['a', 'b', 'c'],
        }
      };

      // Set and get the complex data
      await apiCache.set('complex', complexData);
      final result = await apiCache.get('complex');

      // Verify the complex data is preserved
      expect(result, complexData);
    });

    test('handles concurrent operations', () async {
      // Start multiple set operations concurrently
      final futures = <Future<bool>>[];
      for (int i = 0; i < 10; i++) {
        futures.add(apiCache.set('key$i', {'index': i}));
      }

      // Wait for all operations to complete
      final results = await Future.wait(futures);

      // Verify all operations succeeded
      for (final result in results) {
        expect(result, true);
      }

      // Verify all data was stored correctly
      for (int i = 0; i < 10; i++) {
        final data = await apiCache.get('key$i');
        expect(data, {'index': i});
      }
    });
  });
}
