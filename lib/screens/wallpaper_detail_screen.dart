// Copyright 2025 Shantanu Sen Gupta
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/wallpaper.dart';
import '../services/wallpaper_service.dart';

class WallpaperDetailScreen extends StatefulWidget {
  final Wallpaper wallpaper;

  const WallpaperDetailScreen({
    super.key,
    required this.wallpaper,
  });

  @override
  State<WallpaperDetailScreen> createState() => _WallpaperDetailScreenState();
}

class _WallpaperDetailScreenState extends State<WallpaperDetailScreen> {
  bool _isLoading = false;
  String? _error;
  Timer? _errorTimer;

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to prevent memory leaks
    _errorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallpaperService = Provider.of<WallpaperService>(context);
    final isFavorite = wallpaperService.isFavorite(widget.wallpaper.id);

    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? theme.colorScheme.error : theme.colorScheme.onSurface,
            ),
            onPressed: () {
              wallpaperService.toggleFavorite(widget.wallpaper);
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Wallpaper Image
          Hero(
            tag: 'wallpaper_${widget.wallpaper.id}',
            child: Image.network(
              widget.wallpaper.url,
            fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
            ),
          ),

          // Bottom Action Buttons
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.image,
                  label: 'Info',
                  onTap: () {
                    _showWallpaperInfo();
                  },
                ),
                _buildActionButton(
                  icon: Icons.download,
                  label: 'Download',
                  onTap: () {
                    _downloadWallpaper();
                  },
                ),
                _buildActionButton(
                  icon: Icons.wallpaper,
                  label: 'Apply',
                  onTap: () {
                    _showSetWallpaperOptions();
                  },
                ),
              ],
            ),
          ),

          // Loading indicator
          if (_isLoading)
            Container(
              color: Colors.black.withAlpha(128), // 0.5 * 255 = 128
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),

          // Error message
          if (_error != null)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withAlpha(204), // 0.8 * 255 = 204
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withAlpha(51), // 0.2 * 255 = 51
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  _error!,
                  style: TextStyle(
                    color: theme.colorScheme.onError,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showWallpaperInfo() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
            const Text(
              'Wallpaper Info',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _infoRow('Photographer', widget.wallpaper.photographer),
            _infoRow('Category', widget.wallpaper.category),
            _infoRow('Resolution', '${widget.wallpaper.width} x ${widget.wallpaper.height}'),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  Future<void> _downloadWallpaper() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final wallpaperService = Provider.of<WallpaperService>(context, listen: false);
      final path = await wallpaperService.downloadWallpaper(widget.wallpaper);

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      if (path != null) {
            ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wallpaper downloaded successfully')),
        );
      } else {
        throw Exception('Failed to download wallpaper');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to download: ${e.toString()}';
      });

      // Clear error after a few seconds using a timer that we can cancel if needed
      _errorTimer?.cancel(); // Cancel any existing timer
      _errorTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _error = null;
          });
        }
      });
    }
  }

  void _showSetWallpaperOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Set as Wallpaper',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home Screen'),
              onTap: () {
                Navigator.pop(context);
                _setWallpaper(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Lock Screen'),
              onTap: () {
                Navigator.pop(context);
                _setWallpaper(2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone_android),
              title: const Text('Both'),
              onTap: () {
                Navigator.pop(context);
                _setWallpaper(3);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setWallpaper(int location) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final wallpaperService = Provider.of<WallpaperService>(context, listen: false);
      final success = await wallpaperService.setWallpaper(widget.wallpaper, location);

      setState(() {
        _isLoading = false;
      });

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wallpaper set successfully')),
          );
        }
      } else {
        throw Exception('Failed to set wallpaper');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to set wallpaper: ${e.toString()}';
      });

      // Clear error after a few seconds using a timer that we can cancel if needed
      _errorTimer?.cancel(); // Cancel any existing timer
      _errorTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _error = null;
          });
        }
      });
    }
  }
}