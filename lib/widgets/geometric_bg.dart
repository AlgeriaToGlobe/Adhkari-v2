import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Islamic geometric background overlay.
///
/// Tiles `assets/images/geometric_pattern.png` across the entire area,
/// then fades to the solid scaffold colour at the top so the page
/// title sits on a clean background.
///
/// Place your pattern image at:  assets/images/geometric_pattern.png
///
/// Tune these values to taste:
///   - [scale]      → higher = smaller tiles  (default 3.5)
///   - [fadeHeight]  → height of the top fade zone (default 140)
///   - opacity       → line 38 (dark) / line 38 (light)
class GeometricBg extends StatelessWidget {
  final Widget child;

  /// Height of the top fade zone (solid → transparent).
  final double fadeHeight;

  const GeometricBg({
    super.key,
    required this.child,
    this.fadeHeight = 140,
  });

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.isDark(context);
    final scaffoldColor = AppColors.scaffold(context);

    return Stack(
      children: [
        // 1. Tiled pattern image
        //    scale: controls tile size (higher = smaller tiles).
        //    Adjust the value if tiles are too big / too small.
        Positioned.fill(
          child: Opacity(
            opacity: dark ? 0.07 : 0.05,
            child: Image(
              image: const ExactAssetImage(
                'assets/images/geometric_pattern.png',
                scale: 3.5,
              ),
              repeat: ImageRepeat.repeat,
              fit: BoxFit.none,
            ),
          ),
        ),

        // 2. Top fade: solid scaffold colour → transparent.
        //    Keeps the title area clean, pattern fades in below.
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
                    scaffoldColor.withValues(alpha: 0),
                  ],
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
