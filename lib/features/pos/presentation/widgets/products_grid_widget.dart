import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../menu/presentation/bloc/product/product_bloc.dart';
import '../../../menu/presentation/bloc/product/product_event.dart';
import '../../../menu/presentation/bloc/product/product_state.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';

class ProductsGridWidget extends StatefulWidget {
  const ProductsGridWidget({Key? key}) : super(key: key);

  @override
  State<ProductsGridWidget> createState() => _ProductsGridWidgetState();
}

class _ProductsGridWidgetState extends State<ProductsGridWidget> {
  @override
  void initState() {
    super.initState();
    // جلب كل المنتجات في البداية
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
            return const Center(
              child: Text(
                'لا توجد منتجات في هذا التصنيف.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // 4 أعمدة للمنتجات في المساحة المخصصة
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: activeProducts.length,
            itemBuilder: (context, index) {
              final product = activeProducts[index];
              return InkWell(
                onTap: () {
                  // إضافة المنتج فوراً للسلة
                  context.read<CartBloc>().add(AddProductToCartEvent(product: product));
                },
                borderRadius: BorderRadius.circular(12),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // جزء علوي ملون (مؤقت بدلاً من الصورة)
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade100,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          ),
                          child: const Icon(Icons.fastfood, size: 40, color: Colors.blueGrey),
                        ),
                      ),
                      // تفاصيل المنتج
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
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${product.sellingPrice} ج.م',
                                style: const TextStyle(
                                  color: Color(0xFF1E88E5),
                                  fontWeight: FontWeight.bold,
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