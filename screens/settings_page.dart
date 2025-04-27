import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/theme_notifier.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.themeMode == ThemeMode.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Settings',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDarkMode
                        ? [Colors.grey[900]!, Colors.grey[800]!]
                        : [Colors.blue[400]!, Colors.blue[300]!],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage('assets/images/profile_placeholder.png'),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Welcome to Tales!',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        '#hereco',
                        style: TextStyle(
                            color: Colors.white.withValues(red: 255, green: 255, blue: 255, alpha: 179),
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSettingsCard(
                    context,
                    title: 'Preferences',
                    children: [
                      SwitchListTile(
                        title: const Text('Dark Mode'),
                        subtitle: Text(isDarkMode ? 'Dark theme enabled' : 'Light theme enabled'),
                        value: isDarkMode,
                        onChanged: (value) => themeNotifier.toggleTheme(value),
                        secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
                      ),
                      _buildSettingsTile(
                        title: 'Biometric Login',
                        subtitle: 'Will integrate in future',
                        icon: Icons.fingerprint,
                        onTap: () {},
                      ),
                      _buildSettingsTile(
                        title: 'Linked Accounts',
                        subtitle: 'Will integrate in future',
                        icon: Icons.link,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSettingsCard(
                    context,
                    title: 'Information',
                    children: [
                      _buildSettingsTile(
                        title: 'Privacy Policy',
                        icon: Icons.privacy_tip_outlined,
                        onTap: () => Navigator.pushNamed(context, '/privacy'),
                      ),
                      _buildSettingsTile(
                        title: 'Terms & Conditions',
                        icon: Icons.description_outlined,
                        onTap: () => Navigator.pushNamed(context, '/terms'),
                      ),
                      _buildSettingsTile(
                        title: 'Licenses',
                        icon: Icons.policy_outlined,
                        onTap: () => showLicensePage(context: context),
                      ),
                      _buildSettingsTile(
                        title: 'Partners & Credits',
                        icon: Icons.people_outline,
                        onTap: () => Navigator.pushNamed(context, '/about'),
                      ),
                      _buildSettingsTile(
                        title: 'Send Feedback',
                        icon: Icons.feedback_outlined,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('📬 Will integrate in future')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildFooter(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context,
      {required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Tales v1.0.1-beta',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        const Opacity(
          opacity: 0.2,
          child: Column(
            children: [
              Icon(Icons.auto_awesome, size: 40),
              Text('hereco', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              context,
              'assets/icons/x_icon.svg',
              'https://x.com/shntanuuhere?s=21&t=pTqV5eeP2jW09Fh9r7TKsQ',
            ),
            _buildSocialButton(
              context,
              'assets/icons/insta_icon.svg',
              'https://www.instagram.com/shntanuuhere?igsh=cXczNnViOWtpbnJu&utm_source=qr',
            ),
            _buildSocialButton(
              context,
              'assets/icons/linkedin_icon.svg',
              'http://linkedin.com/in/shntanuuhere',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(BuildContext context, String iconPath, String url) {
    return IconButton(
      icon: SvgPicture.asset(
        iconPath,
        height: 24,
        colorFilter: ColorFilter.mode(
          Theme.of(context).iconTheme.color!,
          BlendMode.srcIn,
        ),
      ),
      onPressed: () => _launchURL(url),
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
