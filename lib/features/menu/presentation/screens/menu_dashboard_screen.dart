import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/product/product_bloc.dart';
// import '../bloc/modifier/modifier_bloc.dart'; // سيتم تفعيله في الخطوة القادمة
import '../widgets/categories_view.dart';
import '../widgets/products_view.dart';
// import '../widgets/modifiers_view.dart'; // سيتم تفعيله في الخطوة القادمة

class MenuDashboardScreen extends StatelessWidget {
  const MenuDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام MultiBlocProvider لتوفير جميع Blocs المنيو للشاشات الفرعية
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<CategoryBloc>()),
        BlocProvider(create: (context) => sl<ProductBloc>()),
        // BlocProvider(create: (context) => sl<ModifierBloc>()), // سيتم تفعيله في الخطوة القادمة
      ],
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('إدارة المنيو والنظام'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/home'),
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
              ProductsView(), // تم التفعيل
              Center(child: Text('جاري بناء واجهة الإضافات...')), // مؤقت للخطوة القادمة
            ],
          ),
        ),
      ),
    );
  }
}