import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms & Conditions')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'By using this app, you agree to the terms set by hereco. The content is for informational and entertainment purposes only.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
