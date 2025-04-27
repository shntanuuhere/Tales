import 'package:flutter/material.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Logo
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5722), // Orange-red logo color
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Transform.rotate(
                  angle: -0.8, // Rotate slightly to match the Kite logo style
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    color: const Color(0xFFFF5722),
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Welcome text
              const Text(
                'Welcome to',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SpaceMono',
                ),
              ),
              const Text(
                'Tales',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SpaceMono',
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Open account button
              _buildOption(
                title: 'Open a free account',
                icon: Icons.person_outline,
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
              ),
              
              const Divider(color: Colors.grey),
              
              // Login button
              _buildOption(
                title: 'Login to Tales',
                icon: Icons.login,
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
              
              const Divider(color: Colors.grey),
              
              const Spacer(),
              
              // Footer
              const Center(
                child: Text(
                  'TALES',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontFamily: 'SpaceMono',
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Terms text
              const Center(
                child: Text(
                  'Simple Notes App - Version 1.0.0',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontFamily: 'SpaceMono',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildOption({
    required String title, 
    required IconData icon, 
    required VoidCallback onTap
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'SpaceMono',
              ),
            ),
            const Spacer(),
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
