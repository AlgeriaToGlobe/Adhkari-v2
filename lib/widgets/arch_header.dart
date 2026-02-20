import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Islamic arch-shaped header painted with CustomPaint.
/// Matches the reference: dark brown background with a gold-bordered arch
/// containing the title, and a mosque silhouette placeholder inside.
class ArchHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const ArchHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.isDark(context) ? AppColors.darkHeaderGradient : AppColors.headerGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.gold,
                height: 1.3,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 14,
                  color: AppColors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
            const SizedBox(height: 12),
            // App logo
            Image.asset(
              'assets/images/logo_512.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
