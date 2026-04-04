import 'package:flutter/material.dart';

class AppTheme {
  // 1. الألوان الأساسية (Color Palette)
  static const Color primaryColor = Color(0xFF1E88E5); // أزرق احترافي ومريح للعين
  static const Color secondaryColor = Color(0xFF005CB2); // أزرق داكن للتباين
  static const Color backgroundColor = Color(0xFFF5F7FA); // رمادي فاتح جداً للخلفيات
  static const Color surfaceColor = Colors.white; // أبيض نقي للكروت والنوافذ
  static const Color errorColor = Color(0xFFE53935); // أحمر للأخطاء والحذف
  static const Color successColor = Color(0xFF43A047); // أخضر للنجاح والإضافة
  static const Color warningColor = Color(0xFFFB8C00); // برتقالي للتنبيهات

  // 2. الثيم الشامل (Light Theme)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Cairo', // يفضل إضافة خط عربي جميل لاحقاً مثل Cairo أو Tajawal
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundColor,

      // تصميم شريط العناوين (AppBar)
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      // تصميم الأزرار المرتفعة (Elevated Buttons)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // حواف ناعمة
          ),
          elevation: 2,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      // تصميم حقول الإدخال (Text Fields)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1.5),
        ),
      ),

      // تصميم الكروت (Cards)
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2, // ظل خفيف جداً
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),

      // تصميم النوافذ المنبثقة (Dialogs)
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent, // لمنع تغيير اللون الافتراضي في Material 3
      ),

      // تصميم التبويبات (Tabs)
      tabBarTheme: const TabBarThemeData(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: Colors.white, width: 3),
        ),
      ),
    );
  }
}