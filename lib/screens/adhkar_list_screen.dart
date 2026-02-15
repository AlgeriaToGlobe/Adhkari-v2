import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/adhkar_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/dhikr_card.dart';
import '../widgets/ornament_placeholder.dart';
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
            appBar: AppBar(
              title: Text(category.title),
              backgroundColor: AppColors.brown,
              foregroundColor: AppColors.white,
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'إعادة العدادات',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => Directionality(
                        textDirection: TextDirection.rtl,
                        child: AlertDialog(
                          title: const Text(
                            'إعادة العدادات',
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                          content: const Text(
                            'هل تريد إعادة جميع العدادات في هذا القسم؟',
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('إلغاء'),
                            ),
                            TextButton(
                              onPressed: () {
                                provider.resetCategory(categoryId);
                                Navigator.pop(ctx);
                              },
                              child: const Text('إعادة'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                // Progress header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.headerGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brown.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.subtitle,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 14,
                              color: AppColors.white.withValues(alpha: 0.8),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${category.completedCount} من ${category.totalCount} أذكار',
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                      ),
                      // Mini circular progress
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: category.progress,
                              strokeWidth: 4,
                              backgroundColor:
                                  AppColors.white.withValues(alpha: 0.15),
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(
                                AppColors.gold,
                              ),
                              strokeCap: StrokeCap.round,
                            ),
                            Text(
                              '${(category.progress * 100).toInt()}%',
                              style: const TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.gold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Adhkar list
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: category.adhkar.length,
                    separatorBuilder: (_, __) => const Center(
                      child: OrnamentPlaceholder(type: OrnamentType.divider),
                    ),
                    itemBuilder: (context, index) {
                      final dhikr = category.adhkar[index];
                      return DhikrCard(
                        dhikr: dhikr,
                        onCounterTap: () {
                          provider.incrementDhikr(categoryId, dhikr.id);
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
                      );
                    },
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
