import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/adhkar_provider.dart';
import '../theme/app_colors.dart';
import '../utils/page_transitions.dart';
import '../widgets/accessibility_bar.dart';
import 'adhkar_list_screen.dart';

/// The "الأذكار" tab – shows all adhkar categories as a scrollable list.
class AdhkarTabScreen extends StatefulWidget {
  const AdhkarTabScreen({super.key});

  @override
  State<AdhkarTabScreen> createState() => _AdhkarTabScreenState();
}

class _AdhkarTabScreenState extends State<AdhkarTabScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentGold = AppColors.goldC(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffold(context),
        body: SafeArea(
          child: Consumer<AdhkarProvider>(
            builder: (context, provider, _) {
              final allCategories = provider.categories;
              final categories = _searchQuery.isEmpty
                  ? allCategories
                  : allCategories.where((c) {
                      if (c.title.contains(_searchQuery)) return true;
                      return c.adhkar
                          .any((d) => d.text.contains(_searchQuery));
                    }).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Title ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                    child: Text(
                      'الأذكار',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textP(context),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'اختر قسمًا لبدء القراءة',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 14,
                        color: AppColors.textS(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Search bar ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: TextField(
                      controller: _searchController,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 16,
                        color: AppColors.textP(context),
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.card(context),
                        hintText: 'ابحث في الأذكار...',
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 14,
                          color: AppColors.textS(context)
                              .withValues(alpha: 0.5),
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: accentGold.withValues(alpha: 0.5),
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: AppColors.textS(context),
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppColors.radiusS),
                          borderSide: BorderSide(
                            color: AppColors.dividerC(context),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppColors.radiusS),
                          borderSide: BorderSide(
                            color: AppColors.dividerC(context),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppColors.radiusS),
                          borderSide: BorderSide(
                            color: accentGold,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                    ),
                  ),

                  // ── Accessibility bar ──
                  const AccessibilityBar(),

                  const SizedBox(height: 4),

                  // ── Category list ──
                  Expanded(
                    child: categories.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 48,
                                  color: AppColors.textS(context)
                                      .withValues(alpha: 0.3),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'لا توجد نتائج',
                                  style: TextStyle(
                                    fontFamily: 'Amiri',
                                    fontSize: 16,
                                    color: AppColors.textS(context),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              final isCompleted = category.isAllCompleted;
                              final progressPercent =
                                  (category.progress * 100).toInt();

                              return GestureDetector(
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
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.card(context),
                                    borderRadius: BorderRadius.circular(
                                        AppColors.radiusM),
                                    border: Border.all(
                                      color: isCompleted
                                          ? AppColors.counterCompleted
                                              .withValues(alpha: 0.3)
                                          : AppColors.dividerC(context)
                                              .withValues(alpha: 0.5),
                                    ),
                                    boxShadow:
                                        AppColors.cardShadow(context),
                                  ),
                                  child: Row(
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      // Icon
                                      Builder(
                                        builder: (context) {
                                          return Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isCompleted
                                                  ? AppColors
                                                      .counterCompleted
                                                      .withValues(
                                                          alpha: 0.1)
                                                  : accentGold.withValues(
                                                      alpha: 0.1),
                                              border: Border.all(
                                                color: isCompleted
                                                    ? AppColors
                                                        .counterCompleted
                                                        .withValues(
                                                            alpha: 0.3)
                                                    : accentGold.withValues(
                                                        alpha: 0.3),
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Icon(
                                              isCompleted
                                                  ? Icons.check
                                                  : category.icon,
                                              size: 24,
                                              color: isCompleted
                                                  ? AppColors
                                                      .counterCompleted
                                                  : accentGold,
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 14),

                                      // Title + subtitle + progress
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              category.title,
                                              textDirection:
                                                  TextDirection.rtl,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontFamily: 'Amiri',
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.textP(
                                                    context),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${category.completedCount} من ${category.totalCount} ذكر',
                                              textDirection:
                                                  TextDirection.rtl,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontFamily: 'Amiri',
                                                fontSize: 13,
                                                color: AppColors.textS(
                                                    context),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            // Progress bar
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              child:
                                                  LinearProgressIndicator(
                                                value: category.progress,
                                                minHeight: 5,
                                                backgroundColor:
                                                    AppColors.progressBg(
                                                        context),
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  isCompleted
                                                      ? AppColors
                                                          .counterCompleted
                                                      : accentGold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Percentage
                                      Text(
                                        '$progressPercent%',
                                        style: TextStyle(
                                          fontFamily: 'Amiri',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: isCompleted
                                              ? AppColors.counterCompleted
                                              : accentGold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
