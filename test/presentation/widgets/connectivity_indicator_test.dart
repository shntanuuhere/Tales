import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tales/core/network/connectivity_service.dart';
import 'package:tales/presentation/common/widgets/connectivity_indicator.dart';

// Mock ConnectivityService
class MockConnectivityService extends Mock implements ConnectivityService {
  @override
  bool isConnected = false;
}

void main() {
  // Initialize Flutter binding
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockConnectivityService mockConnectivityService;

  setUp(() {
    mockConnectivityService = MockConnectivityService();
  });

  testWidgets('ConnectivityIndicator shows offline message when not connected', (WidgetTester tester) async {
    // Arrange
    mockConnectivityService.isConnected = false;

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<ConnectivityService>.value(
          value: mockConnectivityService,
          child: const Scaffold(
            body: ConnectivityIndicator(),
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('You are offline. Some features may be limited.'), findsOneWidget);
    expect(find.byIcon(Icons.wifi_off), findsOneWidget);
  });

  testWidgets('ConnectivityIndicator is hidden when connected', (WidgetTester tester) async {
    // Arrange
    mockConnectivityService.isConnected = true;

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<ConnectivityService>.value(
          value: mockConnectivityService,
          child: const Scaffold(
            body: ConnectivityIndicator(),
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('You are offline. Some features may be limited.'), findsNothing);
    expect(find.byIcon(Icons.wifi_off), findsNothing);
  });

  testWidgets('ConnectivityIndicator updates when connectivity changes', (WidgetTester tester) async {
    // Arrange - Start connected
    mockConnectivityService.isConnected = true;

    // Act - Render the widget
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<ConnectivityService>.value(
          value: mockConnectivityService,
          child: const Scaffold(
            body: ConnectivityIndicator(),
          ),
        ),
      ),
    );

    // Assert - Initially hidden
    expect(find.text('You are offline. Some features may be limited.'), findsNothing);

    // Act - Change to disconnected
    mockConnectivityService.isConnected = false;
    mockConnectivityService.notifyListeners();
    await tester.pump();

    // Assert - Now visible
    expect(find.text('You are offline. Some features may be limited.'), findsOneWidget);
    expect(find.byIcon(Icons.wifi_off), findsOneWidget);

    // Act - Change back to connected
    mockConnectivityService.isConnected = true;
    mockConnectivityService.notifyListeners();
    await tester.pump();

    // Assert - Hidden again
    expect(find.text('You are offline. Some features may be limited.'), findsNothing);
    expect(find.byIcon(Icons.wifi_off), findsNothing);
  });

  testWidgets('ConnectivitySnackbar shows snackbar when connectivity changes', (WidgetTester tester) async {
    // Arrange - Start connected
    mockConnectivityService.isConnected = true;

    // Act - Render the widget
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<ConnectivityService>.value(
          value: mockConnectivityService,
          child: const ConnectivitySnackbar(
            child: Scaffold(
              body: Text('Test Content'),
            ),
          ),
        ),
      ),
    );

    // Assert - Content is visible
    expect(find.text('Test Content'), findsOneWidget);
    expect(find.text('You are offline. Some features may be limited.'), findsNothing);
    expect(find.text('You are back online'), findsNothing);

    // Act - Change to disconnected
    mockConnectivityService.isConnected = false;
    mockConnectivityService.notifyListeners();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750)); // Animation duration

    // Assert - Offline snackbar is shown
    expect(find.text('You are offline. Some features may be limited.'), findsOneWidget);

    // Act - Change back to connected
    mockConnectivityService.isConnected = true;
    mockConnectivityService.notifyListeners();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750)); // Animation duration

    // Assert - Online snackbar is shown
    expect(find.text('You are back online'), findsOneWidget);
  });
}
