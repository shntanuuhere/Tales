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

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Theme.of(context).colorScheme.primary,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Profile Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(Icons.person, size: 32, color: Colors.white),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Guest User',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text('guest@example.com'),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),

          // Account Settings
          _buildSettingItem(
            context: context,
            icon: Icons.account_circle,
            title: 'Account',
            subtitle: 'Login details, delete account',
            onTap: () {},
          ),

          // Privacy Settings
          _buildSettingItem(
            context: context,
            icon: Icons.lock,
            title: 'Privacy',
            subtitle: 'Biometric authentication',
            onTap: () {},
          ),

          // Avatar Settings
          _buildSettingItem(
            context: context,
            icon: Icons.face,
            title: 'Avatar',
            subtitle: 'Edit profile name/photo',
            onTap: () {},
          ),

          // Theme Settings
          _buildSettingItem(
            context: context,
            icon: Icons.palette,
            title: 'Themes',
            subtitle: 'Dark or light mode',
            onTap: () {},
          ),

          // Notification Settings
          _buildSettingItem(
            context: context,
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Push notification preferences',
            onTap: () {},
          ),

          const Divider(),

          // Help & Legal
          _buildSettingItem(
            context: context,
            icon: Icons.help,
            title: 'Help',
            subtitle: 'Privacy policy, terms, about us',
            onTap: () {},
          ),

          // App Version
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Image.asset(
                  'assets/images/logo.png',
                  height: 48,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tales v1.0.0',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.facebook),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.link),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.email),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}