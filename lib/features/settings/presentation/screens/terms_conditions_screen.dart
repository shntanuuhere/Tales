import 'package:flutter/material.dart';

/// A screen that displays the app's terms and conditions
class TermsConditionsScreen extends StatelessWidget {
  /// Constructor
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms & Conditions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Last updated: June 2024',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            _buildSection(
              '1. Introduction',
              'These Terms & Conditions govern your use of the Tales application. By using the app, you agree to these terms. Please read them carefully.',
            ),
            _buildSection(
              '2. User Accounts',
              'You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.',
            ),
            _buildSection(
              '3. User Content',
              'You retain ownership of any content you create using the app. By submitting content, you grant us a license to use, store, and share your content in connection with the service.',
            ),
            _buildSection(
              '4. Data Privacy',
              'Our Privacy Policy describes how we handle the information you provide to us when you use our services.',
            ),
            _buildSection(
              '5. Changes to Terms',
              'We may modify these terms at any time. We will provide notice of any significant changes.',
            ),
            _buildSection(
              '6. Intellectual Property',
              'The app and its original content, features, and functionality are owned by Tales and are protected by international copyright, trademark, patent, trade secret, and other intellectual property laws.',
            ),
            _buildSection(
              '7. Termination',
              'We may terminate or suspend your account and bar access to the service immediately, without prior notice or liability, under our sole discretion, for any reason whatsoever.',
            ),
            _buildSection(
              '8. Limitation of Liability',
              'In no event shall Tales, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses.',
            ),
            _buildSection(
              '9. Governing Law',
              'These Terms shall be governed and construed in accordance with the laws of the country in which Tales operates, without regard to its conflict of law provisions.',
            ),
            _buildSection(
              '10. Contact Us',
              'If you have any questions about these Terms, please contact us at terms@talesapp.com',
            ),
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
              fontSize: 18,
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
