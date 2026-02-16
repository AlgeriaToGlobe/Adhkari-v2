import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DailyProgressWidget extends StatelessWidget {
  final double progress;
  final int completed;
  final int total;

  const DailyProgressWidget({
    super.key,
    required this.progress,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.isDark(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: dark
            ? AppColors.darkHeaderGradientSubtle
            : AppColors.headerGradientSubtle,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (dark ? Colors.black : AppColors.brownDark)
                .withValues(alpha: dark ? 0.3 : 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          // Circular progress
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 6,
                    backgroundColor: AppColors.white.withValues(alpha: 0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.gold,
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gold,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تقدمك اليومي',
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$completed من $total ذكر',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 14,
                    color: AppColors.white.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getMotivationalText(progress),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 13,
                    color: AppColors.gold.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMotivationalText(double progress) {
    if (progress >= 1.0) return 'ما شاء الله! أتممت أذكارك';
    if (progress >= 0.75) return 'أحسنت! اقتربت من الإتمام';
    if (progress >= 0.5) return 'واصل، قطعت أكثر من النصف';
    if (progress >= 0.25) return 'بداية طيبة، بارك الله فيك';
    if (progress > 0) return 'ابدأ يومك بذكر الله';
    return 'لم تبدأ بعد، هيا نبدأ!';
  }
}
