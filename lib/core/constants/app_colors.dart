import 'package:flutter/material.dart';

/// Centralized Color Palette for the Nepal Super App.
///
/// Primary: #0F3D3E (Deep Himalayan Forest Teal)
/// Accent:  #C79A3E (Royal Pagoda Gold)
class AppColors {
  AppColors._();

  // Brand Primaries
  static const Color primary = Color(0xFF0F3D3E);
  static const Color primaryDark = Color(0xFF0A2B2C);
  static const Color primaryLight = Color(0xFF1D5A5C);

  // Brand Accents
  static const Color accent = Color(0xFFC79A3E);
  static const Color accentDark = Color(0xFFA67D29);
  static const Color accentLight = Color(0xFFE5B95C);

  // Light Theme Surfaces
  static const Color lightBackground = Color(0xFFF7F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Dark Theme Surfaces
  static const Color darkBackground = Color(0xFF0B1416);
  static const Color darkSurface = Color(0xFF111E21);
  static const Color darkCard = Color(0xFF16272B);
  static const Color darkBorder = Color(0xFF223A3F);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Status & Nepali Context Accents
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF0284C7);

  // Local Brand Identifiers (e.g. eSewa / Khalti / Fonepay integration cues)
  static const Color esewaGreen = Color(0xFF60BB46);
  static const Color khaltiPurple = Color(0xFF5C2D91);
  static const Color fonepayRed = Color(0xFFED1C24);
}
