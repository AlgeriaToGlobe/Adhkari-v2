import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/adhkar_provider.dart';
import '../theme/app_colors.dart';
import '../utils/hijri_date.dart';
import '../utils/page_transitions.dart';
import '../widgets/arch_header.dart';
import '../widgets/diamond_divider.dart';
import 'adhkar_list_screen.dart';

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

  // Arabic day abbreviations for streak widget (Mon→Sun)
  static const List<String> _dayAbbreviations = [
    'ن',
    'ث',
    'ر',
    'خ',
    'ج',
    'س',
    'ح',
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
    final dark = AppColors.isDark(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Consumer<AdhkarProvider>(
          builder: (context, provider, _) {
            final progress = provider.overallProgress;
            final completed = provider.completedAdhkar;
            final total = provider.totalAdhkar;
            final percentage = (progress * 100).toInt();

            return RefreshIndicator(
              color: AppColors.goldC(context),
              backgroundColor: AppColors.card(context),
              displacement: 40,
              onRefresh: () async {
                await provider.checkDailyReset();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                            borderRadius: BorderRadius.circular(AppColors.radiusM),
                            border: dark
                                ? AppColors.cardBorder(context)
                                : Border.all(
                                    color: AppColors.dividerC(context).withValues(alpha: 0.5),
                                  ),
                            boxShadow: AppColors.cardShadow(context),
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
                                  color: AppColors.goldC(context).withValues(alpha: 0.1),
                                ),
                                child: Icon(
                                  Icons.calendar_month_rounded,
                                  size: 20,
                                  color: AppColors.goldC(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ── 3. Daily Streak Section ──
                    _StreakWidget(
                      streakCount: provider.streakCount,
                      weekCompletion: provider.weekCompletion,
                    ),

                    const SizedBox(height: 16),

                    // ── 4. Daily Progress Section ──
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
                              gradient: dark
                                  ? AppColors.darkHeaderGradientSubtle
                                  : AppColors.headerGradientSubtle,
                              borderRadius: BorderRadius.circular(AppColors.radiusM),
                              boxShadow: AppColors.elevatedShadow(context),
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
                                        AlwaysStoppedAnimation<Color>(
                                      AppColors.goldC(context),
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
                                      style: TextStyle(
                                        fontFamily: 'Amiri',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.goldC(context),
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

                    // ── 5. Virtue of Dhikr ──
                    const _FadlDhikrCard(),

                    const SizedBox(height: 24),

                    // ── 6. Category Grid ──
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
                                    AppTransitions.fadeSlide(
                                      AdhkarListScreen(
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

                    // ── 7. Bottom Diamond Divider ──
                    const DiamondDivider(),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Streak Widget
// ─────────────────────────────────────────────────────────────────────────────

class _StreakWidget extends StatelessWidget {
  final int streakCount;
  final List<bool> weekCompletion;

  const _StreakWidget({
    required this.streakCount,
    required this.weekCompletion,
  });

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.isDark(context);
    final accentGold = AppColors.goldC(context);
    final todayIndex = DateTime.now().weekday - 1; // 0=Monday

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(AppColors.radiusM),
          border: dark
              ? AppColors.cardBorder(context)
              : Border.all(
                  color: AppColors.dividerC(context).withValues(alpha: 0.5),
                ),
          boxShadow: AppColors.cardShadow(context),
        ),
        child: Column(
          children: [
            // Streak header row
            Row(
              textDirection: TextDirection.rtl,
              children: [
                Icon(
                  Icons.local_fire_department_rounded,
                  size: 22,
                  color: streakCount > 0 ? accentGold : AppColors.textS(context),
                ),
                const SizedBox(width: 8),
                Text(
                  streakCount > 0
                      ? '$streakCount ${streakCount == 1 ? "يوم" : "أيام"} متتالية'
                      : 'ابدأ سلسلتك اليوم',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textP(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Week dots
            Row(
              textDirection: TextDirection.rtl,
              children: List.generate(7, (index) {
                // RTL: index 0 = rightmost. Map to weekday.
                // In Arabic week display: Sat, Sun, Mon, Tue, Wed, Thu, Fri
                // We use Mon-Sun (0-6) internally
                final isActive = index < weekCompletion.length &&
                    weekCompletion[index];
                final isToday = index == todayIndex;

                return Expanded(
                  child: Column(
                    children: [
                      Text(
                        HomeScreen._dayAbbreviations[index],
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 11,
                          color: AppColors.textS(context),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: isToday ? 10 : 8,
                        height: isToday ? 10 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? accentGold
                              : AppColors.progressBg(context),
                          border: isToday
                              ? Border.all(
                                  color: accentGold,
                                  width: 2,
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Virtue of Dhikr Card (فضل الذكر)
// ─────────────────────────────────────────────────────────────────────────────

class _FadlDhikrCard extends StatelessWidget {
  const _FadlDhikrCard();

  static const List<_DhikrQuote> _quotes = [
    _DhikrQuote(
      text: 'فَاذْكُرُونِي أَذْكُرْكُمْ وَاشْكُرُوا لِي وَلَا تَكْفُرُونِ',
      source: 'سورة البقرة، آية ١٥٢',
      isQuran: true,
    ),
    _DhikrQuote(
      text:
          'وَالذَّاكِرِينَ اللَّهَ كَثِيرًا وَالذَّاكِرَاتِ أَعَدَّ اللَّهُ لَهُم مَّغْفِرَةً وَأَجْرًا عَظِيمًا',
      source: 'سورة الأحزاب، آية ٣٥',
      isQuran: true,
    ),
    _DhikrQuote(
      text:
          'مَثَلُ الَّذِي يَذْكُرُ رَبَّهُ وَالَّذِي لَا يَذْكُرُ رَبَّهُ مَثَلُ الحَيِّ وَالمَيِّتِ',
      source: 'رواه البخاري',
      isQuran: false,
    ),
    _DhikrQuote(
      text: 'لَا يَزَالُ لِسَانُكَ رَطْبًا مِنْ ذِكْرِ اللَّهِ تَعَالَى',
      source: 'رواه الترمذي وابن ماجه',
      isQuran: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.isDark(context);
    final accentGold = AppColors.goldC(context);
    final quote = _quotes[Random().nextInt(_quotes.length)];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'فضل الذكر',
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: BorderRadius.circular(AppColors.radiusM),
              border: dark
                  ? AppColors.cardBorder(context)
                  : Border.all(
                      color: accentGold.withValues(alpha: 0.25),
                    ),
              boxShadow: AppColors.cardShadow(context),
            ),
            child: Column(
              children: [
                // Decorative quotation mark
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.goldLeafGradient(context)
                          .createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: Icon(
                    quote.isQuran
                        ? Icons.menu_book_rounded
                        : Icons.format_quote_rounded,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                // Quote text
                Text(
                  quote.isQuran
                      ? '﴿ ${quote.text} ﴾'
                      : '« ${quote.text} »',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textP(context),
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 10),
                // Source
                Text(
                  quote.source,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 13,
                    color: accentGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DhikrQuote {
  final String text;
  final String source;
  final bool isQuran;

  const _DhikrQuote({
    required this.text,
    required this.source,
    required this.isQuran,
  });
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
    final dark = AppColors.isDark(context);
    final accentGold = AppColors.goldC(context);
    final progressColor =
        isCompleted ? AppColors.counterCompleted : accentGold;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isCompleted
                ? AppColors.counterCompleted.withValues(alpha: 0.3)
                : dark
                    ? Colors.white.withValues(alpha: 0.08)
                    : AppColors.dividerC(context).withValues(alpha: 0.5),
          ),
          boxShadow: AppColors.cardShadow(context),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon inside a circular progress ring
              SizedBox(
                width: 52,
                height: 52,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Circular progress ring
                    SizedBox(
                      width: 52,
                      height: 52,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 2.5,
                        backgroundColor: AppColors.progressBg(context),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(progressColor),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    // Icon centered inside
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? AppColors.counterCompleted
                                .withValues(alpha: 0.1)
                            : accentGold.withValues(alpha: 0.1),
                      ),
                      child: Icon(
                        isCompleted ? Icons.check : icon,
                        size: 20,
                        color: progressColor,
                      ),
                    ),
                  ],
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
            ],
          ),
        ),
      ),
    );
  }
}
