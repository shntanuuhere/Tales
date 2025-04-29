import 'package:flutter_test/flutter_test.dart';
import 'package:tales/core/network/connectivity_service.dart';

void main() {
  // Initialize Flutter binding
  TestWidgetsFlutterBinding.ensureInitialized();

  late ConnectivityService connectivityService;

  setUp(() {
    connectivityService = ConnectivityService();
  });

  group('ConnectivityService', () {
    test('initial state has expected properties', () {
      // Just verify the service has the expected properties
      expect(connectivityService.isConnected, isA<bool>());
      expect(connectivityService.isWifi, isA<bool>());
      expect(connectivityService.isMobile, isA<bool>());
    });

    test('checkConnectivity returns a boolean', () async {
      // Act
      final result = await connectivityService.checkConnectivity();

      // Assert
      expect(result, isA<bool>());
    });
  });
}
