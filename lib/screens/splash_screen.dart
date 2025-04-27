// Copyright 2025 Shantanu Sen Gupta
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Status bar spacer
            const SizedBox(height: 20),

            // Main content centered
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo triangular shape - lightweight version
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CustomPaint(
                        painter: TrianglePainter(),
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Simple progress indicator
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 100),
                      child: LinearProgressIndicator(
                        backgroundColor: Color(0xFF333333),
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
                        minHeight: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom text with proper spacing
            Padding(
              padding: const EdgeInsets.only(bottom: 34),
              child: Text(
                'TALES',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for triangular logo - optimized version
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Use a single paint object for better performance
    final paint = Paint()
      ..color = AppTheme.splashLogoColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true; // Improve rendering quality

    // Create a simple triangle path
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, size.width / 2);
    path.lineTo(0, size.height);
    path.close();

    // Draw only one path for better performance
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
