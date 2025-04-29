import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/wallpapers/presentation/providers/wallpaper_provider.dart';
import '../../features/categories/presentation/providers/category_provider.dart';
import '../../features/wallpapers/presentation/providers/favorites_provider.dart';
import '../common/widgets/connectivity_indicator.dart';
import '../../features/wallpapers/presentation/screens/explore_screen.dart';
import '../../features/categories/presentation/screens/categories_screen.dart';
import '../../features/wallpapers/presentation/screens/saved_screen.dart';

/// The home screen with bottom tabs
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize data after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    try {
      // Get providers
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      final wallpaperProvider = Provider.of<WallpaperProvider>(context, listen: false);
      final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);

      // Load data
      await categoryProvider.fetchCategories();
      await wallpaperProvider.fetchWallpapers();
      await favoritesProvider.loadFavorites();
    } catch (e) {
      debugPrint('Error initializing data: $e');
      // Show error message if needed
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Define screens
    final List<Widget> screens = [
      // Explore screen with tabs for Popular and New Walls
      const ExploreScreen(),

      // Categories screen
      const CategoriesScreen(),

      // Saved/Favorites screen
      const SavedScreen(),
    ];

    return ConnectivitySnackbar(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
          selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
          unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              activeIcon: Icon(Icons.category),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined),
              activeIcon: Icon(Icons.favorite),
              label: 'Saved',
            ),
          ],
        ),
      ),
    );
  }
}
