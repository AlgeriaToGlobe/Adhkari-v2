import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/adhkar_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/dhikr_card.dart';
import '../widgets/diamond_divider.dart';
import 'hadith_detail_screen.dart';

class AdhkarListScreen extends StatelessWidget {
  final String categoryId;

  const AdhkarListScreen({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Consumer<AdhkarProvider>(
        builder: (context, provider, _) {
          final category = provider.getCategoryById(categoryId);
          if (category == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: AppColors.beigeLight,
            body: CustomScrollView(
              slivers: [
                // ── Styled app bar ──
                SliverAppBar(
                  expandedHeight: 120,
                  floating: false,
                  pinned: true,
                  backgroundColor: AppColors.brown,
                  foregroundColor: AppColors.white,
                  centerTitle: true,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, size: 22),
                      tooltip: 'إعادة العدادات',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => Directionality(
                            textDirection: TextDirection.rtl,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: const Text(
                                'إعادة العدادات',
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(fontFamily: 'Amiri'),
                              ),
                              content: const Text(
                                'هل تريد إعادة جميع العدادات في هذا القسم؟',
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(fontFamily: 'Amiri'),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text(
                                    'إلغاء',
                                    style: TextStyle(fontFamily: 'Amiri'),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    provider.resetCategory(categoryId);
                                    Navigator.pop(ctx);
                                  },
                                  child: const Text(
                                    'إعادة',
                                    style: TextStyle(
                                      fontFamily: 'Amiri',
                                      color: AppColors.gold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      category.title,
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.headerGradient,
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 52),
                          child: Text(
                            category.subtitle,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 13,
                              color:
                                  AppColors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Progress bar strip ──
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.beigeWarm,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brown.withValues(alpha: 0.06),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          '${category.completedCount} من ${category.totalCount}',
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.brownLight,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: category.progress,
                              minHeight: 6,
                              backgroundColor: AppColors.beigeDark,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                category.isAllCompleted
                                    ? AppColors.counterCompleted
                                    : AppColors.gold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${(category.progress * 100).toInt()}%',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: category.isAllCompleted
                                ? AppColors.counterCompleted
                                : AppColors.gold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Adhkar list with diamond dividers ──
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      // Interleave cards and dividers
                      final itemIndex = index ~/ 2;
                      if (index.isEven) {
                        final dhikr = category.adhkar[itemIndex];
                        return Padding(
                          padding: EdgeInsets.only(
                            top: itemIndex == 0 ? 16 : 0,
                            bottom: itemIndex == category.adhkar.length - 1
                                ? 32
                                : 0,
                          ),
                          child: DhikrCard(
                            dhikr: dhikr,
                            onCounterTap: () {
                              provider.incrementDhikr(
                                  categoryId, dhikr.id);
                            },
                            onInfoTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      HadithDetailScreen(dhikr: dhikr),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return const DiamondDivider();
                      }
                    },
                    childCount: category.adhkar.length * 2 - 1,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
