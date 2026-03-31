import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/categories_view.dart';
// سنقوم باستدعاء المنتجات والإضافات في الخطوات القادمة
// import '../widgets/products_view.dart';
// import '../widgets/modifiers_view.dart';

class MenuDashboardScreen extends StatelessWidget {
  const MenuDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إدارة المنيو والنظام'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/home'), // العودة لشاشة الـ POS
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.category), text: 'التصنيفات'),
              Tab(icon: Icon(Icons.fastfood), text: 'المنتجات'),
              Tab(icon: Icon(Icons.extension), text: 'الإضافات (Modifiers)'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CategoriesView(),
            Center(child: Text('جاري بناء واجهة المنتجات...')), // مؤقت للخطوة القادمة
            Center(child: Text('جاري بناء واجهة الإضافات...')), // مؤقت للخطوة القادمة
          ],
        ),
      ),
    );
  }
}