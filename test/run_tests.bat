@echo off
echo Running Tales App Tests
echo =============================================

echo.
echo Step 1: Running Flutter Analyze
echo ---------------------------------------------
flutter analyze

echo.
echo Step 2: Running Unit Tests
echo ---------------------------------------------
flutter test

echo.
echo Step 3: Running Widget Tests
echo ---------------------------------------------
flutter test test/widget_test.dart

echo.
echo Step 4: Running Integration Tests (if available)
echo ---------------------------------------------
if exist test_driver (
  flutter drive --target=test_driver/app.dart
) else (
  echo No integration tests found
)

echo.
echo Step 5: Checking Code Coverage
echo ---------------------------------------------
flutter test --coverage
echo Coverage report generated at coverage/lcov.info

echo.
echo All tests completed!
echo =============================================
