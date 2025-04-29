# Cleanup Guide

This document outlines the files that should be removed or replaced as part of the migration to the new architecture.

## Automated Cleanup

To automatically clean up duplicate and legacy files, use the provided cleanup scripts:

```bash
# On Windows
.\cleanup_duplicates.bat

# On Unix/Linux/Mac
./cleanup_duplicates.sh
```

These scripts will remove all the old files listed below after you've migrated them to the new structure.

## Files to Remove

### Old Services
- `lib/services/wallpaper_service.dart` - Replaced by the new architecture
- `lib/services/unsplash_api_service.dart` - Replaced by UnsplashApiClient

### Old Models
- `lib/models/wallpaper.dart` - Replaced by data/models/app/wallpaper.dart
- `lib/models/category.dart` - Replaced by data/models/app/category.dart

### Deprecated Files
- All files in `lib/providers/` directory - Replaced by presentation/providers
- All files in `lib/theme/` directory - Replaced by presentation/providers/theme_provider.dart

### Old Screens
- `lib/screens/wallpaper_screen.dart` - Replaced by presentation/screens/refactored_wallpaper_screen.dart
- `lib/screens/categories_screen.dart` - Replaced by presentation/screens/refactored_categories_screen.dart
- `lib/screens/wallpaper_detail_screen.dart` - Replaced by presentation/screens/refactored_wallpaper_detail_screen.dart
- `lib/screens/home_page.dart` - Replaced by presentation/screens/refactored_home_screen.dart
- `lib/screens/splash_screen.dart` - Replaced by presentation/screens/refactored_splash_screen.dart

## Migration Steps

1. Run `flutter pub get` to install the `get_it` package
2. Run the migration script to copy files to the new structure:
   ```bash
   # On Windows
   .\migrate_codebase.bat

   # On Unix/Linux/Mac
   ./migrate_codebase.sh
   ```
3. Update imports in the migrated files to reflect the new structure
4. Run tests to ensure everything works correctly
5. Run the cleanup script to remove duplicate and legacy files:
   ```bash
   # On Windows
   .\cleanup_duplicates.bat

   # On Unix/Linux/Mac
   ./cleanup_duplicates.sh
   ```

## Benefits of the New Architecture

- **Cleaner code** with clear separation of concerns
- **Better testability** with dependency injection
- **More maintainable** with single-responsibility components
- **Easier to extend** with new features
- **Real API integration** with Unsplash
