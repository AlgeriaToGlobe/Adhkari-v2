import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    // Navigate after delay
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const MainShell(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beigeLight,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Arch with mosque icon
              SizedBox(
                width: 180,
                height: 200,
                child: CustomPaint(
                  painter: _SplashArchPainter(),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ── PLACEHOLDER: App logo / Mosque silhouette ──
                          // Replace with your custom app icon
                          // Dimensions: 80x80 px, PNG transparent
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.brown.withValues(alpha: 0.08),
                              border: Border.all(
                                color: AppColors.gold.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.mosque_outlined,
                              size: 36,
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // App name
              const Text(
                'أذكاري',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  color: AppColors.brown,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'حصّن يومك بذكر الله',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 16,
                  color: AppColors.brownLight.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashArchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Outer arch
    final outerPaint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final outerPath = Path();
    outerPath.moveTo(0, h);
    outerPath.lineTo(0, h * 0.4);
    outerPath.quadraticBezierTo(0, h * 0.08, w * 0.25, h * 0.05);
    outerPath.quadraticBezierTo(w * 0.45, 0, w * 0.5, 0);
    outerPath.quadraticBezierTo(w * 0.55, 0, w * 0.75, h * 0.05);
    outerPath.quadraticBezierTo(w, h * 0.08, w, h * 0.4);
    outerPath.lineTo(w, h);
    canvas.drawPath(outerPath, outerPaint);

    // Inner arch
    final innerPaint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final inset = 10.0;
    final innerPath = Path();
    innerPath.moveTo(inset, h);
    innerPath.lineTo(inset, h * 0.42);
    innerPath.quadraticBezierTo(
        inset, h * 0.12, w * 0.27, h * 0.09);
    innerPath.quadraticBezierTo(w * 0.46, h * 0.03, w * 0.5, h * 0.03);
    innerPath.quadraticBezierTo(
        w * 0.54, h * 0.03, w * 0.73, h * 0.09);
    innerPath.quadraticBezierTo(
        w - inset, h * 0.12, w - inset, h * 0.42);
    innerPath.lineTo(w - inset, h);
    canvas.drawPath(innerPath, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
