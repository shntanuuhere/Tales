import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Tales is a podcast & interactive platform built by hereco.\n\nCredits: Built using Flutter, powered by ChatGPT.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
