import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/dhikr.dart';
import '../theme/app_colors.dart';
import '../widgets/geometric_bg.dart';

class HadithDetailScreen extends StatelessWidget {
  final Dhikr dhikr;

  const HadithDetailScreen({
    super.key,
    required this.dhikr,
  });

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.isDark(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffold(context),
        appBar: AppBar(
          title: const Text('تخريج الحديث'),
          backgroundColor: dark ? AppColors.darkSurface : AppColors.brown,
          foregroundColor: dark ? AppColors.darkTextPrimary : AppColors.white,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.copy_outlined, size: 22),
              tooltip: 'نسخ',
              onPressed: () {
                final text = StringBuffer(dhikr.text);
                if (dhikr.fadl != null) text.write('\n\n${dhikr.fadl}');
                if (dhikr.reference != null) text.write('\n\n${dhikr.reference}');
                Clipboard.setData(ClipboardData(text: text.toString()));
                AppColors.showStyledSnackBar(
                  context,
                  'تم النسخ',
                  icon: Icons.check,
                );
              },
            ),
          ],
        ),
        body: GeometricBg(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              // Dhikr text
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.card(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.dividerC(context)),
                  boxShadow: [
                    BoxShadow(
                      color: (dark ? Colors.black : AppColors.brown)
                          .withValues(alpha: dark ? 0.15 : 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  dhikr.text,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textP(context),
                    height: 2.0,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Info sections
              _InfoSection(
                title: 'عدد التكرار',
                content: '${dhikr.targetCount} ${dhikr.targetCount == 1 ? "مرة" : "مرات"}',
                icon: Icons.repeat,
              ),

              if (dhikr.fadl != null)
                _InfoSection(
                  title: 'الفضل',
                  content: dhikr.fadl!,
                  icon: Icons.star_outline,
                ),

              if (dhikr.reference != null)
                _InfoSection(
                  title: 'التخريج',
                  content: dhikr.reference!,
                  icon: Icons.menu_book_outlined,
                ),

              _InfoSection(
                title: 'درجة الحديث',
                content: dhikr.grade.arabicLabel,
                icon: Icons.verified_outlined,
                trailing: _buildGradeBadge(context),
              ),

              if (dhikr.notes != null)
                _InfoSection(
                  title: 'ملاحظات',
                  content: dhikr.notes!,
                  icon: Icons.note_outlined,
                ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildGradeBadge(BuildContext context) {
    final dark = AppColors.isDark(context);
    final accentGold = AppColors.goldC(context);
    Color bgColor;
    Color textColor;

    switch (dhikr.grade) {
      case HadithGrade.sahih:
      case HadithGrade.mutawatir:
        bgColor = AppColors.counterCompleted.withValues(alpha: 0.15);
        textColor = AppColors.counterCompleted;
      case HadithGrade.hasan:
        bgColor = accentGold.withValues(alpha: 0.15);
        textColor = accentGold;
      case HadithGrade.daif:
        bgColor = AppColors.brownLightC(context).withValues(alpha: 0.15);
        textColor = AppColors.brownLightC(context);
      case HadithGrade.mawdu:
        bgColor = Colors.red.withValues(alpha: 0.1);
        textColor = dark ? Colors.red.shade400 : Colors.red.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        dhikr.grade.arabicLabel,
        style: TextStyle(
          fontFamily: 'Amiri',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Widget? trailing;

  const _InfoSection({
    required this.title,
    required this.content,
    required this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final accentGold = AppColors.goldC(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerC(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(icon, size: 20, color: accentGold),
              const SizedBox(width: 8),
              Text(
                title,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: accentGold,
                ),
              ),
              if (trailing != null) ...[
                const Spacer(),
                trailing!,
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 16,
              color: AppColors.textP(context),
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
