import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '''
Privacy Policy for Tales

Effective Date: April 11, 2025

Thank you for using Tales. Your privacy is important to us. This privacy policy explains how we collect, use, and safeguard your information.

1. Information Collection:
• We may collect basic user information such as email or name for login purposes via Firebase Authentication.
• Notes and user-generated content are securely stored using Firebase Firestore.
• No personal information is shared with third parties without consent.

2. Microphone Access:
• Tales may request access to your microphone to allow audio note-taking or recording of personal content. These recordings are stored locally or in your account and are never shared without your permission.

3. Spotify Integration:
• We may request Spotify login for accessing your public music data (e.g., playlists, listening history). This integration is optional and does not affect other app features.
• We do not store or sell your Spotify data.

4. UPI & Payments:
• If you use any future payment features, they will comply with UPI and RBI standards. No sensitive payment information is stored on our servers.

5. Wallpapers and Personalization:
• Tales may allow users to set wallpapers for personalization. These assets are either built-in or downloaded with user consent.

6. Notifications:
• We may send notifications to remind you to take notes or record audio. You can control notification permissions in your phone settings.

7. Data Security:
• We use Firebase services which are GDPR and ISO/IEC 27001 compliant.
• All communication between the app and our servers is encrypted.

8. Changes to Policy:
• We may update this privacy policy from time to time. Any changes will be reflected in the app and on our website if applicable.

9. Contact Us:
If you have any questions about this policy, feel free to contact us at: taleshereco@gmail.com

By using Tales, you agree to this Privacy Policy.
          ''',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
