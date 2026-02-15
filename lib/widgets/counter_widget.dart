import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CounterWidget extends StatefulWidget {
  final int currentCount;
  final int targetCount;
  final VoidCallback onTap;
  final bool isCompleted;

  const CounterWidget({
    super.key,
    required this.currentCount,
    required this.targetCount,
    required this.onTap,
    required this.isCompleted,
  });

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isCompleted) {
      _controller.forward().then((_) => _controller.reverse());
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.targetCount > 0
        ? (widget.currentCount / widget.targetCount).clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.isCompleted
                ? AppColors.counterCompleted
                : AppColors.counterBackground,
            border: Border.all(
              color: widget.isCompleted
                  ? AppColors.counterCompleted
                  : AppColors.gold,
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: (widget.isCompleted
                        ? AppColors.counterCompleted
                        : AppColors.gold)
                    .withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Progress ring
              SizedBox(
                width: 66,
                height: 66,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.isCompleted
                        ? AppColors.white
                        : AppColors.gold,
                  ),
                ),
              ),
              // Counter text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.isCompleted)
                    const Icon(
                      Icons.check,
                      color: AppColors.white,
                      size: 28,
                    )
                  else ...[
                    Text(
                      '${widget.currentCount}',
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brown,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      '/${widget.targetCount}',
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 11,
                        color: AppColors.brown.withValues(alpha: 0.6),
                        height: 1.0,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
