# Testing Guide for Tales App

This document provides comprehensive instructions for testing the Tales app.

## Table of Contents
1. [Unit Tests](#unit-tests)
2. [Widget Tests](#widget-tests)
3. [Integration Tests](#integration-tests)
4. [Performance Tests](#performance-tests)
5. [Manual Testing](#manual-testing)
6. [Test Coverage](#test-coverage)

## Unit Tests

Unit tests verify individual components of the app in isolation.

### Running Unit Tests

```powershell
# Run all unit tests
flutter test

# Run a specific test file
flutter test test/data/repositories/unsplash_repository_test.dart

# Run tests with coverage
flutter test --coverage
```

### Key Unit Test Files

- `test/data/repositories/unsplash_repository_test.dart` - Tests for the Unsplash repository
- `test/presentation/providers/wallpaper_provider_test.dart` - Tests for the wallpaper provider
- `test/utils/api_cache_test.dart` - Tests for the API cache utility

## Widget Tests

Widget tests verify that UI components work correctly.

### Running Widget Tests

```powershell
# Run all widget tests
flutter test test/presentation/widgets/

# Run a specific widget test
flutter test test/presentation/widgets/connectivity_indicator_test.dart
```

### Key Widget Test Files

- `test/presentation/widgets/connectivity_indicator_test.dart` - Tests for the connectivity indicator

## Integration Tests

Integration tests verify that different parts of the app work together correctly.

### Running Integration Tests

```powershell
# Run all integration tests
flutter test integration_test/

# Run a specific integration test
flutter test integration_test/app_test.dart
```

### Key Integration Test Files

- `integration_test/app_test.dart` - End-to-end test of the main app flow
- `integration_test/performance_test.dart` - Tests for app performance

## Performance Tests

Performance tests measure the app's performance metrics.

### Running Performance Tests

```powershell
# Run performance tests
flutter test integration_test/performance_test.dart
```

### Performance Metrics

The performance tests measure:
- App startup time
- Scrolling performance
- Image loading performance

## Manual Testing

Manual testing is essential for verifying the user experience.

### Running Manual Tests

1. Open the `MANUAL_TESTING.md` file
2. Go through each item in the checklist
3. Mark items as completed when they pass

### Key Manual Testing Areas

- Installation and startup
- Navigation
- Wallpaper browsing and setting
- Offline functionality
- Cross-platform compatibility

## Test Coverage

Test coverage measures how much of your code is covered by tests.

### Generating Coverage Reports

```powershell
# Generate coverage report
./run_tests.ps1
```

### Interpreting Coverage Reports

The script will output:
- Lines covered
- Total lines
- Coverage percentage
- Status (Good, Acceptable, or Needs Improvement)

### Improving Coverage

Focus on testing:
1. Core business logic
2. Error handling
3. Edge cases
4. User interactions

## Continuous Integration

The app is set up for continuous integration testing.

### CI Workflow

1. Push changes to the repository
2. CI server runs all tests
3. Coverage report is generated
4. Build is marked as passing or failing

### CI Requirements

- All unit tests must pass
- Integration tests must pass
- Coverage must not decrease
- No new warnings or errors
