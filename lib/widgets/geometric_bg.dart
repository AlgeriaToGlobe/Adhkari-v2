import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Islamic geometric background overlay.
///
/// Tiles `assets/images/geometric_pattern.png` across the entire area,
/// with a solid-to-transparent fade at the top so titles sit on a
/// clean background and the pattern appears further down.
///
/// Place your pattern image at:  assets/images/geometric_pattern.png
class GeometricBg extends StatelessWidget {
  final Widget child;

  /// Total height of the top cover zone (solid + fade).
  final double fadeHeight;

  const GeometricBg({
    super.key,
    required this.child,
    this.fadeHeight = 400,
  });

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.isDark(context);
    final scaffoldColor = AppColors.scaffold(context);

    final imageWidget = Image(
      image: const ExactAssetImage(
        'assets/images/geometric_pattern.png',
        scale: 3.5,
      ),
      repeat: ImageRepeat.repeat,
      fit: BoxFit.none,
    );

    return Stack(
      children: [
        // 1. Tiled pattern image
        // Same natural gold image in both modes, just different opacity.
        Positioned.fill(
          child: dark
              // Dark mode: image as-is, gold lines on dark bg.
              ? Opacity(opacity: 0.04, child: imageWidget)
              // Light mode: invert so gold-on-black becomes dark-on-white.
              //   → dark lines show as subtle marks on beige.
              //   → white bg blends invisibly into beige.
              : Opacity(
                  opacity: 0.04,
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.matrix(<double>[
                      -1, 0, 0, 0, 255,
                      0, -1, 0, 0, 255,
                      0, 0, -1, 0, 255,
                      0, 0, 0, 1, 0,
                    ]),
                    child: imageWidget,
                  ),
                ),
        ),

        // 2. Top cover: fully solid → fades to transparent.
        //    ~70 % of fadeHeight is fully solid (titles area),
        //    last 30 % fades out so the pattern appears gradually.
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
                  stops: const [0.0, 0.7, 1.0],
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
