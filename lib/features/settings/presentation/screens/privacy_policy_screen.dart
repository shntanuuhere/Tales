import 'package:flutter/material.dart';

/// A screen that displays the app's privacy policy
class PrivacyPolicyScreen extends StatelessWidget {
  /// Constructor
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy for Tales App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Last updated: June 2024',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Introduction',
              'Welcome to Tales. We respect your privacy and are committed to protecting your personal data. This privacy policy will inform you about how we look after your personal data when you use our app and tell you about your privacy rights.',
            ),
            _buildSection(
              'Data We Collect',
              'We collect the following types of information:\n\n'
              '• Device Information: We collect information about your device, including device type, operating system, and unique device identifiers.\n\n'
              '• Usage Data: We collect information about how you use our app, including which features you use and how often.\n\n'
              '• User Preferences: We store your app preferences, such as theme settings and favorite wallpapers.\n\n'
              '• Firebase Analytics: We use Firebase Analytics to collect anonymous usage statistics to improve our app.',
            ),
            _buildSection(
              'How We Use Your Data',
              'We use your data for the following purposes:\n\n'
              '• To provide and maintain our service\n'
              '• To improve and personalize your experience\n'
              '• To analyze usage patterns and optimize our app\n'
              '• To communicate with you about app updates and new features',
            ),
            _buildSection(
              'Third-Party Services',
              'Our app uses the following third-party services:\n\n'
              '• Unsplash API: We use the Unsplash API to provide wallpapers. Your use of Unsplash content is subject to the Unsplash Privacy Policy.\n\n'
              '• Firebase: We use Firebase for analytics and crash reporting. Firebase collects anonymous usage data and crash reports.\n\n'
              '• Google Play Services: We use Google Play Services for app functionality and updates.',
            ),
            _buildSection(
              'Data Storage and Security',
              'We take data security seriously. All data is stored securely using industry-standard encryption. We regularly review our security practices to ensure your data is protected.',
            ),
            _buildSection(
              'Your Rights',
              'You have the right to:\n\n'
              '• Access the personal data we hold about you\n'
              '• Request correction of your personal data\n'
              '• Request deletion of your personal data\n'
              '• Object to processing of your personal data\n'
              '• Request restriction of processing your personal data\n'
              '• Request transfer of your personal data\n'
              '• Withdraw consent',
            ),
            _buildSection(
              'Children\'s Privacy',
              'Our app is not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13.',
            ),
            _buildSection(
              'Changes to This Privacy Policy',
              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last updated" date.',
            ),
            _buildSection(
              'Contact Us',
              'If you have any questions about this Privacy Policy, please contact us at:\n\n'
              'Email: privacy@talesapp.com',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
