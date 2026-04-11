import 'package:flutter/material.dart';

/// v4.0 Color Palette - based on UI_DESIGN_v4.md
class V4Colors {
  V4Colors._();

  // Primary
  static const Color primary = Color(0xFF8B5CF6);        // Purple
  static const Color primaryLight = Color(0xFFA78BFA);   // Light Purple
  static const Color primaryDark = Color(0xFF7C3AED);    // Dark Purple

  // Secondary
  static const Color secondary = Color(0xFF14B8A6);      // Teal

  // Accent
  static const Color accent = Color(0xFFF59E0B);         // Amber

  // Background & Surface
  static const Color background = Color(0xFFFAFAFA);       // Off White
  static const Color surface = Color(0xFFFFFFFF);          // White

  // On Colors
  static const Color onPrimary = Color(0xFFFFFFFF);        // White
  static const Color onBackground = Color(0xFF1F2937);    // Dark Gray
  static const Color onSurface = Color(0xFF1F2937);       // Dark Gray

  // Text
  static const Color textPrimary = Color(0xFF1F2937);      // Dark Gray
  static const Color textSecondary = Color(0xFF6B7280);    // Gray
  static const Color textHint = Color(0xFF9CA3AF);        // Light Gray

  // Divider & Border
  static const Color divider = Color(0xFFE5E7EB);         // Light Border

  // Semantic
  static const Color success = Color(0xFF10B981);         // Green
  static const Color warning = Color(0xFFF59E0B);          // Amber
  static const Color error = Color(0xFFEF4444);            // Red
  static const Color info = Color(0xFF3B82F6);             // Blue

  // Special
  static const Color chainBadge = Color(0xFF14B8A6);      // Teal
  static const Color cardBorder = Color(0xFFE5E7EB);

  // Button styles
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = secondary;
  static const Color buttonDanger = error;

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  // Drawer Header Gradient
  static const LinearGradient drawerHeaderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
}
