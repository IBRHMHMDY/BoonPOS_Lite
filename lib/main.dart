import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/di/service_locator.dart' as di;
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  // التأكد من تهيئة بيئة فلاتر قبل تشغيل أي أكواد أخرى
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة حقن التبعيات (Service Locator)
  await di.init();

  runApp(const PosApp());
}

class PosApp extends StatelessWidget {
  const PosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'POS Lite System',
      debugShowCheckedModeBanner: false,
      
      // 1. تطبيق نظام التصميم الموحد (Theme) هنا
      theme: AppTheme.lightTheme,
      
      // 2. إعدادات اللغة (التوجيه من اليمين لليسار RTL)
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'EG'), // اللغة العربية (مصر)
      ],
      locale: const Locale('ar', 'EG'),

      // 3. ربط نظام التوجيه (Router)
      routerConfig: appRouter,
    );
  }
}