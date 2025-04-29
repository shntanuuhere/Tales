import 'package:flutter_test/flutter_test.dart';
import 'package:tales/core/utils/storage/secure_storage.dart';

void main() {
  group('SecureStorage', () {
    late SecureStorage secureStorage;

    setUp(() {
      secureStorage = SecureStorage();
    });

    test('SecureStorage instance is a singleton', () {
      // Create multiple instances
      final instance1 = SecureStorage();
      final instance2 = SecureStorage();

      // Verify they are the same instance
      expect(identical(instance1, instance2), true);
      expect(identical(instance1, secureStorage), true);
    });

    // Note: The following tests are placeholders and would require
    // proper mocking of FlutterSecureStorage to be fully implemented.
    // For now, we're just testing the singleton pattern.

    test('SecureStorage API is available', () {
      // Verify the API methods exist
      expect(secureStorage.getUnsplashApiKey, isA<Function>());
      expect(secureStorage.setUnsplashApiKey, isA<Function>());
      expect(secureStorage.clearAll, isA<Function>());
      expect(secureStorage.initialize, isA<Function>());
    });
  });
}
