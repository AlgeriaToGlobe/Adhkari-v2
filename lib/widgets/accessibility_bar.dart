import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';

/// A compact accessibility toolbar for adhkar reading pages.
/// Provides font size controls and dark/light mode toggle.
class AccessibilityBar extends StatelessWidget {
  const AccessibilityBar({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.isDark(context);

    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: dark ? AppColors.darkSurface : AppColors.beige,
            border: Border(
              bottom: BorderSide(
                color: AppColors.dividerC(context),
                width: 0.5,
              ),
            ),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                // ── Font size section ──
                Icon(
                  Icons.format_size_rounded,
                  size: 18,
                  color: AppColors.textS(context),
                ),
                const SizedBox(width: 10),

                // Increase button
                _ControlButton(
                  onTap: settings.canIncrease
                      ? () => settings.increaseFontSize()
                      : null,
                  dark: dark,
                  child: Text(
                    'أ+',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: settings.canIncrease
                          ? AppColors.gold
                          : AppColors.dividerC(context),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Current size label pill
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    settings.fontSizeLabel,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.gold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Decrease button
                _ControlButton(
                  onTap: settings.canDecrease
                      ? () => settings.decreaseFontSize()
                      : null,
                  dark: dark,
                  child: Text(
                    'أ-',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: settings.canDecrease
                          ? AppColors.gold
                          : AppColors.dividerC(context),
                    ),
                  ),
                ),

                const Spacer(),

                // ── Vertical divider ──
                Container(
                  width: 1,
                  height: 28,
                  color: AppColors.dividerC(context),
                ),
                const SizedBox(width: 14),

                // ── Dark mode toggle ──
                GestureDetector(
                  onTap: () => settings.toggleDarkMode(),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: dark
                          ? AppColors.gold.withValues(alpha: 0.12)
                          : AppColors.brown.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          dark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          size: 20,
                          color: dark ? AppColors.gold : AppColors.brown,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          dark ? 'فاتح' : 'داكن',
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: dark ? AppColors.gold : AppColors.brown,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ControlButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool dark;

  const _ControlButton({
    required this.child,
    this.onTap,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: dark ? AppColors.darkCard : AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: dark ? AppColors.darkDivider : AppColors.divider,
          ),
        ),
        child: child,
      ),
    );
  }
}
