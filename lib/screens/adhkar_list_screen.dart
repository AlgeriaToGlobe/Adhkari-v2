import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/adhkar_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/accessibility_bar.dart';
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
    final dark = AppColors.isDark(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Consumer<AdhkarProvider>(
        builder: (context, provider, _) {
          final category = provider.getCategoryById(categoryId);
          if (category == null) {
            return Scaffold(
              backgroundColor: AppColors.scaffold(context),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: AppColors.scaffold(context),
            body: Stack(
              children: [
                // ── Main scrollable content ──
                CustomScrollView(
                  slivers: [
                    // ── Styled app bar (text doesn't scale) ──
                    SliverAppBar(
                      expandedHeight: 120,
                      floating: false,
                      pinned: true,
                      backgroundColor:
                          dark ? AppColors.darkSurface : AppColors.brown,
                      foregroundColor:
                          dark ? AppColors.darkTextPrimary : AppColors.white,
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
                                  backgroundColor: AppColors.card(context),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: Text(
                                    'إعادة العدادات',
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontFamily: 'Amiri',
                                      color: AppColors.textP(context),
                                    ),
                                  ),
                                  content: Text(
                                    'هل تريد إعادة جميع العدادات في هذا القسم؟',
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
                      flexibleSpace: MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          textScaler: TextScaler.noScaling,
                        ),
                        child: FlexibleSpaceBar(
                          centerTitle: true,
                          title: Text(
                            category.title,
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: dark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.white,
                            ),
                          ),
                          background: Container(
                            decoration: BoxDecoration(
                              gradient: dark
                                  ? const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        AppColors.darkCard,
                                        AppColors.darkSurface,
                                      ],
                                    )
                                  : AppColors.headerGradient,
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
                                    color: dark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.white
                                            .withValues(alpha: 0.6),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ── Accessibility bar (font size + dark mode) ──
                    const SliverToBoxAdapter(
                      child: AccessibilityBar(),
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

                // ── Bottom padding for floating progress bar ──
                const SliverToBoxAdapter(
                  child: SizedBox(height: 60),
                ),
              ],
            ),

            // ── Floating sticky progress bar at bottom ──
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _FloatingProgressBar(
                completed: category.completedCount,
                total: category.totalCount,
                progress: category.progress,
                isAllCompleted: category.isAllCompleted,
                dark: dark,
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

/// A discrete floating progress bar pinned to the bottom of the screen.
/// Shows progress as a thin animated bar with percentage, visible while scrolling.
class _FloatingProgressBar extends StatelessWidget {
  final int completed;
  final int total;
  final double progress;
  final bool isAllCompleted;
  final bool dark;

  const _FloatingProgressBar({
    required this.completed,
    required this.total,
    required this.progress,
    required this.isAllCompleted,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    final barColor = isAllCompleted ? AppColors.counterCompleted : AppColors.gold;
    final percentage = (progress * 100).toInt();

    return Container(
      decoration: BoxDecoration(
        color: (dark ? AppColors.darkSurface : AppColors.white)
            .withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: AppColors.dividerC(context).withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.2 : 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Count + percentage row ──
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$completed / $total',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textS(context),
                    ),
                  ),
                  Text(
                    '$percentage%',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: barColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            // ── Thin animated progress bar ──
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                builder: (context, value, _) {
                  return LinearProgressIndicator(
                    value: value,
                    minHeight: 4,
                    backgroundColor: AppColors.progressBg(context),
                    valueColor: AlwaysStoppedAnimation<Color>(barColor),
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
