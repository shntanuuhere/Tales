import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_screen.dart';
import 'settings_page.dart';
import 'games_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    const HomeScreen(),
    const GamesPage(),
    const SettingsPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _navItem(String label, String assetName, int index, ThemeData theme) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTapped(index),
        child: Container(
          decoration: isSelected
              ? BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 3, color: theme.colorScheme.secondary),
                  ),
                )
              : null,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                assetName,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isSelected ? theme.colorScheme.secondary : Colors.grey,
                  BlendMode.srcIn
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? theme.colorScheme.secondary : Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: const Border(top: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        child: Row(
          children: [
            _navItem("Home", "assets/icons/home.svg", 0, theme),
            _navItem("Spotify", "assets/icons/spotify.svg", 1, theme),
            _navItem("Local", "assets/icons/cd.svg", 2, theme),
            _navItem("Games", "assets/icons/games.svg", 3, theme),
            _navItem("Settings", "assets/icons/settings.svg", 4, theme),
          ],
        ),
      ),
    );
  }
}
