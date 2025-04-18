import 'package:flutter/material.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Back button removed
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Image.asset(
                      'assets/logo/zerodha_kite_logo.png',
                      height: 64,
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Welcome to Tales',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      // Demo button removed
                    ),
                    const SizedBox(height: 40),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.white24),
                          bottom: BorderSide(color: Colors.white24),
                        ),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text('Register to Tales', style: TextStyle(color: Colors.white)),
                            trailing: const Icon(Icons.person_outline, color: Colors.white),
                            onTap: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                          ),
                          ListTile(
                            title: const Text('Login to Tales', style: TextStyle(color: Colors.white)),
                            trailing: const Icon(Icons.login, color: Colors.white),
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Column(
                      children: [
                        const Text(
                          'hereco',
                          style: TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Copyright © 2025 hereco. All Rights Reserved',
                          style: const TextStyle(color: Colors.white38, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}