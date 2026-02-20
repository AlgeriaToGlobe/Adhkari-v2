import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/adhkar_provider.dart';
import '../theme/app_colors.dart';

/// Full-screen immersive dhikr counting experience.
///
/// The entire screen is a tap surface. Each tap increments the counter,
/// triggers haptic feedback, and progressively reveals a geometric
/// mandala drawn entirely via code on a [CustomPainter] canvas.
class DhikrCountingScreen extends StatefulWidget {
  final String dhikrId;
  final String dhikrText;
  final int targetCount;
  final int initialCount;

  const DhikrCountingScreen({
    super.key,
    required this.dhikrId,
    required this.dhikrText,
    required this.targetCount,
    required this.initialCount,
  });

  @override
  State<DhikrCountingScreen> createState() => _DhikrCountingScreenState();
}

class _DhikrCountingScreenState extends State<DhikrCountingScreen>
    with TickerProviderStateMixin {
  late int _currentCount;

  // Pulse animation for the counter text
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Slow continuous rotation for the mandala
  late AnimationController _rotationController;

  // Glow intensity animation on tap
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  // Completion celebration
  late AnimationController _completionController;
  late Animation<double> _completionAnimation;

  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _currentCount = widget.initialCount;
    _isCompleted = _currentCount >= widget.targetCount;

    // Pulse: quick scale bump on each tap
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.18), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.18, end: 1.0), weight: 60),
    ]).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeOut,
    ));

    // Continuous slow rotation
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    // Glow flash on tap
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _glowAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 70),
    ]).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeOut,
    ));

    // Completion burst
    _completionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _completionAnimation = CurvedAnimation(
      parent: _completionController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _glowController.dispose();
    _completionController.dispose();
    super.dispose();
  }

  double get _progress =>
      widget.targetCount > 0
          ? (_currentCount / widget.targetCount).clamp(0.0, 1.0)
          : 0.0;

  void _onTap() {
    if (_currentCount >= widget.targetCount) return;

    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Increment via provider (persists)
    context.read<AdhkarProvider>().incrementFreeDhikrItem(widget.dhikrId);

    setState(() {
      _currentCount++;
    });

    // Trigger pulse
    _pulseController.forward(from: 0);
    _glowController.forward(from: 0);

    // Check completion
    if (_currentCount >= widget.targetCount && !_isCompleted) {
      _isCompleted = true;
      HapticFeedback.heavyImpact();
      _completionController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Force dark overlay style for this immersive screen
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFF0A0908),
      ),
      child: Theme(
        data: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0A0908),
        ),
        child: Scaffold(
          backgroundColor: const Color(0xFF0A0908),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _onTap,
            child: Stack(
              children: [
                // ── Mandala canvas ──
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _rotationController,
                      _glowController,
                      _completionController,
                    ]),
                    builder: (context, _) {
                      return CustomPaint(
                        painter: _MandalaPainter(
                          progress: _progress,
                          rotation: _rotationController.value * 2 * pi,
                          glowIntensity: _glowAnimation.value,
                          completionFactor: _completionAnimation.value,
                          isCompleted: _isCompleted,
                        ),
                      );
                    },
                  ),
                ),

                // ── Central content ──
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Dhikr text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          widget.dhikrText,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFEBC06D).withValues(alpha: 0.7),
                            shadows: [
                              Shadow(
                                color: const Color(0xFFEBC06D).withValues(alpha: 0.3),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Pulsing count
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: child,
                          );
                        },
                        child: AnimatedBuilder(
                          animation: _glowAnimation,
                          builder: (context, _) {
                            final glowAlpha = 0.4 + _glowAnimation.value * 0.6;
                            return Text(
                              '$_currentCount',
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: 96,
                                fontWeight: FontWeight.bold,
                                color: _isCompleted
                                    ? const Color(0xFF6B8E5B)
                                    : const Color(0xFFF5D77A),
                                shadows: [
                                  Shadow(
                                    color: (_isCompleted
                                            ? const Color(0xFF6B8E5B)
                                            : const Color(0xFFEBC06D))
                                        .withValues(alpha: glowAlpha),
                                    blurRadius: 24 + _glowAnimation.value * 16,
                                  ),
                                  Shadow(
                                    color: (_isCompleted
                                            ? const Color(0xFF6B8E5B)
                                            : const Color(0xFFEBC06D))
                                        .withValues(alpha: glowAlpha * 0.5),
                                    blurRadius: 48 + _glowAnimation.value * 32,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Target label
                      Text(
                        'من ${widget.targetCount}',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 18,
                          color: const Color(0xFFB5A898).withValues(alpha: 0.6),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Progress bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _progress,
                            minHeight: 3,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.08),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _isCompleted
                                  ? const Color(0xFF6B8E5B)
                                  : const Color(0xFFEBC06D).withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Back button ──
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white.withValues(alpha: 0.5),
                      size: 28,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),

                // ── Completion overlay ──
                if (_isCompleted)
                  AnimatedBuilder(
                    animation: _completionAnimation,
                    builder: (context, _) {
                      final opacity =
                          (_completionAnimation.value * 2).clamp(0.0, 1.0) *
                              (1.0 -
                                  ((_completionAnimation.value - 0.5) * 2)
                                      .clamp(0.0, 1.0));
                      if (opacity <= 0.01) return const SizedBox.shrink();
                      return Positioned.fill(
                        child: IgnorePointer(
                          child: Container(
                            color: const Color(0xFF6B8E5B)
                                .withValues(alpha: opacity * 0.15),
                          ),
                        ),
                      );
                    },
                  ),

                // ── Tap hint at bottom ──
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 24,
                  left: 0,
                  right: 0,
                  child: Text(
                    _isCompleted ? 'اكتمل الذكر' : 'اضغط في أي مكان للتسبيح',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 14,
                      color: _isCompleted
                          ? const Color(0xFF6B8E5B).withValues(alpha: 0.7)
                          : Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mandala CustomPainter — purely mathematical, no external assets
// ─────────────────────────────────────────────────────────────────────────────

class _MandalaPainter extends CustomPainter {
  final double progress; // 0.0 → 1.0
  final double rotation; // continuous rotation in radians
  final double glowIntensity; // 0.0 → 1.0, flash on tap
  final double completionFactor; // 0.0 → 1.0, celebration
  final bool isCompleted;

  _MandalaPainter({
    required this.progress,
    required this.rotation,
    required this.glowIntensity,
    required this.completionFactor,
    required this.isCompleted,
  });

  // ── Gold/amber palette ──
  static const Color _goldBright = Color(0xFFF5D77A);
  static const Color _goldMain = Color(0xFFEBC06D);
  static const Color _goldDeep = Color(0xFFD4A847);
  static const Color _goldDark = Color(0xFFA88B3D);
  static const Color _completedGreen = Color(0xFF6B8E5B);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final maxRadius = min(cx, cy) * 0.92;

    canvas.save();
    canvas.translate(cx, cy);

    // Effective progress controls how much of the mandala is revealed
    final p = progress;

    // ── Layer 1: Central dot (always visible once started) ──
    if (p > 0) {
      _drawCenterDot(canvas, maxRadius, p);
    }

    // ── Layer 2: Inner ring of petals (0% → 15%) ──
    if (p > 0.0) {
      final layerP = (p / 0.15).clamp(0.0, 1.0);
      _drawPetalRing(
        canvas,
        petalCount: 8,
        innerRadius: maxRadius * 0.06,
        outerRadius: maxRadius * 0.18,
        petalWidth: 0.28,
        rotationOffset: rotation * 0.1,
        layerProgress: layerP,
        color: _goldBright,
        strokeWidth: 1.5,
      );
    }

    // ── Layer 3: First geometric ring (10% → 25%) ──
    if (p > 0.10) {
      final layerP = ((p - 0.10) / 0.15).clamp(0.0, 1.0);
      _drawGeometricRing(canvas, maxRadius * 0.20, 12, layerP,
          rotation * -0.05, _goldMain, 1.2);
    }

    // ── Layer 4: Second petal ring (20% → 40%) ──
    if (p > 0.20) {
      final layerP = ((p - 0.20) / 0.20).clamp(0.0, 1.0);
      _drawPetalRing(
        canvas,
        petalCount: 12,
        innerRadius: maxRadius * 0.18,
        outerRadius: maxRadius * 0.34,
        petalWidth: 0.22,
        rotationOffset: rotation * 0.07 + pi / 12,
        layerProgress: layerP,
        color: _goldMain,
        strokeWidth: 1.3,
      );
    }

    // ── Layer 5: Diamond lattice ring (35% → 55%) ──
    if (p > 0.35) {
      final layerP = ((p - 0.35) / 0.20).clamp(0.0, 1.0);
      _drawDiamondRing(canvas, maxRadius * 0.30, maxRadius * 0.42, 16, layerP,
          rotation * 0.04, _goldDeep, 1.0);
    }

    // ── Layer 6: Outer large petals (45% → 70%) ──
    if (p > 0.45) {
      final layerP = ((p - 0.45) / 0.25).clamp(0.0, 1.0);
      _drawPetalRing(
        canvas,
        petalCount: 16,
        innerRadius: maxRadius * 0.38,
        outerRadius: maxRadius * 0.58,
        petalWidth: 0.18,
        rotationOffset: rotation * -0.06 + pi / 16,
        layerProgress: layerP,
        color: _goldDeep,
        strokeWidth: 1.2,
      );
    }

    // ── Layer 7: Star burst ring (60% → 80%) ──
    if (p > 0.60) {
      final layerP = ((p - 0.60) / 0.20).clamp(0.0, 1.0);
      _drawStarBurst(canvas, maxRadius * 0.55, maxRadius * 0.72, 24, layerP,
          rotation * 0.03, _goldDark, 1.0);
    }

    // ── Layer 8: Outermost filigree petals (70% → 90%) ──
    if (p > 0.70) {
      final layerP = ((p - 0.70) / 0.20).clamp(0.0, 1.0);
      _drawPetalRing(
        canvas,
        petalCount: 24,
        innerRadius: maxRadius * 0.65,
        outerRadius: maxRadius * 0.85,
        petalWidth: 0.14,
        rotationOffset: rotation * 0.05 + pi / 24,
        layerProgress: layerP,
        color: _goldDark,
        strokeWidth: 0.9,
      );
    }

    // ── Layer 9: Final outer border ring (85% → 100%) ──
    if (p > 0.85) {
      final layerP = ((p - 0.85) / 0.15).clamp(0.0, 1.0);
      _drawOuterBorderRing(canvas, maxRadius * 0.88, maxRadius * 0.92, 32,
          layerP, rotation * -0.02, _goldBright, 0.8);
    }

    // ── Connecting arcs between layers ──
    if (p > 0.15) {
      _drawConnectingArcs(canvas, maxRadius, p);
    }

    // ── Tap glow flash ──
    if (glowIntensity > 0.01) {
      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            (isCompleted ? _completedGreen : _goldBright)
                .withValues(alpha: glowIntensity * 0.15),
            (isCompleted ? _completedGreen : _goldMain)
                .withValues(alpha: glowIntensity * 0.05),
            Colors.transparent,
          ],
          stops: const [0.0, 0.4, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: maxRadius));
      canvas.drawCircle(Offset.zero, maxRadius, glowPaint);
    }

    canvas.restore();
  }

  /// Glowing central dot with radiating circle
  void _drawCenterDot(Canvas canvas, double maxR, double p) {
    final radius = maxR * 0.04 * min(p * 5, 1.0);
    final paint = Paint()
      ..color = _goldBright.withValues(alpha: 0.8 * min(p * 5, 1.0))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, radius, paint);

    // Radiating halo
    final haloPaint = Paint()
      ..color = _goldMain.withValues(alpha: 0.15 * min(p * 3, 1.0))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, radius * 3, haloPaint);

    // Inner ring
    if (p > 0.02) {
      final ringPaint = Paint()
        ..color = _goldMain.withValues(alpha: 0.5 * min(p * 4, 1.0))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawCircle(Offset.zero, maxR * 0.06 * min(p * 4, 1.0), ringPaint);
    }
  }

  /// Draws a ring of pointed petals using quadratic Bézier curves in polar form
  void _drawPetalRing(
    Canvas canvas, {
    required int petalCount,
    required double innerRadius,
    required double outerRadius,
    required double petalWidth,
    required double rotationOffset,
    required double layerProgress,
    required Color color,
    required double strokeWidth,
  }) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.7 * layerProgress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.05 * layerProgress)
      ..style = PaintingStyle.fill;

    final angleStep = 2 * pi / petalCount;
    final petalsToShow = (petalCount * layerProgress).ceil();

    for (int i = 0; i < petalsToShow; i++) {
      final petalProgress =
          i < petalsToShow - 1 ? 1.0 : (layerProgress * petalCount - i).clamp(0.0, 1.0);

      final angle = i * angleStep + rotationOffset;
      final effectiveOuter =
          innerRadius + (outerRadius - innerRadius) * petalProgress;

      final path = _buildPetalPath(
        angle: angle,
        innerRadius: innerRadius,
        outerRadius: effectiveOuter,
        width: petalWidth,
      );

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, paint);
    }
  }

  /// Builds a single petal as a closed Path using cubic Béziers
  Path _buildPetalPath({
    required double angle,
    required double innerRadius,
    required double outerRadius,
    required double width,
  }) {
    final path = Path();

    // Inner point (base of petal)
    final ix = cos(angle) * innerRadius;
    final iy = sin(angle) * innerRadius;

    // Outer point (tip of petal)
    final ox = cos(angle) * outerRadius;
    final oy = sin(angle) * outerRadius;

    // Width control points perpendicular to the radial direction
    final perpAngle = angle + pi / 2;
    final midRadius = (innerRadius + outerRadius) / 2;
    final widthOffset = (outerRadius - innerRadius) * width;

    // Left control point
    final lx = cos(angle) * midRadius + cos(perpAngle) * widthOffset;
    final ly = sin(angle) * midRadius + sin(perpAngle) * widthOffset;

    // Right control point
    final rx = cos(angle) * midRadius - cos(perpAngle) * widthOffset;
    final ry = sin(angle) * midRadius - sin(perpAngle) * widthOffset;

    path.moveTo(ix, iy);
    path.quadraticBezierTo(lx, ly, ox, oy);
    path.quadraticBezierTo(rx, ry, ix, iy);
    path.close();

    return path;
  }

  /// Geometric ring: small polygons arranged in a circle
  void _drawGeometricRing(Canvas canvas, double radius, int count,
      double layerProgress, double rotOffset, Color color, double sw) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.5 * layerProgress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw;

    final angleStep = 2 * pi / count;
    final itemsToShow = (count * layerProgress).ceil();
    final smallR = radius * 0.12;

    for (int i = 0; i < itemsToShow; i++) {
      final angle = i * angleStep + rotOffset;
      final cx = cos(angle) * radius;
      final cy = sin(angle) * radius;

      // Draw small diamond at each point
      final path = Path();
      path.moveTo(cx + cos(angle) * smallR, cy + sin(angle) * smallR);
      path.lineTo(
          cx + cos(angle + pi / 2) * smallR * 0.5,
          cy + sin(angle + pi / 2) * smallR * 0.5);
      path.lineTo(cx - cos(angle) * smallR, cy - sin(angle) * smallR);
      path.lineTo(
          cx - cos(angle + pi / 2) * smallR * 0.5,
          cy - sin(angle + pi / 2) * smallR * 0.5);
      path.close();

      canvas.drawPath(path, paint);
    }

    // Connecting circle
    if (layerProgress > 0.5) {
      final circlePaint = Paint()
        ..color = color.withValues(alpha: 0.2 * ((layerProgress - 0.5) * 2))
        ..style = PaintingStyle.stroke
        ..strokeWidth = sw * 0.6;
      canvas.drawCircle(Offset.zero, radius, circlePaint);
    }
  }

  /// Diamond lattice between two radii
  void _drawDiamondRing(Canvas canvas, double innerR, double outerR, int count,
      double layerProgress, double rotOffset, Color color, double sw) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.45 * layerProgress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw
      ..strokeCap = StrokeCap.round;

    final angleStep = 2 * pi / count;
    final itemsToShow = (count * layerProgress).ceil();

    for (int i = 0; i < itemsToShow; i++) {
      final a = i * angleStep + rotOffset;
      final aNext = (i + 1) * angleStep + rotOffset;
      final aMid = (a + aNext) / 2;

      // Inner point
      final ix = cos(a) * innerR;
      final iy = sin(a) * innerR;

      // Outer point (between this and next)
      final ox = cos(aMid) * outerR;
      final oy = sin(aMid) * outerR;

      // Next inner point
      final nx = cos(aNext) * innerR;
      final ny = sin(aNext) * innerR;

      final path = Path()
        ..moveTo(ix, iy)
        ..lineTo(ox, oy)
        ..lineTo(nx, ny);

      canvas.drawPath(path, paint);
    }

    // Outer circle
    if (layerProgress > 0.3) {
      final op = ((layerProgress - 0.3) / 0.7).clamp(0.0, 1.0);
      final circlePaint = Paint()
        ..color = color.withValues(alpha: 0.15 * op)
        ..style = PaintingStyle.stroke
        ..strokeWidth = sw * 0.5;
      canvas.drawCircle(Offset.zero, outerR, circlePaint);
    }
  }

  /// Radiating lines from inner to outer radius
  void _drawStarBurst(Canvas canvas, double innerR, double outerR, int count,
      double layerProgress, double rotOffset, Color color, double sw) {
    final angleStep = 2 * pi / count;
    final linesToShow = (count * layerProgress).ceil();

    for (int i = 0; i < linesToShow; i++) {
      final lineProgress =
          i < linesToShow - 1 ? 1.0 : (layerProgress * count - i).clamp(0.0, 1.0);
      final a = i * angleStep + rotOffset;

      final effectiveOuter = innerR + (outerR - innerR) * lineProgress;

      // Main line
      final linePaint = Paint()
        ..color = color.withValues(alpha: 0.4 * lineProgress)
        ..style = PaintingStyle.stroke
        ..strokeWidth = sw
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(cos(a) * innerR, sin(a) * innerR),
        Offset(cos(a) * effectiveOuter, sin(a) * effectiveOuter),
        linePaint,
      );

      // Small circle at the tip
      if (lineProgress > 0.8) {
        final dotPaint = Paint()
          ..color = color.withValues(alpha: 0.5 * lineProgress)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(
          Offset(cos(a) * effectiveOuter, sin(a) * effectiveOuter),
          2.0,
          dotPaint,
        );
      }

      // Alternating shorter secondary lines
      if (i % 2 == 0 && lineProgress > 0.3) {
        final midA = a + angleStep / 2;
        final secProgress = ((lineProgress - 0.3) / 0.7).clamp(0.0, 1.0);
        final secOuter = innerR + (outerR - innerR) * 0.5 * secProgress;
        final secPaint = Paint()
          ..color = color.withValues(alpha: 0.2 * secProgress)
          ..style = PaintingStyle.stroke
          ..strokeWidth = sw * 0.6
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(
          Offset(cos(midA) * innerR, sin(midA) * innerR),
          Offset(cos(midA) * secOuter, sin(midA) * secOuter),
          secPaint,
        );
      }
    }
  }

  /// Outermost decorative border with small arcs
  void _drawOuterBorderRing(Canvas canvas, double innerR, double outerR,
      int count, double layerProgress, double rotOffset, Color color, double sw) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.35 * layerProgress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw
      ..strokeCap = StrokeCap.round;

    final angleStep = 2 * pi / count;
    final arcsToShow = (count * layerProgress).ceil();

    for (int i = 0; i < arcsToShow; i++) {
      final a = i * angleStep + rotOffset;
      final aEnd = a + angleStep;
      final aMid = (a + aEnd) / 2;

      // Scalloped edge: arc that dips outward
      final p1 = Offset(cos(a) * innerR, sin(a) * innerR);
      final p2 = Offset(cos(aEnd) * innerR, sin(aEnd) * innerR);
      final control = Offset(cos(aMid) * outerR, sin(aMid) * outerR);

      final path = Path()
        ..moveTo(p1.dx, p1.dy)
        ..quadraticBezierTo(control.dx, control.dy, p2.dx, p2.dy);

      canvas.drawPath(path, paint);
    }

    // Final closing circle
    if (layerProgress > 0.6) {
      final op = ((layerProgress - 0.6) / 0.4).clamp(0.0, 1.0);
      final ringPaint = Paint()
        ..color = color.withValues(alpha: 0.2 * op)
        ..style = PaintingStyle.stroke
        ..strokeWidth = sw * 0.5;
      canvas.drawCircle(Offset.zero, innerR, ringPaint);
    }
  }

  /// Delicate arcs connecting layers — adds cohesion
  void _drawConnectingArcs(Canvas canvas, double maxR, double p) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6
      ..strokeCap = StrokeCap.round;

    // Circles at key radii
    final radii = [0.12, 0.22, 0.36, 0.50, 0.68, 0.82];
    final thresholds = [0.08, 0.18, 0.30, 0.50, 0.65, 0.80];

    for (int i = 0; i < radii.length; i++) {
      if (p > thresholds[i]) {
        final layerP = ((p - thresholds[i]) / 0.12).clamp(0.0, 1.0);
        paint.color = _goldMain.withValues(alpha: 0.12 * layerP);

        // Draw partial arc based on progress
        final sweepAngle = 2 * pi * layerP;
        final rect = Rect.fromCircle(
          center: Offset.zero,
          radius: maxR * radii[i],
        );
        canvas.drawArc(rect, rotation * (i.isEven ? 0.02 : -0.02),
            sweepAngle, false, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_MandalaPainter old) =>
      old.progress != progress ||
      old.rotation != rotation ||
      old.glowIntensity != glowIntensity ||
      old.completionFactor != completionFactor;
}
