import 'package:flutter/material.dart';

/// TaskMate Color Palette
/// Modern, clean, and productivity-oriented colors for students.
class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF4F46E5); // Indigo 600
  static const Color primaryLight = Color(0xFF6366F1); // Indigo 500
  static const Color primaryDark = Color(0xFF4338CA); // Indigo 700
  static const Color primaryContainer = Color(0xFFEEF2FF); // Indigo 50

  static const Color secondary = Color(0xFF06B6D4); // Cyan 500
  static const Color accent = Color(0xFF8B5CF6); // Purple 500

  // Priority Colors
  static const Color priorityLow = Color(0xFF10B981); // Emerald Green
  static const Color priorityLowBg = Color(0xFFECFDF5);
  static const Color priorityMedium = Color(0xFFF59E0B); // Amber
  static const Color priorityMediumBg = Color(0xFFFFFBEB);
  static const Color priorityHigh = Color(0xFFEF4444); // Rose Red
  static const Color priorityHighBg = Color(0xFFFEF2F2);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Light Mode Colors
  static const Color lightScaffold = Color(0xFFF8FAFC);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextTertiary = Color(0xFF94A3B8);

  // Dark Mode Colors
  static const Color darkScaffold = Color(0xFF0B0F19);
  static const Color darkCard = Color(0xFF151E2E);
  static const Color darkCardElevated = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextTertiary = Color(0xFF64748B);

  // Subject/Category Colors
  static const List<Color> categoryColors = [
    Color(0xFF4F46E5), // Indigo
    Color(0xFFEC4899), // Pink
    Color(0xFF10B981), // Emerald
    Color(0xFFF59E0B), // Amber
    Color(0xFF8B5CF6), // Purple
    Color(0xFF06B6D4), // Cyan
    Color(0xFF3B82F6), // Blue
  ];
}

