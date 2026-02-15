import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Placeholder for custom Islamic ornament assets.
///
/// ASSET SPECIFICATIONS:
/// ─────────────────────
/// You need to provide the following assets:
///
/// 1. HEADER ORNAMENT (header_ornament.png)
///    - Dimensions: 360 x 120 px (or 720x240 @2x, 1080x360 @3x)
///    - Format: PNG with transparency
///    - Usage: Decorative header on home screen
///    - Style: Islamic arch or geometric pattern
///
/// 2. DIVIDER ORNAMENT (divider_ornament.png)
///    - Dimensions: 300 x 40 px (or 600x80 @2x, 900x120 @3x)
///    - Format: PNG with transparency
///    - Usage: Between Adhkar items
///    - Style: Horizontal decorative line/pattern
///
/// 3. CARD CORNER ORNAMENT (corner_ornament.png)
///    - Dimensions: 60 x 60 px (or 120x120 @2x, 180x180 @3x)
///    - Format: PNG with transparency
///    - Usage: Top-right corner decoration on cards
///    - Style: Small floral or geometric motif
///
/// 4. BACKGROUND PATTERN (bg_pattern.png) [OPTIONAL]
///    - Dimensions: 400 x 400 px tileable
///    - Format: PNG with transparency (very subtle, ~10% opacity)
///    - Usage: Subtle repeating pattern on background
///    - Style: Islamic geometric pattern
///
/// Place assets in: assets/images/
/// Then replace the placeholder containers below with Image.asset().
///
enum OrnamentType {
  header,
  divider,
  cardCorner,
  backgroundPattern,
}

class OrnamentPlaceholder extends StatelessWidget {
  final OrnamentType type;
  final Color? borderColor;

  const OrnamentPlaceholder({
    super.key,
    required this.type,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = borderColor ?? AppColors.gold.withValues(alpha: 0.3);

    switch (type) {
      case OrnamentType.header:
        return Container(
          width: double.infinity,
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '[ زخرفة الرأس — 360×120 px ]',
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontFamily: 'Amiri',
              ),
            ),
          ),
        );

      case OrnamentType.divider:
        return Container(
          width: 200,
          height: 24,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              '[ فاصل — 300×40 px ]',
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontFamily: 'Amiri',
              ),
            ),
          ),
        );

      case OrnamentType.cardCorner:
        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            Icons.auto_awesome,
            size: 16,
            color: color,
          ),
        );

      case OrnamentType.backgroundPattern:
        return const SizedBox.shrink();
    }
  }
}
