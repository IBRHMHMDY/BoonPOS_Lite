import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';

// Blocs الاستيرادات
import '../../../menu/presentation/bloc/category/category_bloc.dart';
import '../../../menu/presentation/bloc/product/product_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/checkout/checkout_bloc.dart';
import '../../../shift/presentation/bloc/shift_bloc.dart';
import '../../../shift/presentation/bloc/shift_event.dart';

// Widgets الاستيرادات
import '../widgets/categories_filter_widget.dart';
import '../widgets/products_grid_widget.dart';

class PosScreen extends StatelessWidget {
  const PosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ضخ كل الـ Blocs اللازمة لشاشة نقطة البيع لتعمل باستقلالية
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<CategoryBloc>()),
        BlocProvider(create: (context) => sl<ProductBloc>()),
        BlocProvider(create: (context) => sl<CartBloc>()),
        BlocProvider(create: (context) => sl<CheckoutBloc>()),
        // نحتاج ShiftBloc لمعرفة رقم الوردية الحالية للـ Checkout
        BlocProvider(create: (context) => sl<ShiftBloc>()..add(CheckActiveShiftEvent())),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text('نقطة البيع - POS Lite', style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            // زر للذهاب إلى لوحة إدارة المنيو (يجب أن يكون للمدير فقط لاحقاً)
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'إدارة المنيو والنظام',
              onPressed: () => context.push('/menu'),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: Row(
          children: [
            // الجانب الأيمن (60%) - المنتجات والتصنيفات
            Expanded(
              flex: 6,
              child: Column(
                children: const [
                  // شريط التصنيفات
                  CategoriesFilterWidget(),
                  Divider(height: 1),
                  // شبكة المنتجات
                  Expanded(
                    child: ProductsGridWidget(),
                  ),
                ],
              ),
            ),

            // فاصل رأسي بين القسمين
            const VerticalDivider(width: 1, thickness: 1, color: Colors.grey),

            // الجانب الأيسر (40%) - السلة والدفع (سيبنى في الخطوة القادمة)
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.white,
                child: const Center(
                  child: Text(
                    'جاري بناء سلة المشتريات...',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}