import 'package:get_it/get_it.dart';

import '../data/api/unsplash_api_client.dart';
import '../features/wallpapers/domain/repositories/wallpaper_repository.dart';
import '../features/wallpapers/data/repositories/unsplash_repository.dart';
import '../features/wallpapers/domain/usecases/get_wallpapers.dart';
import '../features/categories/domain/usecases/get_wallpapers_by_category.dart';
import '../features/categories/domain/usecases/get_categories.dart';
import '../features/wallpapers/domain/usecases/toggle_favorite.dart';
import '../features/wallpapers/domain/usecases/download_wallpaper.dart';
import '../features/wallpapers/domain/usecases/set_wallpaper.dart';
import '../features/wallpapers/domain/usecases/get_favorite_wallpapers.dart';
import '../features/wallpapers/presentation/providers/wallpaper_provider.dart';
import '../features/categories/presentation/providers/category_provider.dart';
import '../features/wallpapers/presentation/providers/favorites_provider.dart';
import '../features/settings/presentation/providers/theme_provider.dart';
import '../core/network/connectivity_service.dart';

/// Service locator for dependency injection
final GetIt serviceLocator = GetIt.instance;

/// Initialize the service locator
void initServiceLocator() {
  // API clients
  serviceLocator.registerLazySingleton<UnsplashApiClient>(
    () => UnsplashApiClient(),
  );

  // Repositories
  serviceLocator.registerLazySingleton<WallpaperRepository>(
    () => UnsplashRepository(
      apiClient: serviceLocator<UnsplashApiClient>(),
    ),
  );

  // Use cases
  serviceLocator.registerLazySingleton<GetWallpapers>(
    () => GetWallpapers(
      serviceLocator<WallpaperRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<GetWallpapersByCategory>(
    () => GetWallpapersByCategory(
      serviceLocator<WallpaperRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<GetCategories>(
    () => GetCategories(
      serviceLocator<WallpaperRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<ToggleFavorite>(
    () => ToggleFavorite(
      serviceLocator<WallpaperRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<DownloadWallpaper>(
    () => DownloadWallpaper(
      serviceLocator<WallpaperRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<SetWallpaper>(
    () => SetWallpaper(
      serviceLocator<WallpaperRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<GetFavoriteWallpapers>(
    () => GetFavoriteWallpapers(
      serviceLocator<WallpaperRepository>(),
    ),
  );

  // Providers
  serviceLocator.registerFactory<WallpaperProvider>(
    () => WallpaperProvider(
      getWallpapers: serviceLocator<GetWallpapers>(),
      getWallpapersByCategory: serviceLocator<GetWallpapersByCategory>(),
      toggleFavorite: serviceLocator<ToggleFavorite>(),
      downloadWallpaper: serviceLocator<DownloadWallpaper>(),
      setWallpaper: serviceLocator<SetWallpaper>(),
    ),
  );

  serviceLocator.registerFactory<CategoryProvider>(
    () => CategoryProvider(
      getCategories: serviceLocator<GetCategories>(),
    ),
  );

  serviceLocator.registerFactory<FavoritesProvider>(
    () => FavoritesProvider(
      getFavoriteWallpapers: serviceLocator<GetFavoriteWallpapers>(),
      toggleFavorite: serviceLocator<ToggleFavorite>(),
    ),
  );

  // Theme provider
  serviceLocator.registerFactory<ThemeProvider>(
    () => ThemeProvider(false), // Default to light mode
  );

  // Services
  serviceLocator.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService(),
  );

  // iOS-specific services are now handled in the platform-specific implementations
}
