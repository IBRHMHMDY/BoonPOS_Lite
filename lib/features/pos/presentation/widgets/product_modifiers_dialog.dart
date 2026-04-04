import 'package:boon_pos_lite/features/menu/domain/entities/modifier_entity.dart';
import 'package:boon_pos_lite/features/menu/domain/entities/product_entity.dart';
import 'package:boon_pos_lite/features/menu/presentation/bloc/modifier/modifier_bloc.dart';
import 'package:boon_pos_lite/features/menu/presentation/bloc/modifier/modifier_event.dart';
import 'package:boon_pos_lite/features/menu/presentation/bloc/modifier/modifier_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';

class ProductModifiersDialog extends StatefulWidget {
  final ProductEntity product;

  const ProductModifiersDialog({super.key, required this.product});

  @override
  State<ProductModifiersDialog> createState() => _ProductModifiersDialogState();
}

class _ProductModifiersDialogState extends State<ProductModifiersDialog> {
  final List<ModifierEntity> _selectedModifiers = [];
  double _quantity = 1.0;

  @override
  void initState() {
    super.initState();
    // نطلب جلب الإضافات الخاصة بهذا المنتج فور فتح النافذة
    context.read<ModifierBloc>().add(GetModifiersEvent(productId: widget.product.id));
  }

  void _addToCart() {
    context.read<CartBloc>().add(
      AddProductToCartEvent(
        product: widget.product,
        modifiers: _selectedModifiers,
        quantity: _quantity,
      ),
    );
    Navigator.pop(context); // إغلاق النافذة
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Column(
        children: [
          Text(widget.product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('${widget.product.sellingPrice} ج.م', style: const TextStyle(color: Color(0xFF1E88E5), fontSize: 18)),
          const Divider(),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: BlocBuilder<ModifierBloc, ModifierState>(
          builder: (context, state) {
            if (state is ModifierLoading) {
              return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
            } else if (state is ModifiersLoaded) {
              final modifiers = state.modifiers.where((m) => m.active).toList();
              
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // قسم التحكم بالكمية
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red, size: 36),
                          onPressed: () {
                            if (_quantity > 1) setState(() => _quantity--);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(_quantity.toInt().toString(), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.green, size: 36),
                          onPressed: () => setState(() => _quantity++),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // قسم الإضافات
                    if (modifiers.isNotEmpty) ...[
                      const Text('الإضافات المتاحة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 8),
                      ...modifiers.map((modifier) {
                        final isSelected = _selectedModifiers.any((m) => m.id == modifier.id);
                        return CheckboxListTile(
                          title: Text(modifier.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('+ ${modifier.price} ج.م', style: const TextStyle(color: Colors.green)),
                          value: isSelected,
                          activeColor: const Color(0xFF1E88E5),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedModifiers.add(modifier);
                              } else {
                                _selectedModifiers.removeWhere((m) => m.id == modifier.id);
                              }
                            });
                          },
                        );
                      }),
                    ] else ...[
                      const Center(child: Text('لا توجد إضافات لهذا المنتج.', style: TextStyle(color: Colors.grey))),
                    ],
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء', style: TextStyle(fontSize: 18, color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E88E5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: _addToCart,
          child: const Text('إضافة للسلة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}