# Tales App Test Suite

This directory contains the test suite for the Tales app. The test suite includes various types of tests to ensure the app is stable, secure, and ready for store release.

## Test Structure

- **Unit Tests**: Tests for individual components and utilities
- **Widget Tests**: Tests for UI components
- **Integration Tests**: End-to-end tests for app flows
- **Manual Tests**: Checklists for manual testing

## Running Tests

### Automated Tests

To run all automated tests, use the provided batch script:

```bash
./test/run_tests.bat
```

This will run:
1. Flutter analyze to check for code issues
2. Unit tests
3. Widget tests
4. Integration tests (if available)
5. Generate code coverage report

### Manual Tests

For manual testing, use the provided checklists:

1. **Functional Testing**: `functional_test_cases.md`
2. **UI/UX Testing**: `ui_ux_test_cases.md`
3. **Performance Testing**: `performance_test_cases.md`
4. **Security Testing**: `security_test_cases.md`
5. **Network Testing**: `network_test_cases.md`

A comprehensive manual testing checklist is available in `manual_testing_checklist.md`.

## Generating Test Reports

To generate a test report template:

```bash
dart test/generate_test_report.dart
```

This will create a report template in the `test/reports` directory. Fill in the test results manually.

## Test Plan

The overall test plan is described in `app_test_plan.md`. This document outlines the test strategy, test environment, and test categories.

## Adding New Tests

When adding new features to the app, please add corresponding tests:

1. **Unit Tests**: Add tests for new utilities and services
2. **Widget Tests**: Add tests for new UI components
3. **Integration Tests**: Add tests for new app flows
4. **Manual Tests**: Update checklists with new test cases

## Test Coverage

The goal is to maintain at least 80% code coverage for the app. The coverage report is generated in the `coverage` directory when running the tests.

## Continuous Integration

The test suite is designed to be run in a CI environment. The tests are configured to run on every pull request and push to the main branch.
