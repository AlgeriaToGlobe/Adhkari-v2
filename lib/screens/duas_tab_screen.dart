import 'package:flutter/material.dart';
import '../data/dua_categories_data.dart';
import '../theme/app_colors.dart';
import '../utils/page_transitions.dart';
import '../widgets/arch_header.dart';
import 'dua_category_detail_screen.dart';

/// The "الأدعية" tab – shows all dua categories as a scrollable list.
class DuasTabScreen extends StatelessWidget {
  const DuasTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = DuaCategoriesData.getAllCategories();
    final accentGold = AppColors.goldC(context);
    final dark = AppColors.isDark(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ──
            const ArchHeader(
              title: 'الأدعية',
              subtitle: 'أدعية مأثورة من القرآن والسنة',
            ),

            const SizedBox(height: 8),

            // ── Category list ──
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        AppTransitions.fadeSlide(
                          DuaCategoryDetailScreen(categoryId: category.id),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card(context),
                        borderRadius:
                            BorderRadius.circular(AppColors.radiusM),
                        border: Border.all(
                          color: AppColors.dividerC(context)
                              .withValues(alpha: 0.5),
                        ),
                        boxShadow: AppColors.cardShadow(context),
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          // Icon
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: accentGold.withValues(alpha: 0.1),
                              border: Border.all(
                                color:
                                    accentGold.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              category.icon,
                              size: 24,
                              color: accentGold,
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Title + subtitle
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category.title,
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: 'Amiri',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textP(context),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  category.subtitle,
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: 'Amiri',
                                    fontSize: 13,
                                    color: AppColors.textS(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Count badge + arrow
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: accentGold
                                      .withValues(alpha: 0.1),
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${category.count}',
                                  style: TextStyle(
                                    fontFamily: 'Amiri',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: accentGold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 14,
                                color: AppColors.textS(context)
                                    .withValues(alpha: 0.5),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
