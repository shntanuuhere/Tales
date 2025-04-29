@echo off
echo Cleaning up duplicate and legacy files in Tales app...

REM Remove old screen files with "new_" prefix after they've been migrated
echo Removing old screen files with "new_" prefix...
del /Q lib\presentation\screens\new_categories_screen.dart
del /Q lib\presentation\screens\new_category_wallpapers_screen.dart
del /Q lib\presentation\screens\new_explore_screen.dart
del /Q lib\presentation\screens\new_home_screen.dart
del /Q lib\presentation\screens\new_saved_screen.dart
del /Q lib\presentation\screens\new_splash_screen.dart
del /Q lib\presentation\screens\new_wallpaper_detail_screen.dart

REM Remove screen files that have been migrated to features
echo Removing migrated screen files...
del /Q lib\presentation\screens\about_screen.dart
del /Q lib\presentation\screens\privacy_policy_screen.dart
del /Q lib\presentation\screens\terms_conditions_screen.dart

REM Remove widget files that have been migrated to features or common widgets
echo Removing migrated widget files...
del /Q lib\presentation\widgets\app_header.dart
del /Q lib\presentation\widgets\cache_settings.dart
del /Q lib\presentation\widgets\connectivity_indicator.dart
del /Q lib\presentation\widgets\download_progress_indicator.dart
del /Q lib\presentation\widgets\feedback_dialog.dart
del /Q lib\presentation\widgets\wallpaper_card.dart
del /Q lib\presentation\widgets\wallpaper_grid.dart

REM Remove old screen files that have been replaced
echo Removing old screen files...
if exist lib\screens\wallpaper_screen.dart del /Q lib\screens\wallpaper_screen.dart
if exist lib\screens\categories_screen.dart del /Q lib\screens\categories_screen.dart
if exist lib\screens\wallpaper_detail_screen.dart del /Q lib\screens\wallpaper_detail_screen.dart
if exist lib\screens\home_page.dart del /Q lib\screens\home_page.dart
if exist lib\screens\splash_screen.dart del /Q lib\screens\splash_screen.dart

REM Remove old model files that have been replaced
echo Removing old model files...
del /Q lib\models\podcast.dart
rmdir /S /Q lib\models

REM Remove old widget files that have been moved to presentation/widgets
echo Removing old widget files...
del /Q lib\widgets\edit_profile_dialog.dart
rmdir /S /Q lib\widgets

REM Remove old utility files that have been moved to core/utils
echo Removing old utility files...
del /Q lib\utils\api_cache.dart
del /Q lib\utils\secure_storage.dart
del /Q lib\utils\certificate_pinning.dart
del /Q lib\utils\color_utils.dart
del /Q lib\utils\error_handler.dart
del /Q lib\utils\performance_monitor.dart
del /Q lib\utils\offline_manager.dart
rmdir /S /Q lib\utils

REM Remove old service files that have been moved to features
echo Removing old service files...
del /Q lib\services\connectivity_service.dart
del /Q lib\services\auth_service.dart
del /Q lib\services\auth_stubs.dart
del /Q lib\services\firebase_service.dart
del /Q lib\services\ios_wallpaper_service.dart
if exist lib\services\wallpaper_service.dart del /Q lib\services\wallpaper_service.dart
if exist lib\services\unsplash_api_service.dart del /Q lib\services\unsplash_api_service.dart
rmdir /S /Q lib\services

REM Remove old screen directories
echo Removing old screen directories...
rmdir /S /Q lib\screens

REM Remove old theme files
echo Removing old theme files...
if exist lib\theme rmdir /S /Q lib\theme

REM Remove old provider files
echo Removing old provider files...
if exist lib\providers rmdir /S /Q lib\providers

REM Remove podcast directory
echo Removing podcast directory...
if exist lib\podcast rmdir /S /Q lib\podcast

REM Remove data model files that have been migrated to features
echo Removing migrated data model files...
del /Q lib\data\models\app\category.dart
del /Q lib\data\models\app\wallpaper.dart
del /Q lib\data\models\unsplash\unsplash_photo.dart
del /Q lib\data\models\unsplash\unsplash_search_result.dart
del /Q lib\data\models\unsplash\unsplash_topic.dart
del /Q lib\data\models\unsplash\unsplash_urls.dart
del /Q lib\data\models\unsplash\unsplash_user.dart

REM Remove data repository files that have been migrated to features
echo Removing migrated data repository files...
del /Q lib\data\repositories\unsplash_repository.dart
del /Q lib\data\repositories\wallpaper_repository.dart

REM Remove domain usecase files that have been migrated to features
echo Removing migrated domain usecase files...
del /Q lib\domain\usecases\download_wallpaper.dart
del /Q lib\domain\usecases\get_categories.dart
del /Q lib\domain\usecases\get_favorite_wallpapers.dart
del /Q lib\domain\usecases\get_wallpapers.dart
del /Q lib\domain\usecases\get_wallpapers_by_category.dart
del /Q lib\domain\usecases\set_wallpaper.dart
del /Q lib\domain\usecases\toggle_favorite.dart

REM Remove presentation provider files that have been migrated to features
echo Removing migrated presentation provider files...
del /Q lib\presentation\providers\category_provider.dart
del /Q lib\presentation\providers\favorites_provider.dart
del /Q lib\presentation\providers\theme_provider.dart
del /Q lib\presentation\providers\wallpaper_provider.dart

echo Cleanup complete!
echo Note: Make sure you've migrated all necessary files to the new structure before running this script.
