import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/adhkar_provider.dart';
import '../theme/app_colors.dart';

class FreeDhikrScreen extends StatefulWidget {
  const FreeDhikrScreen({super.key});

  @override
  State<FreeDhikrScreen> createState() => _FreeDhikrScreenState();
}

class _FreeDhikrScreenState extends State<FreeDhikrScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final TextEditingController _labelController = TextEditingController();

  final List<String> _presetDhikr = [
    'سبحان الله',
    'الحمد لله',
    'الله أكبر',
    'لا إله إلا الله',
    'أستغفر الله',
    'لا حول ولا قوة إلا بالله',
    'سبحان الله وبحمده',
    'سبحان الله العظيم',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  void _onCounterTap(AdhkarProvider provider) {
    _pulseController.forward().then((_) => _pulseController.reverse());
    provider.incrementFreeDhikr();
  }

  void _showLabelPicker(BuildContext context, AdhkarProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.beigeLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'اختر الذكر',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: _presetDhikr.map((dhikr) {
                    final isSelected = dhikr == provider.freeDhikrLabel;
                    return GestureDetector(
                      onTap: () {
                        provider.setFreeDhikrLabel(dhikr);
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.gold
                              : AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.gold
                                : AppColors.divider,
                          ),
                        ),
                        child: Text(
                          dhikr,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? AppColors.brownDark
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                // Custom input
                TextField(
                  controller: _labelController,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'أو اكتب ذكرًا مخصصًا...',
                    hintTextDirection: TextDirection.rtl,
                    hintStyle: TextStyle(
                      fontFamily: 'Amiri',
                      color: AppColors.brownLight.withValues(alpha: 0.5),
                    ),
                    filled: true,
                    fillColor: AppColors.cardBackground,
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
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.check, color: AppColors.gold),
                      onPressed: () {
                        if (_labelController.text.trim().isNotEmpty) {
                          provider
                              .setFreeDhikrLabel(_labelController.text.trim());
                          _labelController.clear();
                          Navigator.pop(ctx);
                        }
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      provider.setFreeDhikrLabel(value.trim());
                      _labelController.clear();
                      Navigator.pop(ctx);
                    }
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
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
        appBar: AppBar(
          title: const Text('التسبيح الحر'),
          backgroundColor: AppColors.brown,
          foregroundColor: AppColors.white,
          centerTitle: true,
        ),
        body: Consumer<AdhkarProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                const Spacer(flex: 1),

                // Current dhikr label
                GestureDetector(
                  onTap: () => _showLabelPicker(context, provider),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          provider.freeDhikrLabel,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.brown,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.edit,
                          size: 18,
                          color: AppColors.gold.withValues(alpha: 0.6),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                // Counter display
                Text(
                  '${provider.freeDhikrCount}',
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 72,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brown,
                    height: 1.0,
                  ),
                ),

                const SizedBox(height: 8),
                Text(
                  'مرة',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 18,
                    color: AppColors.brownLight.withValues(alpha: 0.7),
                  ),
                ),

                const Spacer(flex: 1),

                // Big counter button
                GestureDetector(
                  onTap: () => _onCounterTap(provider),
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.gold, AppColors.goldDark],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold.withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.touch_app,
                          size: 56,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                // Reset button
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => Directionality(
                        textDirection: TextDirection.rtl,
                        child: AlertDialog(
                          title: const Text(
                            'إعادة العداد',
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                          content: const Text(
                            'هل تريد إعادة العداد إلى صفر؟',
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
                                provider.resetFreeDhikr();
                                Navigator.pop(ctx);
                              },
                              child: const Text('إعادة'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.refresh,
                    color: AppColors.brownLight,
                  ),
                  label: const Text(
                    'إعادة العداد',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      color: AppColors.brownLight,
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
    );
  }
}
