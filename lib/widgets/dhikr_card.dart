import 'package:flutter/material.dart';
import '../models/dhikr.dart';
import '../theme/app_colors.dart';
import 'counter_widget.dart';

class DhikrCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: dhikr.isCompleted
              ? AppColors.counterCompleted.withValues(alpha: 0.05)
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: dhikr.isCompleted
                ? AppColors.counterCompleted.withValues(alpha: 0.3)
                : AppColors.divider,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Counter on the left (visually on the right in RTL)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: CounterWidget(
                  currentCount: dhikr.currentCount,
                  targetCount: dhikr.targetCount,
                  onTap: onCounterTap,
                  isCompleted: dhikr.isCompleted,
                ),
              ),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dhikr text — forced RTL alignment
                    Text(
                      dhikr.text,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 2.0,
                          ),
                    ),
                    if (dhikr.fadl != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          dhikr.fadl!,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.brownLight,
                                    height: 1.6,
                                  ),
                        ),
                      ),
                    ],
                    // Reference and grade row
                    if (dhikr.reference != null) ...[
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: onInfoTap,
                        child: Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            _GradeBadge(grade: dhikr.grade),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                dhikr.reference!,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontSize: 12,
                                      color: AppColors.brownLight,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color:
                                  AppColors.brownLight.withValues(alpha: 0.6),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
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
        return AppColors.counterCompleted.withValues(alpha: 0.15);
      case HadithGrade.hasan:
        return AppColors.gold.withValues(alpha: 0.15);
      case HadithGrade.daif:
        return AppColors.brownLight.withValues(alpha: 0.15);
      case HadithGrade.mawdu:
        return Colors.red.withValues(alpha: 0.1);
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
