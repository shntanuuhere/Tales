import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/api/api_cache.dart';
import '../../../../core/network/offline_manager.dart';
import '../../../../core/network/connectivity_service.dart';

/// A widget for managing cache settings
class CacheSettingsScreen extends StatefulWidget {
  /// Constructor
  const CacheSettingsScreen({super.key});

  @override
  State<CacheSettingsScreen> createState() => _CacheSettingsScreenState();
}

class _CacheSettingsScreenState extends State<CacheSettingsScreen> {
  bool _isLoading = false;
  String? _lastUpdateTime;
  int _cacheSize = 0;

  @override
  void initState() {
    super.initState();
    _loadCacheInfo();
  }

  /// Load cache information
  Future<void> _loadCacheInfo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get last update time
      final offlineManager = OfflineManager();
      final lastUpdate = await offlineManager.getLastUpdate();

      if (lastUpdate != null) {
        setState(() {
          _lastUpdateTime = '${lastUpdate.day}/${lastUpdate.month}/${lastUpdate.year} ${lastUpdate.hour}:${lastUpdate.minute}';
        });
      } else {
        setState(() {
          _lastUpdateTime = 'Never';
        });
      }

      // Get cache size (approximate)
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      int totalSize = 0;

      for (final key in keys) {
        if (key.startsWith('api_cache_') || key.startsWith('offline_')) {
          final value = prefs.getString(key);
          if (value != null) {
            totalSize += value.length;
          }
        }
      }

      // Convert to KB
      setState(() {
        _cacheSize = totalSize ~/ 1024;
      });
    } catch (e) {
      debugPrint('Failed to load cache info: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Clear all cache
  Future<void> _clearCache() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Show confirmation dialog
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Clear Cache'),
          content: const Text('Are you sure you want to clear all cached data? This will remove all offline content.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Clear'),
            ),
          ],
        ),
      );

      if (confirmed != true) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Clear API cache
      final apiCache = ApiCache();
      await apiCache.clearAll();

      // Clear offline data
      final offlineManager = OfflineManager();
      await offlineManager.clearAll();

      // Reload cache info
      await _loadCacheInfo();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cache cleared successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('Failed to clear cache: $e');

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to clear cache: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectivityService = Provider.of<ConnectivityService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cache Settings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Cache info
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cache Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Cache Size:'),
                            Text('$_cacheSize KB'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Last Update:'),
                            Text(_lastUpdateTime ?? 'Never'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Network Status:'),
                            Row(
                              children: [
                                Icon(
                                  connectivityService.isConnected
                                      ? Icons.wifi
                                      : Icons.wifi_off,
                                  size: 16,
                                  color: connectivityService.isConnected
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  connectivityService.isConnected
                                      ? connectivityService.isWifi
                                          ? 'WiFi'
                                          : 'Mobile Data'
                                      : 'Offline',
                                  style: TextStyle(
                                    color: connectivityService.isConnected
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Cache actions
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cache Actions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text('Clear Cache'),
                          subtitle: const Text('Remove all cached data'),
                          onTap: _clearCache,
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.refresh),
                          title: const Text('Refresh Cache Info'),
                          subtitle: const Text('Update cache information'),
                          onTap: _loadCacheInfo,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Cache explanation
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About Caching',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'The app caches data to improve performance and allow offline use. '
                          'Cached data includes wallpapers, categories, and other app content. '
                          'Clearing the cache will remove all cached data, but will not affect your favorites or settings.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
