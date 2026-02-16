import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';

/// A minimal accessibility toolbar for adhkar reading pages.
/// Icons only: أ+ / أ- for font size, moon/sun for dark mode.
class AccessibilityBar extends StatelessWidget {
  const AccessibilityBar({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.isDark(context);

    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Font increase ──
                _IconBtn(
                  onTap: settings.canIncrease
                      ? () => settings.increaseFontSize()
                      : null,
                  dark: dark,
                  enabled: settings.canIncrease,
                  child: const Text(
                    'أ+',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // ── Font decrease ──
                _IconBtn(
                  onTap: settings.canDecrease
                      ? () => settings.decreaseFontSize()
                      : null,
                  dark: dark,
                  enabled: settings.canDecrease,
                  child: const Text(
                    'أ-',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // ── Vertical divider ──
                Container(
                  width: 1,
                  height: 24,
                  color: AppColors.dividerC(context),
                ),

                const SizedBox(width: 20),

                // ── Dark mode toggle (icon only) ──
                _IconBtn(
                  onTap: () => settings.toggleDarkMode(),
                  dark: dark,
                  enabled: true,
                  child: Icon(
                    dark
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    size: 20,
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

class _IconBtn extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool dark;
  final bool enabled;

  const _IconBtn({
    required this.child,
    this.onTap,
    required this.dark,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final color = enabled ? AppColors.gold : AppColors.dividerC(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: dark ? AppColors.darkCard : AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled
                ? AppColors.gold.withValues(alpha: 0.4)
                : (dark ? AppColors.darkDivider : AppColors.divider),
          ),
        ),
        child: IconTheme(
          data: IconThemeData(color: color),
          child: DefaultTextStyle(
            style: TextStyle(color: color),
            child: child,
          ),
        ),
      ),
    );
  }
}
