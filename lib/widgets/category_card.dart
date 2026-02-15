import 'package:flutter/material.dart';
import '../models/adhkar_category.dart';
import '../theme/app_colors.dart';

class CategoryCard extends StatelessWidget {
  final AdhkarCategory category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: category.isAllCompleted
                ? AppColors.counterCompleted.withValues(alpha: 0.4)
                : AppColors.divider,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.brown.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              // Icon
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: category.isAllCompleted
                      ? AppColors.counterCompleted.withValues(alpha: 0.1)
                      : AppColors.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  category.isAllCompleted
                      ? Icons.check_circle
                      : category.icon,
                  color: category.isAllCompleted
                      ? AppColors.counterCompleted
                      : AppColors.gold,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      category.title,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.subtitle,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 10),
                    // Progress bar
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: category.progress,
                              backgroundColor:
                                  AppColors.beigeDark.withValues(alpha: 0.5),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                category.isAllCompleted
                                    ? AppColors.counterCompleted
                                    : AppColors.gold,
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${category.completedCount}/${category.totalCount}',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: category.isAllCompleted
                                ? AppColors.counterCompleted
                                : AppColors.brownLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Arrow
              Icon(
                Icons.chevron_left, // Left arrow because RTL
                color: AppColors.brownLight.withValues(alpha: 0.4),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
