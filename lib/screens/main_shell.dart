import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/geometric_bg.dart';
import 'home_screen.dart';
import 'taqwim_screen.dart';
import 'adhkar_tab_screen.dart';
import 'free_dhikr_screen.dart';
import 'settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    TaqwimScreen(),
    AdhkarTabScreen(),
    FreeDhikrScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.isDark(context);
    final accentGold = AppColors.goldC(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffold(context),
        body: GeometricBg(
          child: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.card(context),
            border: Border(
              top: BorderSide(
                color: AppColors.dividerC(context),
                width: 0.5,
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.card(context),
            selectedItemColor: accentGold,
            unselectedItemColor: AppColors.brownLightC(context),
            selectedFontSize: 12,
            unselectedFontSize: 11,
            selectedLabelStyle: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
            elevation: 0,
            items: [
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'الرئيسية',
                isActive: _currentIndex == 0,
                accentGold: accentGold,
              ),
              _buildNavItem(
                icon: Icons.calendar_month_outlined,
                activeIcon: Icons.calendar_month,
                label: 'التقويم',
                isActive: _currentIndex == 1,
                accentGold: accentGold,
              ),
              _buildNavItem(
                icon: Icons.menu_book_outlined,
                activeIcon: Icons.menu_book,
                label: 'الأذكار',
                isActive: _currentIndex == 2,
                accentGold: accentGold,
              ),
              _buildNavItem(
                icon: Icons.edit_note_outlined,
                activeIcon: Icons.edit_note,
                label: 'الذكر الحر',
                isActive: _currentIndex == 3,
                accentGold: accentGold,
              ),
              _buildNavItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: 'الإعدادات',
                isActive: _currentIndex == 4,
                accentGold: accentGold,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
    required Color accentGold,
  }) {
    final dark = AppColors.isDark(context);

    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 2),
        ],
      ),
      activeIcon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // In dark mode, wrap active icon with a gold glow
          if (dark)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: accentGold.withValues(alpha: 0.35),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(activeIcon, size: 26),
            )
          else
            Icon(activeIcon, size: 26),
          const SizedBox(height: 2),
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentGold,
              boxShadow: dark
                  ? [
                      BoxShadow(
                        color: accentGold.withValues(alpha: 0.5),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
          ),
        ],
      ),
      label: label,
    );
  }
}
