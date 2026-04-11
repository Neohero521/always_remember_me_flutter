import 'package:flutter/material.dart';

/// v5.0 Color Palette - based on v4_colors.dart
/// Centralized here for the new architecture
class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF8B5CF6);
  static const Color primaryLight = Color(0xFFA78BFA);
  static const Color primaryDark = Color(0xFF7C3AED);

  // Secondary
  static const Color secondary = Color(0xFF14B8A6);

  // Accent
  static const Color accent = Color(0xFFF59E0B);

  // Background & Surface
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);

  // On Colors
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF1F2937);
  static const Color onSurface = Color(0xFF1F2937);

  // Text
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);

  // Divider & Border
  static const Color divider = Color(0xFFE5E7EB);

  // Semantic
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Special
  static const Color chainBadge = Color(0xFF14B8A6);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient drawerHeaderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
}
