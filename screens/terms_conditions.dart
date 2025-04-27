import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms & Conditions')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '''
Terms & Conditions for Tales

Effective Date: April 11, 2025

By using the Tales app, you agree to be bound by the following terms and conditions. Please read them carefully.

1. Use of the App:
Tales provides a platform to create, save, and manage personal notes and audio recordings. You are responsible for the content you create and store in the app.

2. Account & Access:
To access certain features, you may be required to log in using Firebase Authentication. You agree to provide accurate information and keep your credentials secure.

3. Content Ownership:
All notes, recordings, and other content created by you remain your intellectual property. However, we reserve the right to remove content that violates laws or community standards.

4. Payment Features:
Future UPI or in-app purchases will be governed by applicable financial regulations. You agree to use these features only if legally permitted in your jurisdiction.

5. Usage Restrictions:
You agree not to:
• Use the app for any illegal or harmful activity
• Attempt to reverse engineer or exploit the app
• Harass or harm other users through your content

6. Data and Privacy:
We respect your privacy and safeguard your data through Firebase's secure infrastructure. For full details, see our Privacy Policy.

7. Limitation of Liability:
We are not liable for data loss, technical issues, or damages arising from the use of this app. Use Tales at your own risk.

8. Modifications:
We reserve the right to update these terms at any time. Continued use of the app after changes means you accept the new terms.

9. Contact:
For any questions, contact us at: taleshereco@gmail.com 

By using Tales, you acknowledge that you have read, understood, and agreed to these terms.
          ''',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
