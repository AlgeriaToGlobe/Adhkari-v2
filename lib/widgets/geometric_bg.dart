import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Islamic geometric background overlay.
///
/// Tiles `assets/images/geometric_pattern.png` across the entire area,
/// then fades it to the solid scaffold colour at the top so the page
/// title sits on a clean background.
///
/// Usage: wrap any screen body with `GeometricBg(child: …)`.
/// Place your pattern image at  assets/images/geometric_pattern.png
///
/// Opacity:
///   Dark mode  → less transparent (more visible)
///   Light mode → more transparent (subtler)
class GeometricBg extends StatelessWidget {
  final Widget child;

  /// Height of the top fade zone (solid → transparent).
  final double fadeHeight;

  const GeometricBg({
    super.key,
    required this.child,
    this.fadeHeight = 220,
  });

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.isDark(context);
    final scaffoldColor = AppColors.scaffold(context);

    return Stack(
      children: [
        // 1. Tiled pattern image
        Positioned.fill(
          child: Opacity(
            opacity: dark ? 0.07 : 0.04,
            child: Image.asset(
              'assets/images/geometric_pattern.png',
              repeat: ImageRepeat.repeat,
              fit: BoxFit.none,
            ),
          ),
        ),

        // 2. Top fade: solid scaffold colour → transparent
        //    Keeps the title area clean, pattern appears below.
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: fadeHeight,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    scaffoldColor,
                    scaffoldColor,
                    scaffoldColor.withValues(alpha: 0),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),
        ),

        // 3. Actual page content
        child,
      ],
    );
  }
}
