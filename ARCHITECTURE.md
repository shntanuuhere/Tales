# Tales App Architecture

This document describes the architecture of the Tales app, which follows a clean architecture approach with a focus on separation of concerns and testability.

## Overview

The app is structured into the following layers:

1. **Data Layer**: Responsible for data access and storage
2. **Domain Layer**: Contains business logic and use cases
3. **Presentation Layer**: Handles UI and user interactions

## Directory Structure

```
lib/
  ├── data/
  │   ├── api/
  │   │   ├── api_exception.dart
  │   │   └── unsplash_api_client.dart
  │   ├── models/
  │   │   ├── app/
  │   │   │   ├── wallpaper.dart
  │   │   │   └── category.dart
  │   │   └── unsplash/
  │   │       ├── unsplash_photo.dart
  │   │       ├── unsplash_urls.dart
  │   │       ├── unsplash_user.dart
  │   │       ├── unsplash_topic.dart
  │   │       └── unsplash_search_result.dart
  │   └── repositories/
  │       ├── wallpaper_repository.dart
  │       └── unsplash_repository.dart
  ├── domain/
  │   └── usecases/
  │       ├── get_wallpapers.dart
  │       ├── get_categories.dart
  │       ├── toggle_favorite.dart
  │       ├── download_wallpaper.dart
  │       ├── set_wallpaper.dart
  │       └── get_favorite_wallpapers.dart
  ├── presentation/
  │   ├── providers/
  │   │   ├── wallpaper_provider.dart
  │   │   ├── category_provider.dart
  │   │   └── favorites_provider.dart
  │   └── screens/
  │       └── refactored_wallpaper_screen.dart
  ├── di/
  │   └── service_locator.dart
  └── config/
      └── api_keys.dart
```

## Layers

### Data Layer

The data layer is responsible for data access and storage. It includes:

- **API Clients**: Low-level classes that handle API requests
- **Models**: Data classes that represent entities
- **Repositories**: Implementations of repository interfaces

#### Models

Models are divided into two categories:

1. **API Models**: Direct mappings of API responses (e.g., `UnsplashPhoto`)
2. **App Models**: Models used throughout the app (e.g., `Wallpaper`)

#### Repositories

Repositories abstract the data sources and provide a clean API for the domain layer. They handle:

- Data fetching
- Caching
- Error handling
- Data transformation

### Domain Layer

The domain layer contains the business logic of the app. It includes:

- **Use Cases**: Single-responsibility classes that encapsulate business logic

Use cases are designed to be independent of the UI and data sources, making them easy to test and reuse.

### Presentation Layer

The presentation layer handles UI and user interactions. It includes:

- **Providers**: State management classes that connect the UI to the domain layer
- **Screens**: UI components that display data and handle user input

#### Providers

Providers are responsible for:

- Holding UI state
- Calling use cases
- Notifying the UI of changes

#### Screens

Screens are responsible for:

- Displaying data
- Handling user input
- Navigating between screens

## Dependency Injection

The app uses the `get_it` package for dependency injection. The `service_locator.dart` file sets up all dependencies.

Benefits of dependency injection:

- Easier testing
- Decoupled components
- Centralized dependency management

## Migration Strategy

The app is being migrated from the old architecture to the new one incrementally:

1. Create new components following the clean architecture
2. Keep existing components working
3. Gradually replace old components with new ones
4. Remove old components once they are no longer needed

## Testing

The new architecture is designed to be testable:

- **Repositories**: Can be mocked for testing use cases
- **Use Cases**: Can be tested in isolation
- **Providers**: Can be tested with mocked use cases

## Future Improvements

- Complete migration of all features to the new architecture
- Add comprehensive test coverage
- Implement caching for better offline support
- Optimize performance with better state management
