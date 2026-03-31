import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1E88E5), // لون أزرق احترافي مريح لعين الكاشير
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF1E88E5),
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      fontFamily: 'Tajawal', // يفضل إضافة الخط لاحقاً في pubspec.yaml
    );
  }
}