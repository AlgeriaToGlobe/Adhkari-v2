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
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.beigeLight,
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
                const Text(
                  'اختر الذكر',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
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
                              ? AppColors.gold
                              : AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.gold
                                : AppColors.divider,
                          ),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? AppColors.brownDark
                                : AppColors.textPrimary,
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
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'أو اكتب ذكرًا مخصصًا...',
                    hintTextDirection: TextDirection.rtl,
                    hintStyle: TextStyle(
                      fontFamily: 'Amiri',
                      color: AppColors.brownLight.withValues(alpha: 0.5),
                    ),
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.gold),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.check, color: AppColors.gold),
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
    final targets = [33, 99, 100, 500, 1000];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.beigeLight,
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
                const Text(
                  'اختر الهدف',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
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
                              ? AppColors.gold
                              : AppColors.cardBackground,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.gold
                                : AppColors.divider,
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
                                ? AppColors.brownDark
                                : AppColors.textPrimary,
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
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AppColors.beigeLight,
          title: const Text(
            'إعادة العداد',
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          content: const Text(
            'هل تريد إعادة العداد إلى صفر؟',
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Amiri',
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  color: AppColors.brownLight,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                provider.resetTasbeeh();
                Navigator.pop(ctx);
              },
              child: const Text(
                'إعادة',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  color: AppColors.gold,
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.beigeLight,
        appBar: AppBar(
          title: const Text(
            'التسبيح',
            style: TextStyle(
              fontFamily: 'Amiri',
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: AppColors.brown,
          foregroundColor: AppColors.white,
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
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brown.withValues(alpha: 0.06),
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
                          style: const TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.brown,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.edit,
                          size: 16,
                          color: AppColors.gold.withValues(alpha: 0.6),
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
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${provider.tasbeehCount}',
                                style: const TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 56,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.brown,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'من ${provider.tasbeehTarget}',
                                style: const TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
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
                          ? AppColors.gold
                          : AppColors.brownLight,
                      onTap: () => provider
                          .setVibrationEnabled(!provider.vibrationEnabled),
                    ),
                    const SizedBox(width: 24),

                    // Reset
                    _buildControlButton(
                      icon: Icons.refresh,
                      color: AppColors.brownLight,
                      onTap: () =>
                          _showResetConfirmation(context, provider),
                    ),
                    const SizedBox(width: 24),

                    // Target selector
                    _buildControlButton(
                      icon: Icons.tune,
                      color: AppColors.brownLight,
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
          color: AppColors.cardBackground,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.divider,
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

  _TasbeehRingPainter({
    required this.count,
    required this.target,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = AppColors.beigeWarm
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 12, bgPaint);

    // Outer ring
    final ringPaint = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius - 4, ringPaint);

    // Tick marks
    if (target > 0) {
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
          ..color = isFilled ? AppColors.gold : AppColors.beigeDark
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

  @override
  bool shouldRepaint(covariant _TasbeehRingPainter oldDelegate) {
    return oldDelegate.count != count || oldDelegate.target != target;
  }
}
