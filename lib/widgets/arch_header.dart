import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Brown gradient header used across all screens for consistent styling.
/// When [showLogo] is true, displays the app logo instead of the title text.
class ArchHeader extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final bool showLogo;

  const ArchHeader({
    super.key,
    this.title,
    this.subtitle,
    this.showLogo = false,
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
            if (showLogo) ...[
              Image.asset(
                'assets/images/logo_512.png',
                width: 120,
                height: 120,
              ),
            ] else if (title != null) ...[
              Text(
                title!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gold,
                  height: 1.3,
                ),
              ),
            ],
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
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
