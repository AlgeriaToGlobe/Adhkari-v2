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
    final dark = AppColors.isDark(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: dark ? AppColors.darkHeaderGradient : AppColors.headerGradient,
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
            const SizedBox(height: 16),
            // Arch shape with mosque placeholder
            SizedBox(
              width: 200,
              height: 120,
              child: CustomPaint(
                painter: _ArchPainter(),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ── PLACEHOLDER: Mosque silhouette icon ──
                        // Replace with your custom mosque/ornament asset
                        // Dimensions: 100x80 px, PNG transparent
                        Icon(
                          Icons.mosque_outlined,
                          size: 48,
                          color: AppColors.gold.withValues(alpha: 0.6),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.gold.withValues(alpha: 0.3),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '[ أيقونة — 100×80 px ]',
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 8,
                              color: AppColors.gold.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ArchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    final w = size.width;
    final h = size.height;

    // Start at bottom-left
    path.moveTo(0, h);
    // Left side
    path.lineTo(0, h * 0.45);
    // Arch curve (pointed Islamic arch)
    path.quadraticBezierTo(0, h * 0.1, w * 0.25, h * 0.08);
    path.quadraticBezierTo(w * 0.45, 0, w * 0.5, 0);
    path.quadraticBezierTo(w * 0.55, 0, w * 0.75, h * 0.08);
    path.quadraticBezierTo(w, h * 0.1, w, h * 0.45);
    // Right side
    path.lineTo(w, h);

    canvas.drawPath(path, paint);

    // Inner arch (slightly smaller)
    final innerPaint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final innerPath = Path();
    final inset = 8.0;
    innerPath.moveTo(inset, h);
    innerPath.lineTo(inset, h * 0.48);
    innerPath.quadraticBezierTo(
        inset, h * 0.15, w * 0.27, h * 0.12);
    innerPath.quadraticBezierTo(w * 0.46, h * 0.03, w * 0.5, h * 0.03);
    innerPath.quadraticBezierTo(
        w * 0.54, h * 0.03, w * 0.73, h * 0.12);
    innerPath.quadraticBezierTo(
        w - inset, h * 0.15, w - inset, h * 0.48);
    innerPath.lineTo(w - inset, h);

    canvas.drawPath(innerPath, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
