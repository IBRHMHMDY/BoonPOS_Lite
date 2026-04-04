import 'package:boon_pos_lite/features/pos/presentation/bloc/checkout/checkout_bloc.dart';
import 'package:boon_pos_lite/features/shift/presentation/bloc/shift_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/cart/cart_state.dart';
import 'checkout_dialog.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  void _showCheckoutDialog(BuildContext context, CartState cartState) {
    if (cartState.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('السلة فارغة!'), backgroundColor: Colors.orange),
      );
      return;
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        // نمرر الـ Blocs الحالية للـ Dialog لأنه يفتح في سياق (Context) جديد
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<CartBloc>()),
            BlocProvider.value(value: context.read<CheckoutBloc>()),
            BlocProvider.value(value: context.read<ShiftBloc>()),
          ],
          child: CheckoutDialog(cartState: cartState),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: Column(
            children: [
              // عنوان السلة
              Container(
                padding: const EdgeInsets.all(16),
                color: const Color(0xFF1E88E5),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'سلة المشتريات',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                      child: Text('${state.items.length} عناصر', style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),

              // قائمة المنتجات
              Expanded(
                child: state.items.isEmpty
                    ? const Center(
                        child: Text('السلة فارغة، ابدأ بإضافة المنتجات', style: TextStyle(color: Colors.grey, fontSize: 16)),
                      )
                    : ListView.separated(
                        itemCount: state.items.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = state.items[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            title: Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${item.unitPrice} ج.م x ${item.quantity}'),
                                if (item.modifiers.isNotEmpty)
                                  Text(
                                    'إضافات: ${item.modifiers.map((m) => m.name).join('، ')}',
                                    style: const TextStyle(color: Colors.orange, fontSize: 12),
                                  ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // أزرار التحكم بالكمية
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                  onPressed: () {
                                    if (item.quantity > 1) {
                                      context.read<CartBloc>().add(UpdateItemQuantityEvent(cartItemId: item.id, quantity: item.quantity - 1));
                                    } else {
                                      context.read<CartBloc>().add(RemoveItemFromCartEvent(cartItemId: item.id));
                                    }
                                  },
                                ),
                                Text(item.quantity.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                  onPressed: () {
                                    context.read<CartBloc>().add(UpdateItemQuantityEvent(cartItemId: item.id, quantity: item.quantity + 1));
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              // قسم الإجماليات السفلي
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow('المجموع الفرعي:', state.subtotal),
                    _buildSummaryRow('الخصم:', state.discount, isDeduction: true),
                    _buildSummaryRow('الضريبة:', state.tax),
                    const Divider(thickness: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('الصافي المطلوب:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(
                          '${state.netTotal.toStringAsFixed(2)} ج.م',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E88E5)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // أزرار الدفع والإلغاء
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade100,
                              foregroundColor: Colors.red.shade900,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: state.items.isEmpty 
                              ? null 
                              : () => context.read<CartBloc>().add(ClearCartEvent()),
                            child: const Text('إلغاء الطلب', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E88E5),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () => _showCheckoutDialog(context, state),
                            child: const Text('دفع (Checkout)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isDeduction = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.black54)),
          Text(
            '${isDeduction ? "-" : ""}${value.toStringAsFixed(2)} ج.م',
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold,
              color: isDeduction && value > 0 ? Colors.red : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}