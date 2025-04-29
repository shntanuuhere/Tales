import 'package:flutter/material.dart';

/// Helper class to replace deprecated withOpacity calls
class ColorUtils {
  /// Converts a double opacity (0.0 to 1.0) to an alpha value (0 to 255)
  static int opacityToAlpha(double opacity) {
    return (opacity * 255).round();
  }
  
  /// Creates a color with the specified opacity
  static Color withOpacitySafe(Color color, double opacity) {
    return color.withAlpha(opacityToAlpha(opacity));
  }
}
