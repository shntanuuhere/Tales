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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          // Appearance Section
          _buildSectionHeader(context, 'Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable dark theme'),
            value: themeService.isDarkMode,
            onChanged: (value) {
              themeService.toggleTheme();
            },
          ),
          const Divider(),

          // Legal Section
          _buildSectionHeader(context, 'Legal'),
                  ListTile(
            title: const Text('Privacy Policy'),
            leading: const Icon(Icons.privacy_tip),
            onTap: () {
              // Would navigate to privacy policy
                        ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy Policy would open here')),
                        );
                    },
                  ),
                  ListTile(
            title: const Text('Terms of Service'),
            leading: const Icon(Icons.description),
            onTap: () {
              // Would navigate to terms of service
                        ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Terms of Service would open here')),
              );
            },
          ),
          const Divider(),

          // About Section
          _buildSectionHeader(context, 'About'),
                  const ListTile(
                    title: Text('App Version'),
                    subtitle: Text('1.0.0'),
            leading: Icon(Icons.info),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}