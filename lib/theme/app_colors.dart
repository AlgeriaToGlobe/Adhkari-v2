import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primary palette (matched to reference images) ──
  static const Color beige = Color(0xFFF5EFE4);
  static const Color beigeLight = Color(0xFFFBF7F0);
  static const Color beigeDark = Color(0xFFEAE0D0);
  static const Color beigeWarm = Color(0xFFF8F2E8);

  static const Color brown = Color(0xFF4A3728);
  static const Color brownLight = Color(0xFF6B5544);
  static const Color brownDark = Color(0xFF2E1E12);
  static const Color brownMedium = Color(0xFF5A4232);

  static const Color gold = Color(0xFFC4A35A);
  static const Color goldLight = Color(0xFFD4B878);
  static const Color goldDark = Color(0xFFA88B3D);
  static const Color goldMuted = Color(0xFFBFA76E);

  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFFEFCF8);

  // ── Functional colors ──
  static const Color textPrimary = Color(0xFF2E1E12);
  static const Color textSecondary = Color(0xFF6B5544);
  static const Color textOnGold = Color(0xFF2E1E12);
  static const Color divider = Color(0xFFE6DAC8);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color shimmer = Color(0xFFD4B878);

  // ── Counter colors ──
  static const Color counterActive = Color(0xFFC4A35A);
  static const Color counterCompleted = Color(0xFF6B8E5B);
  static const Color counterBackground = Color(0xFFF5EFE4);

  // ── Gradient presets ──
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF4A3728), Color(0xFF2E1E12)],
  );

  static const LinearGradient headerGradientSubtle = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5A4232), Color(0xFF3A2518)],
  );

  static const LinearGradient goldAccentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFC4A35A), Color(0xFFD4B878), Color(0xFFC4A35A)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFBF7F0), Color(0xFFF5EFE4)],
  );
}
