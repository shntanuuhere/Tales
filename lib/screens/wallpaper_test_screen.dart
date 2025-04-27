import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/wallpaper_service.dart';
import '../models/wallpaper.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WallpaperTestScreen extends StatefulWidget {
  const WallpaperTestScreen({super.key});

  @override
  State<WallpaperTestScreen> createState() => _WallpaperTestScreenState();
}

class _WallpaperTestScreenState extends State<WallpaperTestScreen> {
  String? _downloadedPath;
  bool _isLoading = false;
  String _resultMessage = '';
  bool _isSuccess = true;
  double _progressValue = 0.0;

  final List<String> _testImages = [
    'https://images.pexels.com/photos/2486168/pexels-photo-2486168.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    'https://images.pexels.com/photos/1366630/pexels-photo-1366630.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    'https://images.pexels.com/photos/799443/pexels-photo-799443.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  ];

  int _selectedImageIndex = 0;

  Future<void> _downloadImage() async {
    setState(() {
      _isLoading = true;
      _resultMessage = 'Downloading image...';
      _progressValue = 0.1;
    });

    try {
      // Simulate progress
      for (int i = 2; i <= 8; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        setState(() {
          _progressValue = i / 10;
        });
      }

      // Use cache manager to download the image
      final file = await DefaultCacheManager().getSingleFile(_testImages[_selectedImageIndex]);

      if (!mounted) return;
      setState(() {
        _downloadedPath = file.path;
        _resultMessage = 'Image downloaded successfully!';
        _isSuccess = true;
        _progressValue = 1.0;
      });

      await Future.delayed(const Duration(milliseconds: 200));
    } catch (e) {
      setState(() {
        _resultMessage = 'Failed to download image: $e';
        _isSuccess = false;
        _progressValue = 0.0;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _setHomeScreenWallpaper() async {
    if (_downloadedPath == null) {
      await _downloadImage();
      if (_downloadedPath == null || !mounted) return;
    }

    // Get the service before the async gap
    final wallpaperService = Provider.of<WallpaperService>(context, listen: false);

    setState(() {
      _isLoading = true;
      _resultMessage = 'Setting home screen wallpaper...';
      _progressValue = 0.3;
    });

    try {
      // Simulate progress
      for (int i = 4; i <= 8; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        if (!mounted) return;
        setState(() {
          _progressValue = i / 10;
        });
      }
      // Create a temporary Wallpaper object for the downloaded image
      final tempWallpaper = Wallpaper(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        url: _testImages[_selectedImageIndex],
        thumbnailUrl: _testImages[_selectedImageIndex],
        category: 'Downloaded',
        photographer: 'Test User',
        width: 1920,
        height: 1080
      );
      final success = await wallpaperService.setHomeScreenWallpaper(tempWallpaper);

      if (!mounted) return;
      setState(() {
        _resultMessage = success
          ? 'Home screen wallpaper set successfully!'
          : 'Failed to set home screen wallpaper';
        _isSuccess = success;
        _progressValue = success ? 1.0 : 0.0;
      });

      await Future.delayed(const Duration(milliseconds: 200));
    } catch (e) {
      setState(() {
        _resultMessage = 'Error setting home screen wallpaper: $e';
        _isSuccess = false;
        _progressValue = 0.0;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _setLockScreenWallpaper() async {
    if (_downloadedPath == null) {
      await _downloadImage();
      if (_downloadedPath == null || !mounted) return;
    }

    // Get the service before the async gap
    final wallpaperService = Provider.of<WallpaperService>(context, listen: false);

    setState(() {
      _isLoading = true;
      _resultMessage = 'Setting lock screen wallpaper...';
      _progressValue = 0.3;
    });

    try {

      // Simulate progress
      for (int i = 4; i <= 8; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        if (!mounted) return;
        setState(() {
          _progressValue = i / 10;
        });
      }
      // Create a temporary Wallpaper object for the downloaded image
      final tempWallpaper = Wallpaper(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        url: _testImages[_selectedImageIndex],
        thumbnailUrl: _testImages[_selectedImageIndex],
        category: 'Downloaded',
        photographer: 'Test User',
        width: 1920,
        height: 1080
      );
      final success = await wallpaperService.setLockScreenWallpaper(tempWallpaper);

      if (!mounted) return;
      setState(() {
        _resultMessage = success
          ? 'Lock screen wallpaper set successfully!'
          : 'Failed to set lock screen wallpaper';
        _isSuccess = success;
        _progressValue = success ? 1.0 : 0.0;
      });

      await Future.delayed(const Duration(milliseconds: 200));
    } catch (e) {
      setState(() {
        _resultMessage = 'Error setting lock screen wallpaper: $e';
        _isSuccess = false;
        _progressValue = 0.0;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _setBothScreensWallpaper() async {
    if (_downloadedPath == null) {
      await _downloadImage();
      if (_downloadedPath == null || !mounted) return;
    }

    // Get the service before the async gap
    final wallpaperService = Provider.of<WallpaperService>(context, listen: false);

    setState(() {
      _isLoading = true;
      _resultMessage = 'Setting wallpaper on both screens...';
      _progressValue = 0.3;
    });

    try {

      // Simulate progress
      for (int i = 4; i <= 8; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        if (!mounted) return;
        setState(() {
          _progressValue = i / 10;
        });
      }
      // Create a temporary Wallpaper object for the downloaded image
      final tempWallpaper = Wallpaper(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        url: _testImages[_selectedImageIndex],
        thumbnailUrl: _testImages[_selectedImageIndex],
        category: 'Downloaded',
        photographer: 'Test User',
        width: 1920,
        height: 1080
      );
      final success = await wallpaperService.setWallpaper(tempWallpaper, 3); // 3 for both screens

      if (!mounted) return;
      setState(() {
        _resultMessage = success
          ? 'Wallpaper set on both screens successfully!'
          : 'Failed to set wallpaper on both screens';
        _isSuccess = success;
        _progressValue = success ? 1.0 : 0.0;
      });

      await Future.delayed(const Duration(milliseconds: 200));
    } catch (e) {
      setState(() {
        _resultMessage = 'Error setting wallpaper on both screens: $e';
        _isSuccess = false;
        _progressValue = 0.0;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey[100],
      appBar: AppBar(
        title: const Text('Wallpaper Testing Tool'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(26), // 0.1 * 255 = 26
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Instructions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '1. Choose a sample image below\n2. Download the image\n3. Set it as your wallpaper',
                      style: TextStyle(
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ).animate().fade(duration: 300.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: 24),

              // Image selector
              Text(
                'Choose an Image',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _testImages.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedImageIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImageIndex = index;
                          _downloadedPath = null;
                        });
                      },
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? primaryColor : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(26), // 0.1 * 255 = 26
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            _testImages[index],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: isDark ? Colors.grey[800] : Colors.grey[300],
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: progress.expectedTotalBytes != null
                                        ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                                        : null,
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ).animate().fade(duration: 400.ms).slideX(begin: 0.2, end: 0),

              const SizedBox(height: 24),

              // Display the selected image
              Container(
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(51), // 0.2 * 255 = 51
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    _testImages[_selectedImageIndex],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: isDark ? Colors.grey[800] : Colors.grey[300],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ).animate().fade(duration: 500.ms).scale(begin: const Offset(0.95, 0.95)),

              const SizedBox(height: 24),

              // Status message
              if (_resultMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isSuccess
                      ? (isDark ? Colors.green.shade900.withAlpha(77) : Colors.green.shade50) // 0.3 * 255 = 77
                      : (isDark ? Colors.red.shade900.withAlpha(77) : Colors.red.shade50), // 0.3 * 255 = 77
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isSuccess ? Colors.green.shade300 : Colors.red.shade300,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isSuccess ? Icons.check_circle : Icons.error,
                        color: _isSuccess ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _resultMessage,
                          style: TextStyle(
                            color: _isSuccess
                              ? (isDark ? Colors.green.shade100 : Colors.green.shade700)
                              : (isDark ? Colors.red.shade100 : Colors.red.shade700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fade(duration: 300.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: 24),

              // Buttons
              if (_isLoading)
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: _progressValue,
                      backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _resultMessage,
                      style: TextStyle(
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildButton(
                      icon: Icons.download,
                      label: 'Download Image',
                      onPressed: _downloadImage,
                      color: Colors.blue,
                      isDark: isDark,
                    ),

                    const SizedBox(height: 16),

                    _buildButton(
                      icon: Icons.home,
                      label: 'Set as Home Screen',
                      onPressed: _setHomeScreenWallpaper,
                      color: Colors.green,
                      isDark: isDark,
                    ),

                    const SizedBox(height: 16),

                    _buildButton(
                      icon: Icons.lock,
                      label: 'Set as Lock Screen',
                      onPressed: _setLockScreenWallpaper,
                      color: Colors.purple,
                      isDark: isDark,
                    ),

                    const SizedBox(height: 16),

                    _buildButton(
                      icon: Icons.smartphone,
                      label: 'Set on Both Screens',
                      onPressed: _setBothScreensWallpaper,
                      color: Colors.orange,
                      isDark: isDark,
                    ),
                  ],
                ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
    required bool isDark,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? color.withAlpha(51) : color, // 0.2 * 255 = 51
        foregroundColor: isDark ? color : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: isDark ? 0 : 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 500.ms, delay: 100.ms).slideY(begin: 0.2, end: 0);
  }
}