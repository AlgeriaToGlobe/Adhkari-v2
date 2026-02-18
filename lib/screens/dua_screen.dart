import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../widgets/arch_header.dart';
import '../widgets/diamond_divider.dart';
import '../widgets/geometric_bg.dart';
import '../data/dua_data.dart';

class DuaScreen extends StatelessWidget {
  const DuaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final duas = DuaData.getAllDuas();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffold(context),
        body: GeometricBg(
          child: SingleChildScrollView(
          child: Column(
            children: [
              const ArchHeader(
                title: 'الدعاء',
                subtitle: 'أدعية مأثورة من القرآن والسنة',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    for (int i = 0; i < duas.length; i++) ...[
                      _DuaCard(dua: duas[i]),
                      if (i < duas.length - 1) const DiamondDivider(),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

class _DuaCard extends StatelessWidget {
  final Dua dua;

  const _DuaCard({required this.dua});

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.isDark(context);
    final accentGold = AppColors.goldC(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.dividerC(context).withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: AppColors.cardShadow(context),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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

          // Occasion
          if (dua.occasion != null) ...[
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.goldC(context).withValues(alpha: dark ? 0.1 : 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                dua.occasion!,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.brownLightC(context).withValues(alpha: 0.8),
                  height: 1.6,
                ),
              ),
            ),
          ],

          // Gold divider line
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 16),
            color: AppColors.goldC(context).withValues(alpha: 0.2),
          ),

          // Reference row and share button
          Row(
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
                    style: TextStyle(
                      fontSize: 12,
                      color: accentGold.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.copy_outlined,
                      size: 14,
                      color: accentGold.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
