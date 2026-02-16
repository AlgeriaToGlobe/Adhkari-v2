import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/adhkar_provider.dart';
import '../theme/app_colors.dart';
import '../utils/hijri_date.dart';
import '../widgets/arch_header.dart';
import '../widgets/diamond_divider.dart';
import 'adhkar_list_screen.dart';
import 'tasbeeh_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Arabic day names indexed by DateTime.weekday (1 = Monday … 7 = Sunday)
  static const List<String> _arabicDays = [
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  static const List<String> _arabicMonths = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  String _formatArabicDate() {
    final now = DateTime.now();
    final day = _arabicDays[now.weekday - 1];
    final month = _arabicMonths[now.month - 1];
    return '$day، ${now.day} $month ${now.year}';
  }

  String _formatHijriDate() {
    final hijri = HijriDate.fromGregorian(DateTime.now());
    return '${hijri.day} ${hijri.monthName} ${hijri.year} هـ';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffold(context),
        body: Consumer<AdhkarProvider>(
          builder: (context, provider, _) {
            final progress = provider.overallProgress;
            final completed = provider.completedAdhkar;
            final total = provider.totalAdhkar;
            final percentage = (progress * 100).toInt();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── 1. Arch Header ──
                  const ArchHeader(
                    title: 'أذكاري',
                    subtitle: 'حصّن يومك بذكر الله',
                  ),

                  // ── 2. Date Card (overlapping header) ──
                  Transform.translate(
                    offset: const Offset(0, -16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.card(context),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.dividerC(context).withValues(alpha: 0.5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (AppColors.isDark(context) ? Colors.black : AppColors.brown)
                                  .withValues(alpha: 0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            // Date text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _formatHijriDate(),
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontFamily: 'Amiri',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textP(context),
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _formatArabicDate(),
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontFamily: 'Amiri',
                                      fontSize: 13,
                                      color: AppColors.textS(context)
                                          .withValues(alpha: 0.8),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Gold calendar icon
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.gold.withValues(alpha: 0.1),
                              ),
                              child: const Icon(
                                Icons.calendar_month_rounded,
                                size: 20,
                                color: AppColors.gold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── 3. Daily Progress Section ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section title
                        Text(
                          'تقدمك اليومي',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textP(context),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Progress card with brown gradient background
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: AppColors.headerGradientSubtle,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.brown.withValues(alpha: 0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Progress bar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 10,
                                  backgroundColor:
                                      AppColors.white.withValues(alpha: 0.15),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    AppColors.gold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Stats row
                              Row(
                                textDirection: TextDirection.rtl,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$completed من $total ذكر',
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontFamily: 'Amiri',
                                      fontSize: 14,
                                      color: AppColors.white
                                          .withValues(alpha: 0.85),
                                    ),
                                  ),
                                  Text(
                                    '$percentage%',
                                    textDirection: TextDirection.ltr,
                                    style: const TextStyle(
                                      fontFamily: 'Amiri',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.gold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── 4. Quick Access Row ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الوصول السريع',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textP(context),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // التسبيح button
                            _QuickAccessButton(
                              label: 'التسبيح',
                              icon: Icons.touch_app_outlined,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TasbeehScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 20),
                            // الدعاء button
                            _QuickAccessButton(
                              label: 'الدعاء',
                              icon: Icons.favorite_outline,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'قريبًا',
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Amiri',
                                        fontSize: 14,
                                      ),
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── 5. Category Grid ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الأذكار',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textP(context),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.95,
                          ),
                          itemCount: provider.categories.length,
                          itemBuilder: (context, index) {
                            final category = provider.categories[index];
                            return _CategoryCard(
                              title: category.title,
                              icon: category.icon,
                              count: category.totalCount,
                              progress: category.progress,
                              isCompleted: category.isAllCompleted,
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
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── 6. Bottom Diamond Divider ──
                  const DiamondDivider(),

                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quick Access Button
// ─────────────────────────────────────────────────────────────────────────────

class _QuickAccessButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAccessButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gold.withValues(alpha: 0.08),
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              size: 24,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textP(context),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Category Card
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final int count;
  final double progress;
  final bool isCompleted;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.count,
    required this.progress,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isCompleted
                ? AppColors.counterCompleted.withValues(alpha: 0.3)
                : AppColors.dividerC(context).withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: (AppColors.isDark(context) ? Colors.black : AppColors.brown)
                  .withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon in a colored circle
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? AppColors.counterCompleted.withValues(alpha: 0.1)
                      : AppColors.gold.withValues(alpha: 0.1),
                  border: Border.all(
                    color: isCompleted
                        ? AppColors.counterCompleted.withValues(alpha: 0.3)
                        : AppColors.gold.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  isCompleted ? Icons.check : icon,
                  size: 22,
                  color: isCompleted
                      ? AppColors.counterCompleted
                      : AppColors.gold,
                ),
              ),
              const SizedBox(height: 10),
              // Category title
              Text(
                title,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textP(context),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 4),
              // Count
              Text(
                '$count أذكار',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 12,
                  color: AppColors.textS(context),
                ),
              ),
              const SizedBox(height: 8),
              // Progress indicator
              SizedBox(
                width: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    backgroundColor: AppColors.progressBg(context),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted
                          ? AppColors.counterCompleted
                          : AppColors.gold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
