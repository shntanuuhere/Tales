#!/bin/bash
# Script to clean up duplicate and legacy files in Tales app

echo "Cleaning up duplicate and legacy files in Tales app..."

# Remove old screen files with "new_" prefix after they've been migrated
echo "Removing old screen files with \"new_\" prefix..."
rm -f lib/presentation/screens/new_categories_screen.dart
rm -f lib/presentation/screens/new_category_wallpapers_screen.dart
rm -f lib/presentation/screens/new_explore_screen.dart
rm -f lib/presentation/screens/new_home_screen.dart
rm -f lib/presentation/screens/new_saved_screen.dart
rm -f lib/presentation/screens/new_splash_screen.dart
rm -f lib/presentation/screens/new_wallpaper_detail_screen.dart

# Remove screen files that have been migrated to features
echo "Removing migrated screen files..."
rm -f lib/presentation/screens/about_screen.dart
rm -f lib/presentation/screens/privacy_policy_screen.dart
rm -f lib/presentation/screens/terms_conditions_screen.dart

# Remove widget files that have been migrated to features or common widgets
echo "Removing migrated widget files..."
rm -f lib/presentation/widgets/app_header.dart
rm -f lib/presentation/widgets/cache_settings.dart
rm -f lib/presentation/widgets/connectivity_indicator.dart
rm -f lib/presentation/widgets/download_progress_indicator.dart
rm -f lib/presentation/widgets/feedback_dialog.dart
rm -f lib/presentation/widgets/wallpaper_card.dart
rm -f lib/presentation/widgets/wallpaper_grid.dart

# Remove old screen files that have been replaced
echo "Removing old screen files..."
[ -f lib/screens/wallpaper_screen.dart ] && rm -f lib/screens/wallpaper_screen.dart
[ -f lib/screens/categories_screen.dart ] && rm -f lib/screens/categories_screen.dart
[ -f lib/screens/wallpaper_detail_screen.dart ] && rm -f lib/screens/wallpaper_detail_screen.dart
[ -f lib/screens/home_page.dart ] && rm -f lib/screens/home_page.dart
[ -f lib/screens/splash_screen.dart ] && rm -f lib/screens/splash_screen.dart

# Remove old model files that have been replaced
echo "Removing old model files..."
rm -f lib/models/podcast.dart
rm -rf lib/models

# Remove old widget files that have been moved to presentation/widgets
echo "Removing old widget files..."
rm -f lib/widgets/edit_profile_dialog.dart
rm -rf lib/widgets

# Remove old utility files that have been moved to core/utils
echo "Removing old utility files..."
rm -f lib/utils/api_cache.dart
rm -f lib/utils/secure_storage.dart
rm -f lib/utils/certificate_pinning.dart
rm -f lib/utils/color_utils.dart
rm -f lib/utils/error_handler.dart
rm -f lib/utils/performance_monitor.dart
rm -f lib/utils/offline_manager.dart
rm -rf lib/utils

# Remove old service files that have been moved to features
echo "Removing old service files..."
rm -f lib/services/connectivity_service.dart
rm -f lib/services/auth_service.dart
rm -f lib/services/auth_stubs.dart
rm -f lib/services/firebase_service.dart
rm -f lib/services/ios_wallpaper_service.dart
[ -f lib/services/wallpaper_service.dart ] && rm -f lib/services/wallpaper_service.dart
[ -f lib/services/unsplash_api_service.dart ] && rm -f lib/services/unsplash_api_service.dart
rm -rf lib/services

# Remove old screen directories
echo "Removing old screen directories..."
rm -rf lib/screens

# Remove old theme files
echo "Removing old theme files..."
[ -d lib/theme ] && rm -rf lib/theme

# Remove old provider files
echo "Removing old provider files..."
[ -d lib/providers ] && rm -rf lib/providers

# Remove podcast directory
echo "Removing podcast directory..."
[ -d lib/podcast ] && rm -rf lib/podcast

# Remove data model files that have been migrated to features
echo "Removing migrated data model files..."
rm -f lib/data/models/app/category.dart
rm -f lib/data/models/app/wallpaper.dart
rm -f lib/data/models/unsplash/unsplash_photo.dart
rm -f lib/data/models/unsplash/unsplash_search_result.dart
rm -f lib/data/models/unsplash/unsplash_topic.dart
rm -f lib/data/models/unsplash/unsplash_urls.dart
rm -f lib/data/models/unsplash/unsplash_user.dart

# Remove data repository files that have been migrated to features
echo "Removing migrated data repository files..."
rm -f lib/data/repositories/unsplash_repository.dart
rm -f lib/data/repositories/wallpaper_repository.dart

# Remove domain usecase files that have been migrated to features
echo "Removing migrated domain usecase files..."
rm -f lib/domain/usecases/download_wallpaper.dart
rm -f lib/domain/usecases/get_categories.dart
rm -f lib/domain/usecases/get_favorite_wallpapers.dart
rm -f lib/domain/usecases/get_wallpapers.dart
rm -f lib/domain/usecases/get_wallpapers_by_category.dart
rm -f lib/domain/usecases/set_wallpaper.dart
rm -f lib/domain/usecases/toggle_favorite.dart

# Remove presentation provider files that have been migrated to features
echo "Removing migrated presentation provider files..."
rm -f lib/presentation/providers/category_provider.dart
rm -f lib/presentation/providers/favorites_provider.dart
rm -f lib/presentation/providers/theme_provider.dart
rm -f lib/presentation/providers/wallpaper_provider.dart

echo "Cleanup complete!"
echo "Note: Make sure you've migrated all necessary files to the new structure before running this script."
