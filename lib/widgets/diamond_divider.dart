import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Gold diamond ornament divider — matches the reference design.
class DiamondDivider extends StatelessWidget {
  final Color? color;

  const DiamondDivider({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.goldC(context).withValues(alpha: 0.5);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.only(left: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, c],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Transform.rotate(
            angle: 0.785398,
            child: Container(width: 5, height: 5, color: c),
          ),
          const SizedBox(width: 10),
          Transform.rotate(
            angle: 0.785398,
            child: Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                border: Border.all(color: c, width: 1.5),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Transform.rotate(
            angle: 0.785398,
            child: Container(width: 5, height: 5, color: c),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.only(right: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [c, Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
