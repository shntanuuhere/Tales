import 'package:flutter/material.dart';

/// A screen that displays information about the app and its creators
class AboutScreen extends StatelessWidget {
  /// Constructor
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/logo/tales.png',
                height: 100,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image,
                  size: 100,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Tales',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Beautiful Wallpapers for Your Device',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Text(
              'Our Mission',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tales is designed to bring beautiful, high-quality wallpapers to your device. We believe in creating a simple, elegant experience that helps you personalize your digital world.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            Text(
              'The Team',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTeamMember(
              context,
              name: 'Jane Smith',
              role: 'Founder & Lead Developer',
              avatar: Icons.code,
            ),
            _buildTeamMember(
              context,
              name: 'John Doe',
              role: 'UI/UX Designer',
              avatar: Icons.design_services,
            ),
            _buildTeamMember(
              context,
              name: 'Sarah Johnson',
              role: 'Product Manager',
              avatar: Icons.work,
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            Text(
              'Contact Us',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Have questions or feedback? We\'d love to hear from you!',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.email),
                  onPressed: () {},
                  tooltip: 'Email us',
                ),
                IconButton(
                  icon: const Icon(Icons.language),
                  onPressed: () {},
                  tooltip: 'Visit our website',
                ),
                IconButton(
                  icon: const Icon(Icons.star),
                  onPressed: () {},
                  tooltip: 'Rate us',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '© 2024 Tales App. All rights reserved.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(153), // 0.6 opacity
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember(
    BuildContext context, {
    required String name,
    required String role,
    required IconData avatar,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: theme.colorScheme.primary.withAlpha(51), // 0.2 opacity
            child: Icon(
              avatar,
              size: 30,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: theme.textTheme.titleMedium,
              ),
              Text(
                role,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
