import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';

// Blocs
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../menu/presentation/bloc/category/category_bloc.dart';
import '../../../menu/presentation/bloc/category/category_event.dart';
import '../../../menu/presentation/bloc/product/product_bloc.dart';
import '../../../menu/presentation/bloc/product/product_event.dart';
import '../../../shift/presentation/bloc/shift_bloc.dart';
import '../../../shift/presentation/bloc/shift_event.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/checkout/checkout_bloc.dart';

// Widgets
import '../widgets/categories_filter_widget.dart';
import '../widgets/products_grid_widget.dart';
import '../widgets/cart_widget.dart';

class PosScreen extends StatelessWidget {
  const PosScreen({super.key});

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تبديل المستخدم / تسجيل الخروج'),
        content: const Text('هل أنت متأكد من رغبتك في قفل الشاشة وتسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthBloc>().add(LogoutEvent());
              context.go('/login');
            },
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthBloc>()),
        BlocProvider(create: (context) => sl<CategoryBloc>()),
        BlocProvider(create: (context) => sl<ProductBloc>()),
        BlocProvider(create: (context) => sl<CartBloc>()),
        BlocProvider(create: (context) => sl<CheckoutBloc>()),
        BlocProvider(create: (context) => sl<ShiftBloc>()..add(CheckActiveShiftEvent())),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              elevation: 2,
              backgroundColor: const Color(0xFF1E88E5),
              title: const Text('نقطة البيع - POS Lite', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              actions: [
                // زر إدارة المنيو
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  tooltip: 'إدارة المنيو والنظام',
                  onPressed: () async {
                    await context.push('/menu');
                    if (context.mounted) {
                      context.read<CategoryBloc>().add(GetCategoriesEvent());
                      context.read<ProductBloc>().add(const GetProductsEvent(categoryId: null));
                    }
                  },
                ),
                const SizedBox(width: 8),
                // زر تسجيل الخروج وتبديل الوردية
                IconButton(
                  icon: const Icon(Icons.lock_person, color: Colors.white),
                  tooltip: 'قفل الشاشة / تسجيل خروج الكاشير',
                  onPressed: () => _confirmLogout(context),
                ),
                const SizedBox(width: 16),
              ],
            ),
            body: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    children: const [
                      CategoriesFilterWidget(),
                      Divider(height: 1),
                      Expanded(child: ProductsGridWidget()),
                    ],
                  ),
                ),
                const VerticalDivider(width: 1, thickness: 1, color: Colors.grey),
                const Expanded(
                  flex: 4,
                  child: CartWidget(),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}