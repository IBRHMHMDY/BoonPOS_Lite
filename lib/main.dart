import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/service_locator.dart' as di;
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  // التأكد من تهيئة محرك فلاتر بالكامل
  WidgetsFlutterBinding.ensureInitialized();

  // إجبار التطبيق على العمل في الوضع الأفقي (Landscape) فقط
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // تهيئة حقن التبعيات (GetIt)
  await di.init();

  runApp(const PosLiteApp());
}

class PosLiteApp extends StatelessWidget {
  const PosLiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'POS Lite',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      
      // إعدادات تعدد اللغات والاتجاه (RTL) لدعم اللغة العربية كأولوية
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''), // العربية
        Locale('en', ''), // الإنجليزية
      ],
      locale: const Locale('ar', ''), // إجبار التطبيق على العربية مبدئياً
    );
  }
}