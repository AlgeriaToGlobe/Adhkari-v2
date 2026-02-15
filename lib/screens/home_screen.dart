import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/adhkar_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/arch_header.dart';
import '../widgets/diamond_divider.dart';
import '../widgets/progress_indicator_widget.dart';
import 'adhkar_list_screen.dart';
import 'free_dhikr_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<_FeatureItem> _features = [
    _FeatureItem(
      id: 'morning',
      title: 'أذكار الصباح',
      icon: Icons.wb_sunny_outlined,
    ),
    _FeatureItem(
      id: 'evening',
      title: 'أذكار المساء',
      icon: Icons.nightlight_outlined,
    ),
    _FeatureItem(
      id: 'sleep',
      title: 'أذكار النوم',
      icon: Icons.bedtime_outlined,
    ),
    _FeatureItem(
      id: 'wakeup',
      title: 'أذكار الاستيقاظ',
      icon: Icons.alarm_outlined,
    ),
    _FeatureItem(
      id: 'afterSalah',
      title: 'أذكار بعد الصلاة',
      icon: Icons.mosque_outlined,
    ),
    _FeatureItem(
      id: 'free',
      title: 'التسبيح الحر',
      icon: Icons.touch_app_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.beigeLight,
        body: Consumer<AdhkarProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  // ── Arch header with title ──
                  Stack(
                    children: [
                      const ArchHeader(
                        title: 'أذكاري',
                        subtitle: 'حصّن يومك بذكر الله',
                      ),
                      // Settings button
                      Positioned(
                        top: 0,
                        left: 0,
                        child: SafeArea(
                          child: IconButton(
                            icon: Icon(
                              Icons.settings_outlined,
                              color: AppColors.white.withValues(alpha: 0.7),
                              size: 22,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SettingsScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ── Daily progress widget ──
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: DailyProgressWidget(
                      progress: provider.overallProgress,
                      completed: provider.completedAdhkar,
                      total: provider.totalAdhkar,
                    ),
                  ),

                  // ── Diamond divider ──
                  const DiamondDivider(),

                  // ── Feature grid (2 columns) ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 1.35,
                      ),
                      itemCount: _features.length,
                      itemBuilder: (context, index) {
                        final feature = _features[index];
                        // Calculate progress for this category
                        final category =
                            provider.getCategoryById(feature.id);
                        final progress = category?.progress ?? 0.0;
                        final isCompleted =
                            category?.isAllCompleted ?? false;

                        return _FeatureCard(
                          title: feature.title,
                          icon: feature.icon,
                          progress: progress,
                          isCompleted: isCompleted,
                          isFreeMode: feature.id == 'free',
                          onTap: () {
                            if (feature.id == 'free') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const FreeDhikrScreen(),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AdhkarListScreen(
                                    categoryId: feature.id,
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FeatureItem {
  final String id;
  final String title;
  final IconData icon;

  const _FeatureItem({
    required this.id,
    required this.title,
    required this.icon,
  });
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final double progress;
  final bool isCompleted;
  final bool isFreeMode;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.icon,
    required this.progress,
    required this.isCompleted,
    required this.isFreeMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isCompleted
                ? AppColors.counterCompleted.withValues(alpha: 0.3)
                : AppColors.divider.withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.brown.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon in a gold circle
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppColors.counterCompleted.withValues(alpha: 0.1)
                    : isFreeMode
                        ? AppColors.gold.withValues(alpha: 0.15)
                        : AppColors.gold.withValues(alpha: 0.08),
                border: Border.all(
                  color: isCompleted
                      ? AppColors.counterCompleted.withValues(alpha: 0.3)
                      : AppColors.gold.withValues(alpha: 0.25),
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
            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
            ),
            // Mini progress bar (not for free mode)
            if (!isFreeMode && progress > 0) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 3,
                    backgroundColor: AppColors.beigeDark,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted
                          ? AppColors.counterCompleted
                          : AppColors.gold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
