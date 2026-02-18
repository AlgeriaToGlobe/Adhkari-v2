import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Full-screen Islamic geometric background overlay.
///
/// Draws a repeating 10-pointed star rosette ({10/3} star polygon) with
/// square grid frames. The overlapping star lines from adjacent tiles
/// naturally create the classic interlocking Islamic geometric motif.
///
/// - Light mode: brown lines at ~3.5 % opacity (subtle paper texture)
/// - Dark mode:  gold  lines at ~5 %   opacity (Kiswah-inspired)
class GeometricBg extends StatelessWidget {
  final Widget child;

  const GeometricBg({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.isDark(context);

    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _IslamicPatternPainter(
              color: dark
                  ? AppColors.darkGold.withValues(alpha: 0.045)
                  : AppColors.brown.withValues(alpha: 0.035),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

/// Draws a tiled 10-pointed star rosette pattern.
///
/// Each tile contains:
///  1. A {10/3} star polygon (connecting every 3rd vertex of a decagon)
///  2. An inner decagon formed by the star's inner intersections
///  3. A square grid frame at the tile boundary
///
/// The star radius is deliberately larger than half the tile size so that
/// star lines extend past the tile boundary, creating the characteristic
/// interlocking frame effect when adjacent tiles overlap.
class _IslamicPatternPainter extends CustomPainter {
  final Color color;

  _IslamicPatternPainter({required this.color});

  static const double _tileSize = 120;
  static const int _n = 10;
  static const double _angleStep = 2 * math.pi / _n; // 36°

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7
      ..isAntiAlias = true;

    // Star circumradius — intentionally > tileSize/2 so tips overflow
    // into adjacent tiles, creating the interlocking frame look.
    const double R = _tileSize * 0.52;

    // Inner decagon radius (where star lines cross each other).
    // For a {10/3} star the inner intersection radius ≈ R * cos(54°) / cos(18°).
    final double innerR = R * math.cos(54 * math.pi / 180) /
        math.cos(18 * math.pi / 180);

    final int cols = (size.width / _tileSize).ceil() + 2;
    final int rows = (size.height / _tileSize).ceil() + 2;

    // Pre-compute unit directions for the 10 vertices.
    final outerDx = List<double>.generate(
        _n, (i) => math.cos(i * _angleStep - math.pi / 2));
    final outerDy = List<double>.generate(
        _n, (i) => math.sin(i * _angleStep - math.pi / 2));

    // Inner decagon vertices are offset by half a step (18°).
    final innerDx = List<double>.generate(
        _n, (i) => math.cos(i * _angleStep - math.pi / 2 + _angleStep / 2));
    final innerDy = List<double>.generate(
        _n, (i) => math.sin(i * _angleStep - math.pi / 2 + _angleStep / 2));

    for (int row = -1; row < rows; row++) {
      for (int col = -1; col < cols; col++) {
        final double x = col * _tileSize;
        final double y = row * _tileSize;
        final double cx = x + _tileSize / 2;
        final double cy = y + _tileSize / 2;

        // ── 1. Square grid frame ──
        canvas.drawRect(
            Rect.fromLTWH(x, y, _tileSize, _tileSize), paint);

        // ── 2. {10/3} star polygon ──
        for (int i = 0; i < _n; i++) {
          final j = (i + 3) % _n;
          canvas.drawLine(
            Offset(cx + R * outerDx[i], cy + R * outerDy[i]),
            Offset(cx + R * outerDx[j], cy + R * outerDy[j]),
            paint,
          );
        }

        // ── 3. Inner decagon (connecting inner intersection points) ──
        final innerPath = Path();
        for (int i = 0; i < _n; i++) {
          final px = cx + innerR * innerDx[i];
          final py = cy + innerR * innerDy[i];
          if (i == 0) {
            innerPath.moveTo(px, py);
          } else {
            innerPath.lineTo(px, py);
          }
        }
        innerPath.close();
        canvas.drawPath(innerPath, paint);

        // ── 4. Central dot accent ──
        canvas.drawCircle(Offset(cx, cy), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_IslamicPatternPainter oldDelegate) =>
      oldDelegate.color != color;
}
