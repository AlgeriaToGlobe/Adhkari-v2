import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette — beige/brown/gold/white only
  static const Color beige = Color(0xFFF5F0E8);
  static const Color beigeLight = Color(0xFFFAF7F2);
  static const Color beigeDark = Color(0xFFE8E0D0);

  static const Color brown = Color(0xFF5C4033);
  static const Color brownLight = Color(0xFF7A5C4F);
  static const Color brownDark = Color(0xFF3E2A1F);

  static const Color gold = Color(0xFFC9A84C);
  static const Color goldLight = Color(0xFFD4BA6A);
  static const Color goldDark = Color(0xFFB08D30);

  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFFEFCF8);

  // Functional colors (kept within the palette)
  static const Color textPrimary = Color(0xFF3E2A1F);
  static const Color textSecondary = Color(0xFF7A5C4F);
  static const Color textOnGold = Color(0xFF3E2A1F);
  static const Color divider = Color(0xFFE0D5C5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color shimmer = Color(0xFFD4BA6A);

  // Counter colors
  static const Color counterActive = Color(0xFFC9A84C);
  static const Color counterCompleted = Color(0xFF6B8E5B);
  static const Color counterBackground = Color(0xFFF5F0E8);

  // Gradient presets
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF5C4033), Color(0xFF3E2A1F)],
  );

  static const LinearGradient goldAccentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFC9A84C), Color(0xFFD4BA6A), Color(0xFFC9A84C)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFAF7F2), Color(0xFFF5F0E8)],
  );
}
