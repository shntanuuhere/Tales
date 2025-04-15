import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'We value your privacy. This app does not collect any personal data. For podcast content, we rely on publicly available RSS feeds.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
