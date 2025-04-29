# Tales App Codebase Structure

This document explains the organization of the Tales app codebase, which follows clean architecture principles with a feature-based approach.

## Directory Structure

```
lib/
  ├── core/                   # Core utilities and common functionality
  │   ├── constants/          # App constants
  │   ├── errors/             # Error handling
  │   ├── network/            # Network utilities
  │   └── utils/              # General utilities
  │       ├── api/            # API utilities
  │       ├── security/       # Security utilities
  │       └── storage/        # Storage utilities
  ├── config/                 # Configuration files
  ├── data/                   # Data layer
  │   ├── api/                # API clients
  │   ├── models/             # Data models
  │   │   ├── app/            # App-specific models
  │   │   └── remote/         # Remote API models
  │   └── repositories/       # Repository implementations
  ├── domain/                 # Domain layer
  │   ├── entities/           # Domain entities
  │   ├── repositories/       # Repository interfaces
  │   └── usecases/           # Use cases
  ├── features/               # Feature modules
  │   ├── wallpapers/         # Wallpaper feature
  │   │   ├── data/           # Wallpaper data layer
  │   │   ├── domain/         # Wallpaper domain layer
  │   │   └── presentation/   # Wallpaper presentation layer
  │   ├── categories/         # Categories feature
  │   ├── auth/               # Authentication feature
  │   └── settings/           # Settings feature
  ├── presentation/           # Presentation layer
  │   ├── providers/          # State management
  │   ├── screens/            # UI screens
  │   └── widgets/            # Reusable UI components
  ├── di/                     # Dependency injection
  └── main.dart               # Entry point
```

## Architecture Layers

### Core Layer

The core layer contains utilities and common functionality used throughout the app:

- **Constants**: App-wide constants like API URLs, timeouts, etc.
- **Errors**: Error handling classes and utilities
- **Network**: Network-related utilities like connectivity monitoring
- **Utils**: General utilities for API, security, storage, etc.

### Config Layer

The config layer contains configuration files:

- **API Keys**: API keys and credentials
- **Environment Variables**: Environment-specific configuration

### Data Layer

The data layer is responsible for data access and storage:

- **API Clients**: Classes that handle API requests
- **Models**: Data classes that represent entities
- **Repositories**: Implementations of repository interfaces

### Domain Layer

The domain layer contains the business logic:

- **Entities**: Business objects
- **Repositories**: Interfaces defining data access methods
- **Use Cases**: Business logic operations

### Features Layer

The features layer organizes code by feature:

- **Wallpapers**: Everything related to wallpapers
- **Categories**: Everything related to categories
- **Auth**: Authentication and user management
- **Settings**: App settings and configuration

### Presentation Layer

The presentation layer handles UI and user interactions:

- **Providers**: State management using Provider
- **Screens**: UI screens
- **Widgets**: Reusable UI components

### Dependency Injection

The DI layer handles dependency injection:

- **Service Locator**: Registers and provides dependencies

## Migration Guide

If you're working with the old codebase structure, follow these steps to migrate to the new structure:

1. Run the migration script to copy files to the new structure:
   ```bash
   # On Windows
   .\migrate_codebase.bat

   # On Unix/Linux/Mac
   ./migrate_codebase.sh
   ```

2. Update imports in the migrated files to reflect the new structure

3. Run tests to ensure everything works correctly

4. Once you've verified that everything works, run the cleanup script to remove duplicate and legacy files:
   ```bash
   # On Windows
   .\cleanup_duplicates.bat

   # On Unix/Linux/Mac
   ./cleanup_duplicates.sh
   ```

## Best Practices

When adding new code to the Tales app, follow these best practices:

1. **Feature-First**: Organize code by feature, not by layer
2. **Clean Architecture**: Maintain separation of concerns
3. **Dependency Injection**: Use the service locator for dependencies
4. **Testing**: Write tests for all layers
5. **Documentation**: Document your code with comments and README files
