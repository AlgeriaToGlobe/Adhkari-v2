import 'package:flutter/material.dart';
import '../models/dhikr.dart';
import '../theme/app_colors.dart';

/// Redesigned dhikr card matching the reference:
/// - Large centered Arabic text
/// - Counter below text in (current/targetx) format
/// - Entire card tappable to increment
/// - Info/reference row at bottom
class DhikrCard extends StatefulWidget {
  final Dhikr dhikr;
  final VoidCallback onCounterTap;
  final VoidCallback? onInfoTap;

  const DhikrCard({
    super.key,
    required this.dhikr,
    required this.onCounterTap,
    this.onInfoTap,
  });

  @override
  State<DhikrCard> createState() => _DhikrCardState();
}

class _DhikrCardState extends State<DhikrCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.dhikr.isCompleted) {
      _controller.forward().then((_) => _controller.reverse());
      widget.onCounterTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dhikr = widget.dhikr;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          decoration: BoxDecoration(
            color: dhikr.isCompleted
                ? AppColors.counterCompleted.withValues(alpha: 0.04)
                : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: dhikr.isCompleted
                  ? AppColors.counterCompleted.withValues(alpha: 0.2)
                  : AppColors.divider.withValues(alpha: 0.6),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.brown.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // ── Arabic text (centered, large) ──
              Text(
                dhikr.text,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimary,
                  height: 2.0,
                ),
              ),

              const SizedBox(height: 20),

              // ── Counter pill ──
              _CounterPill(
                currentCount: dhikr.currentCount,
                targetCount: dhikr.targetCount,
                isCompleted: dhikr.isCompleted,
              ),

              // ── Fadl (virtue) text ──
              if (dhikr.fadl != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    dhikr.fadl!,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 14,
                      color: AppColors.brownLight.withValues(alpha: 0.8),
                      height: 1.6,
                    ),
                  ),
                ),
              ],

              // ── Reference / action row ──
              const SizedBox(height: 14),
              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Grade badge
                  if (dhikr.reference != null) ...[
                    _GradeBadge(grade: dhikr.grade),
                    const SizedBox(width: 8),
                    Flexible(
                      child: GestureDetector(
                        onTap: widget.onInfoTap,
                        child: Text(
                          dhikr.reference!,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 12,
                            color: AppColors.brownLight.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: widget.onInfoTap,
                      child: Icon(
                        Icons.info_outline_rounded,
                        size: 16,
                        color: AppColors.gold.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Counter displayed as a pill: "(1/3x)" or checkmark when done.
class _CounterPill extends StatelessWidget {
  final int currentCount;
  final int targetCount;
  final bool isCompleted;

  const _CounterPill({
    required this.currentCount,
    required this.targetCount,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.counterCompleted.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.counterCompleted.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              size: 18,
              color: AppColors.counterCompleted,
            ),
            const SizedBox(width: 6),
            Text(
              'تم',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.counterCompleted.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      );
    }

    final progress = targetCount > 0
        ? (currentCount / targetCount).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Mini progress ring
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 2.5,
              backgroundColor: AppColors.gold.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
              strokeCap: StrokeCap.round,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            targetCount == 1
                ? '(${currentCount}x)'
                : '($currentCount/${targetCount}x)',
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.gold,
            ),
          ),
        ],
      ),
    );
  }
}

class _GradeBadge extends StatelessWidget {
  final HadithGrade grade;

  const _GradeBadge({required this.grade});

  Color get _backgroundColor {
    switch (grade) {
      case HadithGrade.sahih:
      case HadithGrade.mutawatir:
        return AppColors.counterCompleted.withValues(alpha: 0.12);
      case HadithGrade.hasan:
        return AppColors.gold.withValues(alpha: 0.12);
      case HadithGrade.daif:
        return AppColors.brownLight.withValues(alpha: 0.12);
      case HadithGrade.mawdu:
        return Colors.red.withValues(alpha: 0.08);
    }
  }

  Color get _textColor {
    switch (grade) {
      case HadithGrade.sahih:
      case HadithGrade.mutawatir:
        return AppColors.counterCompleted;
      case HadithGrade.hasan:
        return AppColors.goldDark;
      case HadithGrade.daif:
        return AppColors.brownLight;
      case HadithGrade.mawdu:
        return Colors.red.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        grade.arabicLabel,
        style: TextStyle(
          fontFamily: 'Amiri',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: _textColor,
        ),
      ),
    );
  }
}
