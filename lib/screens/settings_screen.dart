import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/adhkar_provider.dart';
import '../providers/settings_provider.dart';
import '../services/notification_service.dart';
import '../theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _morningEnabled = false;
  bool _eveningEnabled = false;
  TimeOfDay _morningTime = const TimeOfDay(hour: 5, minute: 30);
  TimeOfDay _eveningTime = const TimeOfDay(hour: 16, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final morningEnabled = await NotificationService.isMorningEnabled();
    final eveningEnabled = await NotificationService.isEveningEnabled();
    final morningTime = await NotificationService.getMorningTime();
    final eveningTime = await NotificationService.getEveningTime();

    if (!mounted) return;
    setState(() {
      _morningEnabled = morningEnabled;
      _eveningEnabled = eveningEnabled;
      _morningTime = TimeOfDay(
        hour: morningTime['hour']!,
        minute: morningTime['minute']!,
      );
      _eveningTime = TimeOfDay(
        hour: eveningTime['hour']!,
        minute: eveningTime['minute']!,
      );
    });
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'ص' : 'م';
    return '$hour:$minute $period';
  }

  TimePickerThemeData _buildTimePickerTheme(BuildContext context) {
    final accentGold = AppColors.goldC(context);
    return TimePickerThemeData(
      backgroundColor: AppColors.card(context),
      hourMinuteColor: accentGold.withValues(alpha: 0.1),
      hourMinuteTextColor: AppColors.textP(context),
      dialHandColor: accentGold,
      dialBackgroundColor: AppColors.surface(context),
      dialTextColor: AppColors.textP(context),
      dayPeriodColor: accentGold.withValues(alpha: 0.1),
      dayPeriodTextColor: AppColors.textP(context),
      entryModeIconColor: accentGold,
      helpTextStyle: TextStyle(
        fontFamily: 'Amiri',
        fontSize: 14,
        color: AppColors.textS(context),
      ),
      hourMinuteTextStyle: const TextStyle(
        fontFamily: 'Amiri',
        fontSize: 40,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Future<void> _pickMorningTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _morningTime,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: _buildTimePickerTheme(context),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.goldC(context),
                  textStyle: const TextStyle(fontFamily: 'Amiri', fontSize: 15),
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (picked != null && mounted) {
      setState(() => _morningTime = picked);
      if (_morningEnabled) {
        await NotificationService.scheduleMorningReminder(
          hour: picked.hour,
          minute: picked.minute,
        );
      }
    }
  }

  Future<void> _pickEveningTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _eveningTime,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: _buildTimePickerTheme(context),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.goldC(context),
                  textStyle: const TextStyle(fontFamily: 'Amiri', fontSize: 15),
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (picked != null && mounted) {
      setState(() => _eveningTime = picked);
      if (_eveningEnabled) {
        await NotificationService.scheduleEveningReminder(
          hour: picked.hour,
          minute: picked.minute,
        );
      }
    }
  }

  Future<void> _showResetConfirmation(BuildContext context) async {
    final provider = context.read<AdhkarProvider>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: AppColors.card(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'إعادة جميع العدادات',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textP(context),
              ),
            ),
            content: Text(
              'هل أنت متأكد من إعادة جميع العدادات إلى الصفر؟ لا يمكن التراجع عن هذا الإجراء.',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 15,
                color: AppColors.textS(context),
                height: 1.7,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'إلغاء',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 15,
                    color: AppColors.textS(context),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'إعادة',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 15,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (confirmed == true && mounted) {
      await provider.resetAllProgress();
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8, right: 4),
      child: Text(
        title,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontFamily: 'Amiri',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.goldC(context),
        ),
      ),
    );
  }

  Widget _buildSectionContainer({required Widget child}) {
    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.dividerC(context)),
        ),
        child: child,
      ),
    );
  }

  Widget _buildToggleRow({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    VoidCallback? onSubtitleTap,
  }) {
    final accentGold = AppColors.goldC(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accentGold.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentGold, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textP(context),
                  ),
                ),
                if (subtitle != null)
                  GestureDetector(
                    onTap: value ? onSubtitleTap : null,
                    child: Text(
                      subtitle,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 13,
                        color:
                            value ? accentGold : AppColors.textS(context),
                        decoration:
                            value ? TextDecoration.underline : null,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: accentGold,
            activeTrackColor: accentGold.withValues(alpha: 0.5),
            inactiveTrackColor: AppColors.isDark(context)
                ? const Color(0xFF4A4A4A)
                : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdhkarProvider>();
    final settings = context.watch<SettingsProvider>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffold(context),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              // ── Title ──
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'الإعدادات',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textP(context),
                  ),
                ),
              ),

              // ── Section: المظهر (Appearance) ──
              _buildSectionHeader('المظهر'),
              _buildSectionContainer(
                child: Column(
                  children: [
                    // Dark mode toggle
                    _buildToggleRow(
                      icon: settings.isDarkMode
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      title: 'الوضع الداكن',
                      subtitle: settings.isDarkMode ? 'مفعّل' : 'غير مفعّل',
                      value: settings.isDarkMode,
                      onChanged: (value) => settings.setDarkMode(value),
                    ),
                    Divider(
                      color: AppColors.dividerC(context),
                      height: 1,
                      indent: 60,
                    ),
                    // Font size selector
                    Builder(
                      builder: (context) {
                        final accentGold = AppColors.goldC(context);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color:
                                      accentGold.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.format_size_rounded,
                                  color: accentGold,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'حجم الخط',
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        fontFamily: 'Amiri',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textP(context),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      children: List.generate(
                                        SettingsProvider.fontScales.length,
                                        (index) {
                                          final isSelected =
                                              settings.fontSizeIndex == index;
                                          return Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: index <
                                                        SettingsProvider
                                                                .fontScales
                                                                .length -
                                                            1
                                                    ? 6
                                                    : 0,
                                              ),
                                              child: GestureDetector(
                                                onTap: () =>
                                                    settings.setFontSizeScale(
                                                  SettingsProvider
                                                      .fontScales[index],
                                                ),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: isSelected
                                                        ? accentGold
                                                        : accentGold
                                                            .withValues(
                                                                alpha: 0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(8),
                                                    border: Border.all(
                                                      color: isSelected
                                                          ? accentGold
                                                          : accentGold
                                                              .withValues(
                                                                  alpha: 0.3),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      SettingsProvider
                                                          .fontScaleLabels[index],
                                                      style: TextStyle(
                                                        fontFamily: 'Amiri',
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: isSelected
                                                            ? AppColors.isDark(context)
                                                                ? AppColors.darkBg
                                                                : AppColors.white
                                                            : accentGold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // ── Section 1: التنبيهات ──
              _buildSectionHeader('التنبيهات'),
              _buildSectionContainer(
                child: Column(
                  children: [
                    _buildToggleRow(
                      icon: Icons.wb_sunny_outlined,
                      title: 'تذكير أذكار الصباح',
                      subtitle: _morningEnabled
                          ? 'مفعّل — ${_formatTime(_morningTime)}'
                          : 'غير مفعّل',
                      value: _morningEnabled,
                      onChanged: (value) async {
                        setState(() => _morningEnabled = value);
                        if (value) {
                          await NotificationService.scheduleMorningReminder(
                            hour: _morningTime.hour,
                            minute: _morningTime.minute,
                          );
                        } else {
                          await NotificationService.cancelMorningReminder();
                        }
                      },
                      onSubtitleTap: _pickMorningTime,
                    ),
                    Divider(
                      color: AppColors.dividerC(context),
                      height: 1,
                      indent: 60,
                    ),
                    _buildToggleRow(
                      icon: Icons.nightlight_outlined,
                      title: 'تذكير أذكار المساء',
                      subtitle: _eveningEnabled
                          ? 'مفعّل — ${_formatTime(_eveningTime)}'
                          : 'غير مفعّل',
                      value: _eveningEnabled,
                      onChanged: (value) async {
                        setState(() => _eveningEnabled = value);
                        if (value) {
                          await NotificationService.scheduleEveningReminder(
                            hour: _eveningTime.hour,
                            minute: _eveningTime.minute,
                          );
                        } else {
                          await NotificationService.cancelEveningReminder();
                        }
                      },
                      onSubtitleTap: _pickEveningTime,
                    ),
                  ],
                ),
              ),

              // ── Section 2: العداد ──
              _buildSectionHeader('العداد'),
              _buildSectionContainer(
                child: _buildToggleRow(
                  icon: Icons.vibration,
                  title: 'اهتزاز عند الضغط',
                  value: provider.vibrationEnabled,
                  onChanged: (value) {
                    provider.setVibrationEnabled(value);
                  },
                ),
              ),

              // ── Section 3: البيانات ──
              _buildSectionHeader('البيانات'),
              _buildSectionContainer(
                child: ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.restart_alt,
                      color: Colors.red,
                      size: 22,
                    ),
                  ),
                  title: const Text(
                    'إعادة جميع العدادات',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  subtitle: Text(
                    'إعادة جميع العدادات والتسبيح إلى الصفر',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 13,
                      color: AppColors.textS(context),
                    ),
                  ),
                  onTap: () => _showResetConfirmation(context),
                ),
              ),

              // ── Section 4: حول التطبيق ──
              _buildSectionHeader('حول التطبيق'),
              _buildSectionContainer(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'أذكاري',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textP(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'الإصدار ١.٠.٠',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 14,
                          color: AppColors.textS(context),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'تطبيق لقراءة الأذكار والأدعية اليومية مع عدادات رقمية وتنبيهات للمحافظة على الورد اليومي.',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 15,
                          color: AppColors.textS(context),
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
