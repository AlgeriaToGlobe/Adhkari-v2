import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Full-screen Islamic geometric background overlay.
///
/// Draws a repeating octagon-cross tessellation on top of the scaffold
/// background. Uses lower opacity in light mode and higher in dark mode
/// so the pattern is always subtle.
class GeometricBg extends StatelessWidget {
  final Widget child;

  const GeometricBg({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.isDark(context);

    return Stack(
      children: [
        // Scaffold colour is already set on the Scaffold itself,
        // so we just need the pattern overlay.
        Positioned.fill(
          child: CustomPaint(
            painter: _IslamicPatternPainter(
              color: dark
                  ? Colors.white.withValues(alpha: 0.03)
                  : AppColors.brown.withValues(alpha: 0.025),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

/// Draws a classic Islamic octagon-and-cross (or "octagram") tessellation.
///
/// The pattern tiles a grid of regular octagons with small rotated squares
/// filling the gaps — the most recognisable Islamic geometric motif.
class _IslamicPatternPainter extends CustomPainter {
  final Color color;

  _IslamicPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..isAntiAlias = true;

    const double tileSize = 48;

    // The ratio that determines how far in from each corner the octagon
    // vertices sit. For a regular octagon inscribed in a square of side `s`,
    // the inset is  s / (2 + sqrt(2)).
    final double inset = tileSize / (2 + math.sqrt2);
    final double side = tileSize - 2 * inset; // length of the flat edges

    // How many tiles we need in each direction (add a margin of 1).
    final int cols = (size.width / tileSize).ceil() + 1;
    final int rows = (size.height / tileSize).ceil() + 1;

    for (int row = -1; row < rows; row++) {
      for (int col = -1; col < cols; col++) {
        final double x = col * tileSize;
        final double y = row * tileSize;

        // ── Draw octagon ──
        final octagon = Path()
          ..moveTo(x + inset, y)
          ..lineTo(x + inset + side, y)
          ..lineTo(x + tileSize, y + inset)
          ..lineTo(x + tileSize, y + inset + side)
          ..lineTo(x + inset + side, y + tileSize)
          ..lineTo(x + inset, y + tileSize)
          ..lineTo(x, y + inset + side)
          ..lineTo(x, y + inset)
          ..close();
        canvas.drawPath(octagon, paint);

        // ── Draw the small rotated square that fills the gap between
        //    four adjacent octagons (appears at the "+" junction). ──
        // The gap square sits at the top-left corner of each tile,
        // connecting the corner vertices of four neighbouring octagons.
        final cross = Path()
          ..moveTo(x, y + inset) // bottom of top-left octagon's right edge
          ..lineTo(x + inset, y) // right of top-left octagon's bottom edge
          ..lineTo(x, y - inset) // top from adjacent tile
          ..lineTo(x - inset, y)
          ..close();
        canvas.drawPath(cross, paint);

        // ── Inner 8-pointed star detail inside the octagon ──
        _drawInnerStar(canvas, paint, x + tileSize / 2, y + tileSize / 2,
            side * 0.42);
      }
    }
  }

  /// Draws a small 8-pointed star (two overlapping rotated squares)
  /// at the centre of each octagon for extra detail.
  void _drawInnerStar(
      Canvas canvas, Paint paint, double cx, double cy, double radius) {
    // First square (0° rotation)
    final sq1 = Path()
      ..moveTo(cx, cy - radius)
      ..lineTo(cx + radius, cy)
      ..lineTo(cx, cy + radius)
      ..lineTo(cx - radius, cy)
      ..close();
    canvas.drawPath(sq1, paint);

    // Second square rotated 45°
    final r45 = radius * math.cos(math.pi / 4); // ≈ radius * 0.707
    final sq2 = Path()
      ..moveTo(cx - r45, cy - r45)
      ..lineTo(cx + r45, cy - r45)
      ..lineTo(cx + r45, cy + r45)
      ..lineTo(cx - r45, cy + r45)
      ..close();
    canvas.drawPath(sq2, paint);
  }

  @override
  bool shouldRepaint(_IslamicPatternPainter oldDelegate) =>
      oldDelegate.color != color;
}
