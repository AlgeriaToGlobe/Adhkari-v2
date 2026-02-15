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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.brownDark.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title
          const Text(
            'تقدمك اليومي',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 16),
          // Circular progress
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: AppColors.white.withValues(alpha: 0.15),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.gold,
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gold,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$completed/$total',
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 12,
                        color: AppColors.white.withValues(alpha: 0.7),
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Motivational text
          Text(
            _getMotivationalText(progress),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 14,
              color: AppColors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  String _getMotivationalText(double progress) {
    if (progress >= 1.0) return 'ما شاء الله! أتممت أذكارك اليوم';
    if (progress >= 0.75) return 'أحسنت! اقتربت من إتمام أذكارك';
    if (progress >= 0.5) return 'واصل، قطعت أكثر من النصف';
    if (progress >= 0.25) return 'بداية طيبة، واصل بارك الله فيك';
    if (progress > 0) return 'ابدأ يومك بذكر الله';
    return 'لم تبدأ بعد، هيا نبدأ!';
  }
}
