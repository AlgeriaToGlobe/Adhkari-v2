import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/adhkar_provider.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';
import 'screens/splash_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.beigeLight,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await NotificationService.initialize();

  runApp(const AdhkariApp());
}

class AdhkariApp extends StatelessWidget {
  const AdhkariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdhkarProvider(),
      child: MaterialApp(
        title: 'أذكاري',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home: const SplashScreen(),
      ),
    );
  }
}
