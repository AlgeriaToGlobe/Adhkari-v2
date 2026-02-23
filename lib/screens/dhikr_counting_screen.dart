import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/adhkar_provider.dart';
import '../theme/app_colors.dart';

// ── Palette constants (shared by widget + painter) ──
const Color _kBg = Color(0xFF0A0908);
const Color _kGoldBright = Color(0xFFF5D77A);
const Color _kGoldMain = Color(0xFFEBC06D);
const Color _kGoldDeep = Color(0xFFD4A847);
const Color _kGoldDark = Color(0xFFA88B3D);
const Color _kGreen = Color(0xFF6B8E5B);

/// Full-screen immersive dhikr counting experience.
///
/// Layout (top → bottom):
///   1. Frosted header strip — dhikr text reminder + back button
///   2. Full-bleed mandala canvas with clear center circle for the counter
///   3. Polished bottom bar — progress arc + count label
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

  // ── Animation controllers ──
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  late AnimationController _rotationCtrl;

  late AnimationController _glowCtrl;
  late Animation<double> _glowAnim;

  late AnimationController _completionCtrl;
  late Animation<double> _completionAnim;

  bool _isCompleted = false;

  // Radius of the clear center circle (set in build via LayoutBuilder)
  // This is passed to the painter so it knows where to start drawing.
  static const double _centerCircleRadius = 72.0;

  @override
  void initState() {
    super.initState();
    _currentCount = widget.initialCount;
    _isCompleted = _currentCount >= widget.targetCount;

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _pulseAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 60),
    ]).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut));

    _rotationCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _glowAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 70),
    ]).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeOut));

    _completionCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _completionAnim = CurvedAnimation(
      parent: _completionCtrl,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _rotationCtrl.dispose();
    _glowCtrl.dispose();
    _completionCtrl.dispose();
    super.dispose();
  }

  double get _progress =>
      widget.targetCount > 0
          ? (_currentCount / widget.targetCount).clamp(0.0, 1.0)
          : 0.0;

  void _onTap() {
    if (_currentCount >= widget.targetCount) return;

    HapticFeedback.mediumImpact();
    context.read<AdhkarProvider>().incrementFreeDhikrItem(widget.dhikrId);
    setState(() => _currentCount++);

    _pulseCtrl.forward(from: 0);
    _glowCtrl.forward(from: 0);

    if (_currentCount >= widget.targetCount && !_isCompleted) {
      _isCompleted = true;
      HapticFeedback.heavyImpact();
      _completionCtrl.forward(from: 0);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final botPad = MediaQuery.of(context).padding.bottom;
    final accentColor = _isCompleted ? _kGreen : _kGoldMain;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: _kBg,
      ),
      child: Theme(
        data: ThemeData.dark().copyWith(scaffoldBackgroundColor: _kBg),
        child: Scaffold(
          backgroundColor: _kBg,
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _onTap,
            child: Stack(
              children: [
                // ═══════════════════════════════════════════════════════════
                // 1. MANDALA — full bleed, clear center hole
                // ═══════════════════════════════════════════════════════════
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _rotationCtrl,
                      _glowCtrl,
                      _completionCtrl,
                    ]),
                    builder: (context, _) {
                      return CustomPaint(
                        painter: _MandalaPainter(
                          progress: _progress,
                          rotation: _rotationCtrl.value * 2 * pi,
                          glowIntensity: _glowAnim.value,
                          completionFactor: _completionAnim.value,
                          isCompleted: _isCompleted,
                          centerHoleRadius: _centerCircleRadius,
                        ),
                      );
                    },
                  ),
                ),

                // ═══════════════════════════════════════════════════════════
                // 2. CENTER COUNTER — inside a clear glowing circle
                // ═══════════════════════════════════════════════════════════
                Center(
                  child: AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnim.value,
                        child: child,
                      );
                    },
                    child: AnimatedBuilder(
                      animation: _glowAnim,
                      builder: (context, _) {
                        final glow = _glowAnim.value;
                        return Container(
                          width: _centerCircleRadius * 2,
                          height: _centerCircleRadius * 2,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _kBg,
                            border: Border.all(
                              color: accentColor
                                  .withValues(alpha: 0.35 + glow * 0.4),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor
                                    .withValues(alpha: 0.10 + glow * 0.20),
                                blurRadius: 24 + glow * 20,
                                spreadRadius: 4 + glow * 8,
                              ),
                              BoxShadow(
                                color: accentColor
                                    .withValues(alpha: 0.05 + glow * 0.10),
                                blurRadius: 60 + glow * 40,
                                spreadRadius: 8 + glow * 16,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$_currentCount',
                                  style: TextStyle(
                                    fontFamily: 'Amiri',
                                    fontSize: _currentCount >= 1000 ? 40 : 52,
                                    fontWeight: FontWeight.bold,
                                    color: _isCompleted
                                        ? _kGreen
                                        : _kGoldBright,
                                    height: 1.1,
                                  ),
                                ),
                                Text(
                                  '/ ${widget.targetCount}',
                                  style: TextStyle(
                                    fontFamily: 'Amiri',
                                    fontSize: 14,
                                    color: Colors.white
                                        .withValues(alpha: 0.3),
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // ═══════════════════════════════════════════════════════════
                // 3. TOP HEADER — dhikr reminder + back button
                // ═══════════════════════════════════════════════════════════
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                      top: topPad + 8,
                      bottom: 14,
                      left: 16,
                      right: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _kBg,
                          _kBg.withValues(alpha: 0.95),
                          _kBg.withValues(alpha: 0.0),
                        ],
                        stops: const [0.0, 0.65, 1.0],
                      ),
                    ),
                    child: Row(
                      children: [
                        // Back
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.08),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.06),
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white.withValues(alpha: 0.6),
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Dhikr text
                        Expanded(
                          child: Text(
                            widget.dhikrText,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _kGoldMain.withValues(alpha: 0.85),
                              shadows: [
                                Shadow(
                                  color: _kGoldMain.withValues(alpha: 0.4),
                                  blurRadius: 16,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 48), // balance the back button
                      ],
                    ),
                  ),
                ),

                // ═══════════════════════════════════════════════════════════
                // 4. BOTTOM BAR — progress + hint
                // ═══════════════════════════════════════════════════════════
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 20,
                      bottom: botPad + 16,
                      left: 32,
                      right: 32,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          _kBg,
                          _kBg.withValues(alpha: 0.95),
                          _kBg.withValues(alpha: 0.0),
                        ],
                        stops: const [0.0, 0.65, 1.0],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Progress bar
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Stack(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeOut,
                                    width: constraints.maxWidth * _progress,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      gradient: LinearGradient(
                                        colors: _isCompleted
                                            ? [_kGreen, _kGreen]
                                            : [_kGoldDark, _kGoldMain, _kGoldBright],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: accentColor
                                              .withValues(alpha: 0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Bottom labels
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Percentage
                            Text(
                              '${(_progress * 100).toInt()}%',
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: accentColor.withValues(alpha: 0.7),
                              ),
                            ),
                            // Hint / status
                            Text(
                              _isCompleted
                                  ? 'اكتمل الذكر ❤'
                                  : 'اضغط في أي مكان للتسبيح',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: 13,
                                color: _isCompleted
                                    ? _kGreen.withValues(alpha: 0.7)
                                    : Colors.white.withValues(alpha: 0.25),
                              ),
                            ),
                            // Remaining
                            Text(
                              _isCompleted
                                  ? widget.targetCount.toString()
                                  : '${widget.targetCount - _currentCount}',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ═══════════════════════════════════════════════════════════
                // 5. COMPLETION FLASH
                // ═══════════════════════════════════════════════════════════
                if (_isCompleted)
                  AnimatedBuilder(
                    animation: _completionAnim,
                    builder: (context, _) {
                      final t = _completionAnim.value;
                      final opacity = (t * 2).clamp(0.0, 1.0) *
                          (1.0 - ((t - 0.5) * 2).clamp(0.0, 1.0));
                      if (opacity <= 0.01) return const SizedBox.shrink();
                      return Positioned.fill(
                        child: IgnorePointer(
                          child: Container(
                            color: _kGreen.withValues(alpha: opacity * 0.12),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// MANDALA PAINTER — radiates outward from the center circle
// ═══════════════════════════════════════════════════════════════════════════════

class _MandalaPainter extends CustomPainter {
  final double progress;
  final double rotation;
  final double glowIntensity;
  final double completionFactor;
  final bool isCompleted;
  final double centerHoleRadius;

  _MandalaPainter({
    required this.progress,
    required this.rotation,
    required this.glowIntensity,
    required this.completionFactor,
    required this.isCompleted,
    required this.centerHoleRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    // maxRadius = distance from center to the nearest edge (with margin)
    final maxRadius = min(cx, cy) * 0.95;

    // The clear zone where the counter sits — mandala starts OUTSIDE this
    final holeR = centerHoleRadius + 10; // small gap outside the circle border

    // The mandala fills the band: holeR → maxRadius
    // All layer radii are expressed as fractions of this band.
    final bandWidth = maxRadius - holeR;
    if (bandWidth <= 0) return;

    canvas.save();
    canvas.translate(cx, cy);

    final p = progress;

    // ── Glowing ring at the origin circle boundary ──
    _drawOriginRing(canvas, holeR, p);

    // ── Layer 1: First petal ring hugging the circle (0% → 12%) ──
    if (p > 0.0) {
      final lp = (p / 0.12).clamp(0.0, 1.0);
      _drawPetalRing(canvas,
          petalCount: 8,
          innerR: holeR,
          outerR: holeR + bandWidth * 0.10,
          petalWidth: 0.32,
          rotOff: rotation * 0.10,
          lp: lp,
          color: _kGoldBright,
          sw: 1.5);
    }

    // ── Layer 2: Geometric diamond ring (8% → 22%) ──
    if (p > 0.08) {
      final lp = ((p - 0.08) / 0.14).clamp(0.0, 1.0);
      _drawGeometricRing(canvas, holeR + bandWidth * 0.10, 12, lp,
          rotation * -0.05, _kGoldMain, 1.2);
    }

    // ── Layer 3: Second petal ring (18% → 36%) ──
    if (p > 0.18) {
      final lp = ((p - 0.18) / 0.18).clamp(0.0, 1.0);
      _drawPetalRing(canvas,
          petalCount: 12,
          innerR: holeR + bandWidth * 0.10,
          outerR: holeR + bandWidth * 0.26,
          petalWidth: 0.24,
          rotOff: rotation * 0.07 + pi / 12,
          lp: lp,
          color: _kGoldMain,
          sw: 1.3);
    }

    // ── Layer 4: Diamond lattice (30% → 48%) ──
    if (p > 0.30) {
      final lp = ((p - 0.30) / 0.18).clamp(0.0, 1.0);
      _drawDiamondRing(canvas, holeR + bandWidth * 0.24, holeR + bandWidth * 0.36,
          16, lp, rotation * 0.04, _kGoldDeep, 1.0);
    }

    // ── Layer 5: Third petal ring (42% → 62%) ──
    if (p > 0.42) {
      final lp = ((p - 0.42) / 0.20).clamp(0.0, 1.0);
      _drawPetalRing(canvas,
          petalCount: 16,
          innerR: holeR + bandWidth * 0.34,
          outerR: holeR + bandWidth * 0.52,
          petalWidth: 0.20,
          rotOff: rotation * -0.06 + pi / 16,
          lp: lp,
          color: _kGoldDeep,
          sw: 1.2);
    }

    // ── Layer 6: Star burst (56% → 74%) ──
    if (p > 0.56) {
      final lp = ((p - 0.56) / 0.18).clamp(0.0, 1.0);
      _drawStarBurst(canvas, holeR + bandWidth * 0.50, holeR + bandWidth * 0.66,
          24, lp, rotation * 0.03, _kGoldDark, 1.0);
    }

    // ── Layer 7: Outer filigree petals (68% → 86%) ──
    if (p > 0.68) {
      final lp = ((p - 0.68) / 0.18).clamp(0.0, 1.0);
      _drawPetalRing(canvas,
          petalCount: 24,
          innerR: holeR + bandWidth * 0.62,
          outerR: holeR + bandWidth * 0.80,
          petalWidth: 0.16,
          rotOff: rotation * 0.05 + pi / 24,
          lp: lp,
          color: _kGoldDark,
          sw: 1.0);
    }

    // ── Layer 8: Outer geometric ring (78% → 92%) ──
    if (p > 0.78) {
      final lp = ((p - 0.78) / 0.14).clamp(0.0, 1.0);
      _drawGeometricRing(canvas, holeR + bandWidth * 0.80, 20, lp,
          rotation * -0.03, _kGoldMain, 0.9);
    }

    // ── Layer 9: Final scalloped border (88% → 100%) ──
    if (p > 0.88) {
      final lp = ((p - 0.88) / 0.12).clamp(0.0, 1.0);
      _drawScallopedBorder(canvas, holeR + bandWidth * 0.88,
          holeR + bandWidth * 0.96, 32, lp, rotation * -0.02, _kGoldBright, 0.8);
    }

    // ── Connecting arcs ──
    if (p > 0.10) {
      _drawConnectingArcs(canvas, holeR, bandWidth, p);
    }

    // ── Tap glow ripple ──
    if (glowIntensity > 0.01) {
      final glowColor = isCompleted ? _kGreen : _kGoldBright;
      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            glowColor.withValues(alpha: glowIntensity * 0.12),
            glowColor.withValues(alpha: glowIntensity * 0.04),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: maxRadius));
      canvas.drawCircle(Offset.zero, maxRadius, glowPaint);
    }

    canvas.restore();
  }

  // ── Origin ring: the golden border that hugs the counter circle ──
  void _drawOriginRing(Canvas canvas, double holeR, double p) {
    if (p <= 0) return;
    final alpha = (p * 5).clamp(0.0, 1.0);

    // Outer glow
    final glowPaint = Paint()
      ..color = _kGoldMain.withValues(alpha: 0.08 * alpha)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(Offset.zero, holeR + 6, glowPaint);

    // Thin gold ring
    final ringPaint = Paint()
      ..color = _kGoldMain.withValues(alpha: 0.4 * alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(Offset.zero, holeR, ringPaint);

    // Slightly larger faint ring
    if (p > 0.05) {
      final outerAlpha = ((p - 0.05) * 4).clamp(0.0, 1.0);
      final outerPaint = Paint()
        ..color = _kGoldDeep.withValues(alpha: 0.18 * outerAlpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;
      canvas.drawCircle(Offset.zero, holeR + 4, outerPaint);
    }
  }

  // ── Petal ring ──
  void _drawPetalRing(Canvas canvas, {
    required int petalCount,
    required double innerR,
    required double outerR,
    required double petalWidth,
    required double rotOff,
    required double lp,
    required Color color,
    required double sw,
  }) {
    final strokePaint = Paint()
      ..color = color.withValues(alpha: 0.7 * lp)
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw
      ..strokeCap = StrokeCap.round;
    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.05 * lp)
      ..style = PaintingStyle.fill;

    final step = 2 * pi / petalCount;
    final show = (petalCount * lp).ceil();

    for (int i = 0; i < show; i++) {
      final pp = i < show - 1 ? 1.0 : (lp * petalCount - i).clamp(0.0, 1.0);
      final angle = i * step + rotOff;
      final effOuter = innerR + (outerR - innerR) * pp;

      final path = _petalPath(angle, innerR, effOuter, petalWidth);
      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);
    }
  }

  Path _petalPath(double angle, double innerR, double outerR, double w) {
    final ix = cos(angle) * innerR;
    final iy = sin(angle) * innerR;
    final ox = cos(angle) * outerR;
    final oy = sin(angle) * outerR;

    final perp = angle + pi / 2;
    final midR = (innerR + outerR) / 2;
    final wo = (outerR - innerR) * w;

    final lx = cos(angle) * midR + cos(perp) * wo;
    final ly = sin(angle) * midR + sin(perp) * wo;
    final rx = cos(angle) * midR - cos(perp) * wo;
    final ry = sin(angle) * midR - sin(perp) * wo;

    return Path()
      ..moveTo(ix, iy)
      ..quadraticBezierTo(lx, ly, ox, oy)
      ..quadraticBezierTo(rx, ry, ix, iy)
      ..close();
  }

  // ── Geometric ring (small diamonds on a circle) ──
  void _drawGeometricRing(Canvas canvas, double radius, int count,
      double lp, double rotOff, Color color, double sw) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.5 * lp)
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw;

    final step = 2 * pi / count;
    final show = (count * lp).ceil();
    final sr = radius * 0.10;

    for (int i = 0; i < show; i++) {
      final a = i * step + rotOff;
      final dx = cos(a) * radius;
      final dy = sin(a) * radius;

      final path = Path()
        ..moveTo(dx + cos(a) * sr, dy + sin(a) * sr)
        ..lineTo(dx + cos(a + pi / 2) * sr * 0.5,
            dy + sin(a + pi / 2) * sr * 0.5)
        ..lineTo(dx - cos(a) * sr, dy - sin(a) * sr)
        ..lineTo(dx - cos(a + pi / 2) * sr * 0.5,
            dy - sin(a + pi / 2) * sr * 0.5)
        ..close();
      canvas.drawPath(path, paint);
    }

    if (lp > 0.5) {
      final cp = Paint()
        ..color = color.withValues(alpha: 0.18 * ((lp - 0.5) * 2))
        ..style = PaintingStyle.stroke
        ..strokeWidth = sw * 0.5;
      canvas.drawCircle(Offset.zero, radius, cp);
    }
  }

  // ── Diamond lattice ──
  void _drawDiamondRing(Canvas canvas, double innerR, double outerR,
      int count, double lp, double rotOff, Color color, double sw) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.45 * lp)
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw
      ..strokeCap = StrokeCap.round;

    final step = 2 * pi / count;
    final show = (count * lp).ceil();

    for (int i = 0; i < show; i++) {
      final a = i * step + rotOff;
      final aN = (i + 1) * step + rotOff;
      final aM = (a + aN) / 2;

      final path = Path()
        ..moveTo(cos(a) * innerR, sin(a) * innerR)
        ..lineTo(cos(aM) * outerR, sin(aM) * outerR)
        ..lineTo(cos(aN) * innerR, sin(aN) * innerR);
      canvas.drawPath(path, paint);
    }

    if (lp > 0.3) {
      final op = ((lp - 0.3) / 0.7).clamp(0.0, 1.0);
      final cp = Paint()
        ..color = color.withValues(alpha: 0.12 * op)
        ..style = PaintingStyle.stroke
        ..strokeWidth = sw * 0.5;
      canvas.drawCircle(Offset.zero, outerR, cp);
    }
  }

  // ── Star burst (radial lines) ──
  void _drawStarBurst(Canvas canvas, double innerR, double outerR,
      int count, double lp, double rotOff, Color color, double sw) {
    final step = 2 * pi / count;
    final show = (count * lp).ceil();

    for (int i = 0; i < show; i++) {
      final lineProg =
          i < show - 1 ? 1.0 : (lp * count - i).clamp(0.0, 1.0);
      final a = i * step + rotOff;
      final effOuter = innerR + (outerR - innerR) * lineProg;

      final lPaint = Paint()
        ..color = color.withValues(alpha: 0.4 * lineProg)
        ..style = PaintingStyle.stroke
        ..strokeWidth = sw
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(cos(a) * innerR, sin(a) * innerR),
        Offset(cos(a) * effOuter, sin(a) * effOuter),
        lPaint,
      );

      if (lineProg > 0.8) {
        final dp = Paint()
          ..color = color.withValues(alpha: 0.5 * lineProg)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(
            Offset(cos(a) * effOuter, sin(a) * effOuter), 2.0, dp);
      }

      if (i % 2 == 0 && lineProg > 0.3) {
        final mA = a + step / 2;
        final sp = ((lineProg - 0.3) / 0.7).clamp(0.0, 1.0);
        final so = innerR + (outerR - innerR) * 0.5 * sp;
        final sPaint = Paint()
          ..color = color.withValues(alpha: 0.2 * sp)
          ..style = PaintingStyle.stroke
          ..strokeWidth = sw * 0.6
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(
          Offset(cos(mA) * innerR, sin(mA) * innerR),
          Offset(cos(mA) * so, sin(mA) * so),
          sPaint,
        );
      }
    }
  }

  // ── Scalloped border ──
  void _drawScallopedBorder(Canvas canvas, double innerR, double outerR,
      int count, double lp, double rotOff, Color color, double sw) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.35 * lp)
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw
      ..strokeCap = StrokeCap.round;

    final step = 2 * pi / count;
    final show = (count * lp).ceil();

    for (int i = 0; i < show; i++) {
      final a = i * step + rotOff;
      final aEnd = a + step;
      final aMid = (a + aEnd) / 2;

      final p1 = Offset(cos(a) * innerR, sin(a) * innerR);
      final p2 = Offset(cos(aEnd) * innerR, sin(aEnd) * innerR);
      final ctrl = Offset(cos(aMid) * outerR, sin(aMid) * outerR);

      final path = Path()
        ..moveTo(p1.dx, p1.dy)
        ..quadraticBezierTo(ctrl.dx, ctrl.dy, p2.dx, p2.dy);
      canvas.drawPath(path, paint);
    }

    if (lp > 0.6) {
      final op = ((lp - 0.6) / 0.4).clamp(0.0, 1.0);
      final rp = Paint()
        ..color = color.withValues(alpha: 0.18 * op)
        ..style = PaintingStyle.stroke
        ..strokeWidth = sw * 0.4;
      canvas.drawCircle(Offset.zero, innerR, rp);
    }
  }

  // ── Connecting arcs at key radii ──
  void _drawConnectingArcs(
      Canvas canvas, double holeR, double bandW, double p) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..strokeCap = StrokeCap.round;

    final fractions = [0.08, 0.20, 0.34, 0.48, 0.62, 0.78, 0.90];
    final thresholds = [0.06, 0.16, 0.28, 0.40, 0.54, 0.66, 0.82];

    for (int i = 0; i < fractions.length; i++) {
      if (p > thresholds[i]) {
        final lp = ((p - thresholds[i]) / 0.12).clamp(0.0, 1.0);
        paint.color = _kGoldMain.withValues(alpha: 0.10 * lp);

        final r = holeR + bandW * fractions[i];
        final sweep = 2 * pi * lp;
        final rect = Rect.fromCircle(center: Offset.zero, radius: r);
        canvas.drawArc(
            rect, rotation * (i.isEven ? 0.02 : -0.02), sweep, false, paint);
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
