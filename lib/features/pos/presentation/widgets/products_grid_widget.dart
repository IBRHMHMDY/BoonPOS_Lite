import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../menu/presentation/bloc/modifier/modifier_bloc.dart';
import '../../../menu/presentation/bloc/product/product_bloc.dart';
import '../../../menu/presentation/bloc/product/product_event.dart';
import '../../../menu/presentation/bloc/product/product_state.dart';
import '../bloc/cart/cart_bloc.dart';
import 'product_modifiers_dialog.dart';

class ProductsGridWidget extends StatefulWidget {
  const ProductsGridWidget({super.key});

  @override
  State<ProductsGridWidget> createState() => _ProductsGridWidgetState();
}

class _ProductsGridWidgetState extends State<ProductsGridWidget> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const GetProductsEvent(categoryId: null));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductsLoaded) {
          final activeProducts = state.products.where((p) => p.active).toList();

          if (activeProducts.isEmpty) {
            return const Center(child: Text('لا توجد منتجات متاحة.', style: TextStyle(fontSize: 18, color: Colors.grey)));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, 
              childAspectRatio: 0.8, // تحسين النسبة لشكل أكثر احترافية
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: activeProducts.length,
            itemBuilder: (context, index) {
              final product = activeProducts[index];
              return InkWell(
                onTap: () {
                  // فتح نافذة الإضافات بدلاً من الإضافة المباشرة للسلة
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: context.read<CartBloc>()),
                          // حقن ModifierBloc للنافذة لكي تتمكن من جلب الإضافات
                          BlocProvider(create: (context) => sl<ModifierBloc>()),
                        ],
                        child: ProductModifiersDialog(product: product),
                      );
                    },
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(), blurRadius: 10, spreadRadius: 2, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.blue.shade300, Colors.blue.shade600],
                            ),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          child: const Center(child: Icon(Icons.fastfood, size: 48, color: Colors.white)),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                product.name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  '${product.sellingPrice} ج.م',
                                  style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}