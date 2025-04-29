@echo off
echo Starting Tales codebase migration...

REM Create core directories
mkdir lib\core\constants lib\core\errors lib\core\network lib\core\utils\api lib\core\utils\storage lib\core\utils\security

REM Create feature directories
mkdir lib\features\wallpapers\data lib\features\wallpapers\domain lib\features\wallpapers\presentation
mkdir lib\features\categories\data lib\features\categories\domain lib\features\categories\presentation
mkdir lib\features\auth\data lib\features\auth\domain lib\features\auth\presentation
mkdir lib\features\settings\data lib\features\settings\domain lib\features\settings\presentation

REM Move utility files to core directory
echo Moving utility files to core directory...
copy lib\utils\api_cache.dart lib\core\utils\api\api_cache.dart
copy lib\utils\secure_storage.dart lib\core\utils\storage\secure_storage.dart
copy lib\utils\certificate_pinning.dart lib\core\utils\security\certificate_pinning.dart
copy lib\utils\color_utils.dart lib\core\utils\color_utils.dart
copy lib\utils\error_handler.dart lib\core\errors\error_handler.dart
copy lib\utils\performance_monitor.dart lib\core\utils\performance_monitor.dart
copy lib\utils\offline_manager.dart lib\core\network\offline_manager.dart

REM Move connectivity service to core directory
echo Moving connectivity service to core directory...
copy lib\services\connectivity_service.dart lib\core\network\connectivity_service.dart

REM Move wallpaper feature files
echo Moving wallpaper feature files...
mkdir lib\features\wallpapers\data\models lib\features\wallpapers\data\repositories lib\features\wallpapers\data\datasources
mkdir lib\features\wallpapers\domain\entities lib\features\wallpapers\domain\repositories lib\features\wallpapers\domain\usecases
mkdir lib\features\wallpapers\presentation\providers lib\features\wallpapers\presentation\screens lib\features\wallpapers\presentation\widgets

REM Copy wallpaper models
copy lib\data\models\app\wallpaper.dart lib\features\wallpapers\domain\entities\wallpaper.dart
copy lib\data\models\unsplash\unsplash_photo.dart lib\features\wallpapers\data\models\unsplash_photo.dart
copy lib\data\models\unsplash\unsplash_urls.dart lib\features\wallpapers\data\models\unsplash_urls.dart
copy lib\data\models\unsplash\unsplash_user.dart lib\features\wallpapers\data\models\unsplash_user.dart

REM Copy wallpaper repositories
copy lib\data\repositories\wallpaper_repository.dart lib\features\wallpapers\domain\repositories\wallpaper_repository.dart
copy lib\data\repositories\unsplash_repository.dart lib\features\wallpapers\data\repositories\unsplash_repository.dart

REM Copy wallpaper use cases
copy lib\domain\usecases\get_wallpapers.dart lib\features\wallpapers\domain\usecases\get_wallpapers.dart
copy lib\domain\usecases\download_wallpaper.dart lib\features\wallpapers\domain\usecases\download_wallpaper.dart
copy lib\domain\usecases\set_wallpaper.dart lib\features\wallpapers\domain\usecases\set_wallpaper.dart
copy lib\domain\usecases\toggle_favorite.dart lib\features\wallpapers\domain\usecases\toggle_favorite.dart
copy lib\domain\usecases\get_favorite_wallpapers.dart lib\features\wallpapers\domain\usecases\get_favorite_wallpapers.dart

REM Copy wallpaper presentation files
copy lib\presentation\providers\wallpaper_provider.dart lib\features\wallpapers\presentation\providers\wallpaper_provider.dart
copy lib\presentation\providers\favorites_provider.dart lib\features\wallpapers\presentation\providers\favorites_provider.dart
copy lib\presentation\screens\new_wallpaper_detail_screen.dart lib\features\wallpapers\presentation\screens\wallpaper_detail_screen.dart
copy lib\presentation\screens\new_explore_screen.dart lib\features\wallpapers\presentation\screens\explore_screen.dart
copy lib\presentation\screens\new_saved_screen.dart lib\features\wallpapers\presentation\screens\saved_screen.dart
copy lib\presentation\widgets\wallpaper_card.dart lib\features\wallpapers\presentation\widgets\wallpaper_card.dart
copy lib\presentation\widgets\wallpaper_grid.dart lib\features\wallpapers\presentation\widgets\wallpaper_grid.dart
copy lib\presentation\widgets\download_progress_indicator.dart lib\features\wallpapers\presentation\widgets\download_progress_indicator.dart

REM Move category feature files
echo Moving category feature files...
mkdir lib\features\categories\data\models lib\features\categories\data\repositories lib\features\categories\data\datasources
mkdir lib\features\categories\domain\entities lib\features\categories\domain\repositories lib\features\categories\domain\usecases
mkdir lib\features\categories\presentation\providers lib\features\categories\presentation\screens lib\features\categories\presentation\widgets

REM Copy category models
copy lib\data\models\app\category.dart lib\features\categories\domain\entities\category.dart
copy lib\data\models\unsplash\unsplash_topic.dart lib\features\categories\data\models\unsplash_topic.dart

REM Copy category use cases
copy lib\domain\usecases\get_categories.dart lib\features\categories\domain\usecases\get_categories.dart
copy lib\domain\usecases\get_wallpapers_by_category.dart lib\features\categories\domain\usecases\get_wallpapers_by_category.dart

REM Copy category presentation files
copy lib\presentation\providers\category_provider.dart lib\features\categories\presentation\providers\category_provider.dart
copy lib\presentation\screens\new_categories_screen.dart lib\features\categories\presentation\screens\categories_screen.dart
copy lib\presentation\screens\new_category_wallpapers_screen.dart lib\features\categories\presentation\screens\category_wallpapers_screen.dart

REM Move auth feature files
echo Moving auth feature files...
mkdir lib\features\auth\data\models lib\features\auth\data\repositories lib\features\auth\data\datasources
mkdir lib\features\auth\domain\entities lib\features\auth\domain\repositories lib\features\auth\domain\usecases
mkdir lib\features\auth\presentation\providers lib\features\auth\presentation\screens lib\features\auth\presentation\widgets

REM Copy auth services
copy lib\services\auth_service.dart lib\features\auth\data\repositories\auth_repository_impl.dart
copy lib\services\firebase_service.dart lib\features\auth\data\datasources\firebase_auth_datasource.dart

REM Move settings feature files
echo Moving settings feature files...
mkdir lib\features\settings\data\models lib\features\settings\data\repositories lib\features\settings\data\datasources
mkdir lib\features\settings\domain\entities lib\features\settings\domain\repositories lib\features\settings\domain\usecases
mkdir lib\features\settings\presentation\providers lib\features\settings\presentation\screens lib\features\settings\presentation\widgets

REM Copy settings presentation files
copy lib\presentation\providers\theme_provider.dart lib\features\settings\presentation\providers\theme_provider.dart
copy lib\presentation\widgets\cache_settings.dart lib\features\settings\presentation\widgets\cache_settings.dart
copy lib\presentation\screens\about_screen.dart lib\features\settings\presentation\screens\about_screen.dart
copy lib\presentation\screens\privacy_policy_screen.dart lib\features\settings\presentation\screens\privacy_policy_screen.dart
copy lib\presentation\screens\terms_conditions_screen.dart lib\features\settings\presentation\screens\terms_conditions_screen.dart

REM Create common widgets directory
echo Creating common widgets directory...
mkdir lib\presentation\common\widgets
copy lib\presentation\widgets\app_header.dart lib\presentation\common\widgets\app_header.dart
copy lib\presentation\widgets\connectivity_indicator.dart lib\presentation\common\widgets\connectivity_indicator.dart
copy lib\presentation\widgets\feedback_dialog.dart lib\presentation\common\widgets\feedback_dialog.dart
copy lib\widgets\edit_profile_dialog.dart lib\presentation\common\widgets\edit_profile_dialog.dart

REM Create app-level screens
echo Creating app-level screens...
mkdir lib\presentation\app
copy lib\presentation\screens\new_home_screen.dart lib\presentation\app\home_screen.dart
copy lib\presentation\screens\new_splash_screen.dart lib\presentation\app\splash_screen.dart

echo Migration complete!
echo Note: This script only copies files to the new structure. You'll need to update imports and make other adjustments manually.
echo See CODEBASE_STRUCTURE.md for more details on the new structure.
