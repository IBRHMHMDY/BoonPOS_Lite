import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/modifier/modifier_bloc.dart';
import '../../../auth/presentation/bloc/user/user_bloc.dart'; // استيراد UserBloc

import '../widgets/categories_view.dart';
import '../widgets/products_view.dart';
import '../widgets/modifiers_view.dart';
import '../../../auth/presentation/widgets/users_view.dart'; // استيراد واجهة المستخدمين

class MenuDashboardScreen extends StatelessWidget {
  const MenuDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<CategoryBloc>()),
        BlocProvider(create: (context) => sl<ProductBloc>()),
        BlocProvider(create: (context) => sl<ModifierBloc>()),
        BlocProvider(create: (context) => sl<UserBloc>()), // حقن بلوك المستخدمين
      ],
      child: DefaultTabController(
        length: 4, // تم زيادة عدد التبويبات إلى 4
        child: Scaffold(
          appBar: AppBar(
            title: const Text('إعدادات النظام والمنيو'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
            ),
            bottom: const TabBar(
              isScrollable: true, // للسماح بالتمرير إذا كانت الشاشة ضيقة
              tabs: [
                Tab(icon: Icon(Icons.category), text: 'التصنيفات'),
                Tab(icon: Icon(Icons.fastfood), text: 'المنتجات'),
                Tab(icon: Icon(Icons.extension), text: 'الإضافات'),
                Tab(icon: Icon(Icons.manage_accounts), text: 'المستخدمين'), // التبويب الجديد
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              CategoriesView(),
              ProductsView(),
              ModifiersView(),
              UsersView(), // واجهة المستخدمين
            ],
          ),
        ),
      ),
    );
  }
}