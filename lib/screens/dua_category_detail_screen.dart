import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/dua_categories_data.dart';
import '../theme/app_colors.dart';
import '../widgets/accessibility_bar.dart';
import '../widgets/arch_header.dart';
import '../widgets/diamond_divider.dart';
import '../widgets/geometric_bg.dart';

/// Shows all duas within a selected category.
class DuaCategoryDetailScreen extends StatelessWidget {
  final String categoryId;

  const DuaCategoryDetailScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final category = DuaCategoriesData.getCategoryById(categoryId);

    if (category == null) {
      return const Scaffold(
        body: Center(child: Text('لم يتم العثور على القسم')),
      );
    }

    final dark = AppColors.isDark(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffold(context),
        body: GeometricBg(
          child: CustomScrollView(
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
                            ? AppColors.darkHeaderGradient
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

              // ── Duas list with diamond dividers ──
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final itemIndex = index ~/ 2;
                    if (index.isEven) {
                      final dua = category.duas[itemIndex];
                      return Padding(
                        padding: EdgeInsets.only(
                          top: itemIndex == 0 ? 16 : 0,
                          bottom: itemIndex == category.duas.length - 1
                              ? 32
                              : 0,
                        ),
                        child: _DuaDetailCard(
                          dua: dua,
                          index: itemIndex + 1,
                          total: category.duas.length,
                        ),
                      );
                    } else {
                      return const DiamondDivider();
                    }
                  },
                  childCount: category.duas.length * 2 - 1,
                ),
              ),

              // ── Bottom padding ──
              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DuaDetailCard extends StatelessWidget {
  final DuaItem dua;
  final int index;
  final int total;

  const _DuaDetailCard({
    required this.dua,
    required this.index,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.isDark(context);
    final accentGold = AppColors.goldC(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: dark
              ? Colors.white.withValues(alpha: 0.08)
              : AppColors.dividerC(context).withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: AppColors.cardShadow(context),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Counter badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: accentGold.withValues(alpha: dark ? 0.15 : 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$index / $total',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: accentGold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Dua text
          Text(
            dua.text,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              fontFamily: 'Amiri',
              height: 2.0,
              color: AppColors.textP(context),
            ),
          ),

          // Notes
          if (dua.notes != null) ...[
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: accentGold.withValues(alpha: dark ? 0.1 : 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                textDirection: TextDirection.rtl,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: accentGold.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      dua.notes!,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 14,
                        color: AppColors.brownLightC(context)
                            .withValues(alpha: 0.8),
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Gold divider line
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 16),
            color: accentGold.withValues(alpha: 0.2),
          ),

          // Reference row and copy button
          Row(
            textDirection: TextDirection.rtl,
            children: [
              // Reference
              if (dua.reference != null) ...[
                Icon(
                  Icons.menu_book_outlined,
                  size: 14,
                  color: accentGold.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    dua.reference!,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 12,
                      color: accentGold.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ] else
                const Spacer(),
              // Copy button
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: dua.text));
                  AppColors.showStyledSnackBar(
                    context,
                    'تم النسخ',
                    icon: Icons.check,
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentGold.withValues(alpha: dark ? 0.1 : 0.06),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.copy_outlined,
                        size: 14,
                        color: accentGold.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'نسخ',
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 12,
                          color: accentGold.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
