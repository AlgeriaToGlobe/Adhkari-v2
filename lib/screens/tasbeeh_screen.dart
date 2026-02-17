import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/adhkar_provider.dart';
import '../theme/app_colors.dart';

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final TextEditingController _customLabelController = TextEditingController();

  final List<String> _presetLabels = [
    'سبحان الله',
    'الحمد لله',
    'الله أكبر',
    'لا إله إلا الله',
    'أستغفر الله',
    'سبحان الله وبحمده',
    'سبحان الله العظيم',
    'لا حول ولا قوة إلا بالله',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _customLabelController.dispose();
    super.dispose();
  }

  void _onCounterTap(AdhkarProvider provider) {
    _pulseController.forward().then((_) => _pulseController.reverse());
    provider.incrementTasbeeh();
  }

  void _showLabelPicker(BuildContext context, AdhkarProvider provider) {
    final dark = AppColors.isDark(context);
    final accentGold = AppColors.goldC(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.scaffold(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'اختر الذكر',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textP(context),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: _presetLabels.map((label) {
                    final isSelected = label == provider.tasbeehLabel;
                    return GestureDetector(
                      onTap: () {
                        provider.setTasbeehLabel(label);
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? accentGold
                              : AppColors.card(context),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? accentGold
                                : AppColors.dividerC(context),
                          ),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? (dark ? AppColors.darkBg : AppColors.brownDark)
                                : AppColors.textP(context),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _customLabelController,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 16,
                    color: AppColors.textP(context),
                  ),
                  decoration: InputDecoration(
                    hintText: 'أو اكتب ذكرًا مخصصًا...',
                    hintTextDirection: TextDirection.rtl,
                    hintStyle: TextStyle(
                      fontFamily: 'Amiri',
                      color: AppColors.textS(context).withValues(alpha: 0.5),
                    ),
                    filled: true,
                    fillColor: AppColors.card(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.dividerC(context)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.dividerC(context)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: accentGold),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.check, color: accentGold),
                      onPressed: () {
                        if (_customLabelController.text.trim().isNotEmpty) {
                          provider.setTasbeehLabel(
                              _customLabelController.text.trim());
                          _customLabelController.clear();
                          Navigator.pop(ctx);
                        }
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      provider.setTasbeehLabel(value.trim());
                      _customLabelController.clear();
                      Navigator.pop(ctx);
                    }
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTargetPicker(BuildContext context, AdhkarProvider provider) {
    final dark = AppColors.isDark(context);
    final accentGold = AppColors.goldC(context);
    final targets = [33, 99, 100, 500, 1000];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.scaffold(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'اختر الهدف',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textP(context),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: targets.map((target) {
                    final isSelected = target == provider.tasbeehTarget;
                    return GestureDetector(
                      onTap: () {
                        provider.setTasbeehTarget(target);
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? accentGold
                              : AppColors.card(context),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? accentGold
                                : AppColors.dividerC(context),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$target',
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? (dark ? AppColors.darkBg : AppColors.brownDark)
                                : AppColors.textP(context),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showResetConfirmation(BuildContext context, AdhkarProvider provider) {
    final accentGold = AppColors.goldC(context);
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AppColors.card(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'إعادة العداد',
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontWeight: FontWeight.w700,
              color: AppColors.textP(context),
            ),
          ),
          content: Text(
            'هل تريد إعادة العداد إلى صفر؟',
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Amiri',
              color: AppColors.textS(context),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  color: AppColors.textS(context),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                provider.resetTasbeeh();
                Navigator.pop(ctx);
              },
              child: Text(
                'إعادة',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  color: accentGold,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.isDark(context);
    final accentGold = AppColors.goldC(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffold(context),
        appBar: AppBar(
          title: const Text(
            'التسبيح',
            style: TextStyle(
              fontFamily: 'Amiri',
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: dark ? AppColors.darkSurface : AppColors.brown,
          foregroundColor: dark ? AppColors.darkTextPrimary : AppColors.white,
          centerTitle: true,
          elevation: 0,
        ),
        body: Consumer<AdhkarProvider>(
          builder: (context, provider, _) {
            final bool isCompleted =
                provider.tasbeehCount >= provider.tasbeehTarget;

            return Column(
              children: [
                const Spacer(flex: 2),

                // Dhikr label card
                GestureDetector(
                  onTap: () => _showLabelPicker(context, provider),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.card(context),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (dark ? Colors.black : AppColors.brown)
                              .withValues(alpha: dark ? 0.15 : 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          provider.tasbeehLabel,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.brownC(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.edit,
                          size: 16,
                          color: accentGold.withValues(alpha: 0.6),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Large circular counter
                GestureDetector(
                  onTap: () => _onCounterTap(provider),
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: child,
                      );
                    },
                    child: SizedBox(
                      width: 220,
                      height: 220,
                      child: CustomPaint(
                        painter: _TasbeehRingPainter(
                          count: provider.tasbeehCount,
                          target: provider.tasbeehTarget,
                          isDark: dark,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${provider.tasbeehCount}',
                                style: TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 56,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.brownC(context),
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'من ${provider.tasbeehTarget}',
                                style: TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 16,
                                  color: AppColors.textS(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Completion message
                AnimatedOpacity(
                  opacity: isCompleted ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: const Text(
                    'ما شاء الله',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.counterCompleted,
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // Bottom control bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Vibration toggle
                    _buildControlButton(
                      icon: Icons.vibration,
                      color: provider.vibrationEnabled
                          ? accentGold
                          : AppColors.brownLightC(context),
                      onTap: () => provider
                          .setVibrationEnabled(!provider.vibrationEnabled),
                    ),
                    const SizedBox(width: 24),

                    // Reset
                    _buildControlButton(
                      icon: Icons.refresh,
                      color: AppColors.brownLightC(context),
                      onTap: () =>
                          _showResetConfirmation(context, provider),
                    ),
                    const SizedBox(width: 24),

                    // Target selector
                    _buildControlButton(
                      icon: Icons.tune,
                      color: AppColors.brownLightC(context),
                      onTap: () => _showTargetPicker(context, provider),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.card(context),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.dividerC(context),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: color,
          size: 22,
        ),
      ),
    );
  }
}

class _TasbeehRingPainter extends CustomPainter {
  final int count;
  final int target;
  final bool isDark;

  _TasbeehRingPainter({
    required this.count,
    required this.target,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final goldColor = isDark ? AppColors.darkGold : AppColors.gold;

    // Background circle
    final bgPaint = Paint()
      ..color = isDark ? AppColors.darkCard : AppColors.beigeWarm
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 12, bgPaint);

    // Outer ring
    final ringPaint = Paint()
      ..color = goldColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius - 4, ringPaint);

    // Progress indicator
    if (target > 0) {
      if (target > 100) {
        // Simplified arc for large targets
        final arcRadius = radius - 8;
        final bgArcPaint = Paint()
          ..color = isDark ? AppColors.darkDivider : AppColors.beigeDark
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: arcRadius),
          -pi / 2,
          2 * pi,
          false,
          bgArcPaint,
        );

        final progressArcPaint = Paint()
          ..color = goldColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round;
        final sweepAngle = 2 * pi * (count / target);
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: arcRadius),
          -pi / 2,
          sweepAngle,
          false,
          progressArcPaint,
        );
      } else {
        // Tick marks for small targets
        final tickCount = target;
        final tickRadius = radius - 4;
        final innerTickRadius = tickRadius - 10;

        for (int i = 0; i < tickCount; i++) {
          final angle = (2 * pi * i / tickCount) - (pi / 2);
          final outerX = center.dx + tickRadius * cos(angle);
          final outerY = center.dy + tickRadius * sin(angle);
          final innerX = center.dx + innerTickRadius * cos(angle);
          final innerY = center.dy + innerTickRadius * sin(angle);

          final isFilled = i < count;
          final tickPaint = Paint()
            ..color = isFilled
                ? goldColor
                : (isDark ? AppColors.darkDivider : AppColors.beigeDark)
            ..style = PaintingStyle.stroke
            ..strokeWidth = isFilled ? 2.5 : 1.5
            ..strokeCap = StrokeCap.round;

          canvas.drawLine(
            Offset(outerX, outerY),
            Offset(innerX, innerY),
            tickPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TasbeehRingPainter oldDelegate) {
    return oldDelegate.count != count ||
        oldDelegate.target != target ||
        oldDelegate.isDark != isDark;
  }
}
