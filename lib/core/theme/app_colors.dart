import 'package:flutter/material.dart';

/// لوحة ألوان بنكية عصرية (Fintech Palette)
class AppColors {
  AppColors._();

  // Primary - أزرق بنكي غامق
  static const Color primary = Color(0xFF0B3D91);
  static const Color primaryLight = Color(0xFF2B5DC7);
  static const Color primaryDark = Color(0xFF072A66);

  // Secondary - ذهبي/فيروزي كإشارة ثقة ورفاهية
  static const Color secondary = Color(0xFF00B8A9);
  static const Color accentGold = Color(0xFFC9A24B);

  // Status
  static const Color success = Color(0xFF1DB954);
  static const Color warning = Color(0xFFF5A623);
  static const Color danger = Color(0xFFE53935);

  // Light theme neutrals
  static const Color lightBackground = Color(0xFFF4F6FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE3E7EF);
  static const Color lightTextPrimary = Color(0xFF101828);
  static const Color lightTextSecondary = Color(0xFF667085);

  // Dark theme neutrals
  static const Color darkBackground = Color(0xFF0E1420);
  static const Color darkSurface = Color(0xFF161E2C);
  static const Color darkCard = Color(0xFF1B2434);
  static const Color darkBorder = Color(0xFF2A3548);
  static const Color darkTextPrimary = Color(0xFFF2F4F8);
  static const Color darkTextSecondary = Color(0xFF9AA5B6);

  // Gradients
  static const List<Color> primaryGradient = [
    Color(0xFF0B3D91),
    Color(0xFF1B5FC7),
  ];

  static const List<Color> goldGradient = [
    Color(0xFFC9A24B),
    Color(0xFFE4C97A),
  ];
}
