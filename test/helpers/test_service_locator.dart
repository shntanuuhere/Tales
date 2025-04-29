import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:tales/features/wallpapers/domain/usecases/get_wallpapers.dart';
import 'package:tales/features/categories/domain/usecases/get_wallpapers_by_category.dart';
import 'package:tales/features/wallpapers/domain/usecases/toggle_favorite.dart';
import 'package:tales/features/wallpapers/domain/usecases/download_wallpaper.dart';
import 'package:tales/features/wallpapers/domain/usecases/set_wallpaper.dart';
import 'package:tales/core/network/connectivity_service.dart';
import 'package:tales/core/utils/api/api_cache.dart';
import 'package:tales/core/network/offline_manager.dart';

// Use the same instance as the app
final serviceLocator = GetIt.instance;

/// Initialize the test service locator with mock dependencies
void initTestServiceLocator() {
  // Reset the service locator if it's already been initialized
  if (serviceLocator.isRegistered<ConnectivityService>()) {
    serviceLocator.reset();
  }

  // Register mock services
  serviceLocator.registerLazySingleton<ConnectivityService>(
    () => MockConnectivityService(),
  );

  serviceLocator.registerLazySingleton<ApiCache>(
    () => MockApiCache(),
  );

  serviceLocator.registerLazySingleton<OfflineManager>(
    () => MockOfflineManager(),
  );



  // Register mock use cases
  serviceLocator.registerLazySingleton<GetWallpapers>(
    () => MockGetWallpapers(),
  );

  serviceLocator.registerLazySingleton<GetWallpapersByCategory>(
    () => MockGetWallpapersByCategory(),
  );

  serviceLocator.registerLazySingleton<ToggleFavorite>(
    () => MockToggleFavorite(),
  );

  serviceLocator.registerLazySingleton<DownloadWallpaper>(
    () => MockDownloadWallpaper(),
  );

  serviceLocator.registerLazySingleton<SetWallpaper>(
    () => MockSetWallpaper(),
  );
}

// Mock classes
class MockConnectivityService extends Mock implements ConnectivityService {}
class MockApiCache extends Mock implements ApiCache {}
class MockOfflineManager extends Mock implements OfflineManager {}

class MockGetWallpapers extends Mock implements GetWallpapers {}
class MockGetWallpapersByCategory extends Mock implements GetWallpapersByCategory {}
class MockToggleFavorite extends Mock implements ToggleFavorite {}
class MockDownloadWallpaper extends Mock implements DownloadWallpaper {}
class MockSetWallpaper extends Mock implements SetWallpaper {}
