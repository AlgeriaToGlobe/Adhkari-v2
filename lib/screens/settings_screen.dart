import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.beigeLight,
        appBar: AppBar(
          title: const Text('الإعدادات'),
          backgroundColor: AppColors.brown,
          foregroundColor: AppColors.white,
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'التنبيهات',
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            _NotificationTile(
              title: 'تذكير أذكار الصباح',
              subtitle: _morningEnabled
                  ? 'مفعّل — ${_formatTime(_morningTime)}'
                  : 'غير مفعّل',
              icon: Icons.wb_sunny_outlined,
              isEnabled: _morningEnabled,
              onToggle: (value) async {
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
              onTimeTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _morningTime,
                  builder: (context, child) {
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() => _morningTime = picked);
                  if (_morningEnabled) {
                    await NotificationService.scheduleMorningReminder(
                      hour: picked.hour,
                      minute: picked.minute,
                    );
                  }
                }
              },
            ),

            const SizedBox(height: 8),

            _NotificationTile(
              title: 'تذكير أذكار المساء',
              subtitle: _eveningEnabled
                  ? 'مفعّل — ${_formatTime(_eveningTime)}'
                  : 'غير مفعّل',
              icon: Icons.nightlight_outlined,
              isEnabled: _eveningEnabled,
              onToggle: (value) async {
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
              onTimeTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _eveningTime,
                  builder: (context, child) {
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() => _eveningTime = picked);
                  if (_eveningEnabled) {
                    await NotificationService.scheduleEveningReminder(
                      hour: picked.hour,
                      minute: picked.minute,
                    );
                  }
                }
              },
            ),

            const SizedBox(height: 24),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'عن التطبيق',
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أذكاري',
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'الإصدار ١.٠.٠',
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'تطبيق لقراءة الأذكار والأدعية اليومية مع عدادات رقمية وتنبيهات للمحافظة على الورد اليومي.',
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTimeTap;

  const _NotificationTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isEnabled,
    required this.onToggle,
    required this.onTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.gold, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: isEnabled ? onTimeTap : null,
                  child: Text(
                    subtitle,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 13,
                      color: isEnabled
                          ? AppColors.gold
                          : AppColors.textSecondary,
                      decoration:
                          isEnabled ? TextDecoration.underline : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: onToggle,
            activeColor: AppColors.gold,
          ),
        ],
      ),
    );
  }
}
