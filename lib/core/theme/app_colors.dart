import 'package:flutter/material.dart';
class AppColors {
  AppColors._();
  static const Color primary = Color(0xFFB03138);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF191C1F);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF191C1F);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF191C1F);
  static const Color textPrimary = Color(0xFF191C1F);
  static const Color textSecondary = Color(0xFF626262);
  static const Color hintText = Color(0xFF626262);
  static const Color inputBackground = Color(0xFFD9D9D9);
  static const Color inputBorderFocused = primary;
  static const Color inputBorderDefault = Colors.transparent;
  static const Color error = Color(0xFFD32F2F);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  static const Color shadow = Color(0xFFC7C7C7);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color overlay = Color(0x80000000);
  static const Color shimmer = Color(0xFFF5F5F5);
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFB03138),
      Color(0xFF8B252B),
    ],
  );
  static Color primaryWithOpacity(final double opacity) {
    return primary.withValues(alpha: opacity);
  }
  static Color textWithOpacity(final double opacity) {
    return textPrimary.withValues(alpha: opacity);
  }
  static Color shadowWithOpacity(final double opacity) {
    return shadow.withValues(alpha: opacity);
  }
}
