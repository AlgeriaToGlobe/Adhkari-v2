import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/adhkar_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/accessibility_bar.dart';
import 'adhkar_list_screen.dart';

/// The "الأذكار" tab – shows all adhkar categories as a scrollable list.
class AdhkarTabScreen extends StatelessWidget {
  const AdhkarTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffold(context),
        body: SafeArea(
          child: Consumer<AdhkarProvider>(
            builder: (context, provider, _) {
              final categories = provider.categories;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Title ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                    child: Text(
                      'الأذكار',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textP(context),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'اختر قسمًا لبدء القراءة',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 14,
                        color: AppColors.textS(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Accessibility bar ──
                  const AccessibilityBar(),

                  const SizedBox(height: 4),

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
                        final isCompleted = category.isAllCompleted;
                        final progressPercent =
                            (category.progress * 100).toInt();

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AdhkarListScreen(
                                  categoryId: category.id,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.card(context),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isCompleted
                                    ? AppColors.counterCompleted
                                        .withValues(alpha: 0.3)
                                    : AppColors.dividerC(context)
                                        .withValues(alpha: 0.5),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (AppColors.isDark(context)
                                          ? Colors.black
                                          : AppColors.brown)
                                      .withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              textDirection: TextDirection.rtl,
                              children: [
                                // Icon
                                Builder(
                                  builder: (context) {
                                    final accentGold = AppColors.goldC(context);
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isCompleted
                                            ? AppColors.counterCompleted
                                                .withValues(alpha: 0.1)
                                            : accentGold
                                                .withValues(alpha: 0.1),
                                        border: Border.all(
                                          color: isCompleted
                                              ? AppColors.counterCompleted
                                                  .withValues(alpha: 0.3)
                                              : accentGold
                                                  .withValues(alpha: 0.3),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Icon(
                                        isCompleted ? Icons.check : category.icon,
                                        size: 24,
                                        color: isCompleted
                                            ? AppColors.counterCompleted
                                            : accentGold,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 14),

                                // Title + subtitle + progress
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
                                        '${category.completedCount} من ${category.totalCount} ذكر',
                                        textDirection: TextDirection.rtl,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontFamily: 'Amiri',
                                          fontSize: 13,
                                          color: AppColors.textS(context),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Progress bar
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(3),
                                        child: LinearProgressIndicator(
                                          value: category.progress,
                                          minHeight: 5,
                                          backgroundColor:
                                              AppColors.progressBg(context),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            isCompleted
                                                ? AppColors.counterCompleted
                                                : AppColors.goldC(context),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Percentage
                                Text(
                                  '$progressPercent%',
                                  style: TextStyle(
                                    fontFamily: 'Amiri',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: isCompleted
                                        ? AppColors.counterCompleted
                                        : AppColors.goldC(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
