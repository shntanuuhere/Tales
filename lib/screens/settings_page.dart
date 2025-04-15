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
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _userName = '';
  String _userEmail = '';
  String _loginMethod = '';
  String _profilePhoto = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'User';
      _userEmail = prefs.getString('userEmail') ?? '';
      _loginMethod = prefs.getString('loginMethod') ?? '';
      _profilePhoto = prefs.getString('userPhoto') ?? '';
    });
  }

  Future<void> _editProfile() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _EditProfileDialog(
        initialName: _userName,
        initialEmail: _userEmail,
      ),
    );

    if (result != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', result['name']!);
      await prefs.setString('userEmail', result['email']!);
      _loadUserData();
    }
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: _profilePhoto.isNotEmpty
                    ? NetworkImage(_profilePhoto) as ImageProvider
                    : const AssetImage('assets/images/profile.jpg'),
              ),
              Positioned(
                right: -4,
                bottom: -4,
                child: IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: _editProfile,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _userName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                _userEmail,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.redAccent[100]),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        // Handle navigation based on the tile title
        switch (title) {
          case 'Connected Apps':
            _showFeatureDialog('Connected Apps');
            break;
          case 'Account':
            _showFeatureDialog('Account Settings');
            break;
          case 'Privacy':
            Navigator.pushNamed(context, '/privacy');
            break;
          case 'Avatar':
            _showFeatureDialog('Avatar Settings');
            break;
          case 'Chats':
            _showFeatureDialog('Chat Settings');
            break;
          case 'Notifications':
            _showFeatureDialog('Notification Settings');
            break;
          case 'Storage and data':
            _showFeatureDialog('Storage Settings');
            break;
          case 'App language':
            _showFeatureDialog('Language Settings');
            break;
          case 'Help':
            Navigator.pushNamed(context, '/about');
            break;
        }
      },
    );
  }

  // Helper method to show a dialog for features that are not yet implemented
  void _showFeatureDialog(String featureName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(featureName),
        content: Text('This feature will be available soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildProfileSection(),
          const Divider(),
          _buildSettingsTile(
            'Connected Apps',
            'Signed in with ${_loginMethod.isNotEmpty ? _loginMethod[0].toUpperCase() + _loginMethod.substring(1) : "Email"}',
            Icons.apps_outlined,
          ),
          _buildSettingsTile(
            'Account',
            'Security notifications, change number',
            Icons.person_outline,
          ),
          _buildSettingsTile(
            'Privacy',
            'Block contacts, disappearing messages',
            Icons.lock_outline,
          ),
          _buildSettingsTile(
            'Avatar',
            'Create, edit, profile photo',
            Icons.face_outlined,
          ),
          _buildSettingsTile(
            'Chats',
            'Theme, wallpapers, chat history',
            Icons.chat_bubble_outline,
          ),
          _buildSettingsTile(
            'Notifications',
            'Message, group & call tones',
            Icons.notifications_none,
          ),
          _buildSettingsTile(
            'Storage and data',
            'Network usage, auto-download',
            Icons.storage_outlined,
          ),
          _buildSettingsTile(
            'App language',
            'English (device\'s language)',
            Icons.language_outlined,
          ),
          _buildSettingsTile(
            'Help',
            'Help centre, contact us, privacy policy',
            Icons.help_outline,
          ),
        ],
      ),
    );
  }
}

class _EditProfileDialog extends StatefulWidget {
  final String initialName;
  final String initialEmail;

  const _EditProfileDialog({
    required this.initialName,
    required this.initialEmail,
  });

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop({
              'name': _nameController.text,
              'email': _emailController.text,
            });
          },
          child: const Text('SAVE'),
        ),
      ],
    );
  }
}
