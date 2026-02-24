import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/dua_categories_data.dart';
import '../theme/app_colors.dart';
import '../widgets/arch_header.dart';
import '../widgets/diamond_divider.dart';

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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffold(context),
        body: Column(
          children: [
            // ── Header with back button ──
            Stack(
              children: [
                ArchHeader(
                  title: category.title,
                  subtitle: category.subtitle,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: SafeArea(
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Duas list ──
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: category.duas.length,
                itemBuilder: (context, index) {
                  final dua = category.duas[index];
                  final isLast = index == category.duas.length - 1;

                  return Column(
                    children: [
                      _DuaDetailCard(
                        dua: dua,
                        index: index + 1,
                        total: category.duas.length,
                      ),
                      if (!isLast) const DiamondDivider(),
                    ],
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
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(AppColors.radiusM),
        border: Border.all(
          color: AppColors.dividerC(context).withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: AppColors.cardShadow(context),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
