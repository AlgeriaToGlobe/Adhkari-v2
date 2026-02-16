import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/adhkar_provider.dart';
import '../models/dhikr.dart';
import '../theme/app_colors.dart';

class FreeDhikrScreen extends StatelessWidget {
  const FreeDhikrScreen({super.key});

  void _showAddDialog(BuildContext context) {
    final textController = TextEditingController();
    final countController = TextEditingController(text: '100');

    showDialog(
      context: context,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: AppColors.cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'إضافة ذكر جديد',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textController,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'نص الذكر',
                    hintStyle: TextStyle(
                      fontFamily: 'Amiri',
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                    filled: true,
                    fillColor: AppColors.beigeLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.gold),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: countController,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'عدد مرات التكرار',
                    hintStyle: TextStyle(
                      fontFamily: 'Amiri',
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                    filled: true,
                    fillColor: AppColors.beigeLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.gold),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  final text = textController.text.trim();
                  final countText = countController.text.trim();
                  if (text.isNotEmpty && countText.isNotEmpty) {
                    final count = int.tryParse(countText);
                    if (count != null && count > 0) {
                      context
                          .read<AdhkarProvider>()
                          .addFreeDhikrItem(text, count);
                      Navigator.pop(ctx);
                    }
                  }
                },
                child: const Text(
                  'إضافة',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    color: AppColors.gold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmDialog(
      BuildContext context, AdhkarProvider provider, String itemId) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: AppColors.cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'حذف الذكر',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            content: const Text(
              'هل تريد حذف هذا الذكر؟',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  provider.removeFreeDhikrItem(itemId);
                  Navigator.pop(ctx);
                },
                child: const Text(
                  'حذف',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.beigeLight,
        body: SafeArea(
          child: Consumer<AdhkarProvider>(
            builder: (context, provider, _) {
              final items = provider.freeDhikrItems;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Title section ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'الذكر الحر',
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'أضف أذكارك الخاصة',
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Add button ──
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Material(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () => _showAddDialog(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.add_circle_outline,
                                color: AppColors.brownDark,
                                size: 22,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'إضافة ذكر جديد',
                                style: TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.brownDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // ── List or empty state ──
                  Expanded(
                    child: items.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return _buildDhikrCard(
                                  context, provider, item);
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.edit_note,
            size: 64,
            color: AppColors.gold.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد أذكار مضافة',
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'اضغط الزر أعلاه لإضافة ذكر جديد',
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDhikrCard(
      BuildContext context, AdhkarProvider provider, FreeDhikrItem item) {
    final progressColor =
        item.isCompleted ? AppColors.counterCompleted : AppColors.gold;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.brown.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            // ── Right side: circular progress indicator (tappable) ──
            GestureDetector(
              onTap: () => provider.incrementFreeDhikrItem(item.id),
              child: SizedBox(
                width: 56,
                height: 56,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: CircularProgressIndicator(
                        value: item.progress,
                        strokeWidth: 4,
                        backgroundColor: AppColors.counterBackground,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(progressColor),
                      ),
                    ),
                    Text(
                      '${item.currentCount}/${item.targetCount}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: progressColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),

            // ── Center: text and count info ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.text,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.currentCount} من ${item.targetCount}',
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // ── Left side: popup menu ──
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                color: AppColors.textSecondary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: AppColors.cardBackground,
              onSelected: (value) {
                if (value == 'reset') {
                  provider.resetFreeDhikrItem(item.id);
                } else if (value == 'delete') {
                  _showDeleteConfirmDialog(context, provider, item.id);
                }
              },
              itemBuilder: (ctx) => [
                PopupMenuItem<String>(
                  value: 'reset',
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      children: const [
                        Icon(Icons.refresh, size: 20, color: AppColors.gold),
                        SizedBox(width: 8),
                        Text(
                          'إعادة العداد',
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      children: const [
                        Icon(Icons.delete_outline,
                            size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'حذف',
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            color: Colors.red,
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
      ),
    );
  }
}
