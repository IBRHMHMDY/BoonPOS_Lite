import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_numpad.dart';
import '../../../shift/presentation/bloc/shift_bloc.dart';
import '../../../shift/presentation/bloc/shift_state.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/cart/cart_state.dart';
import '../bloc/checkout/checkout_bloc.dart';
import '../bloc/checkout/checkout_event.dart';
import '../bloc/checkout/checkout_state.dart';

class CheckoutDialog extends StatefulWidget {
  final CartState cartState;

  const CheckoutDialog({super.key, required this.cartState});

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  String _paidAmountStr = '0';

  void _onKeyPress(String key) {
    setState(() {
      if (_paidAmountStr == '0' && key != '.') {
        _paidAmountStr = key;
      } else {
        if (key == '.' && _paidAmountStr.contains('.')) return;
        _paidAmountStr += key;
      }
    });
  }

  void _onBackspace() {
    if (_paidAmountStr.length > 1) {
      setState(() => _paidAmountStr = _paidAmountStr.substring(0, _paidAmountStr.length - 1));
    } else {
      setState(() => _paidAmountStr = '0');
    }
  }

  void _onClear() {
    setState(() => _paidAmountStr = '0');
  }

  void _processCheckout(BuildContext context, int shiftId) {
    final double paidCash = double.tryParse(_paidAmountStr) ?? 0.0;
    
    if (paidCash < widget.cartState.netTotal) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('المبلغ المدفوع أقل من إجمالي الفاتورة!'), backgroundColor: Colors.orange),
      );
      return;
    }

    context.read<CheckoutBloc>().add(ProcessCheckoutEvent(
      shiftId: shiftId,
      cartState: widget.cartState,
      paidCash: paidCash,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final double netTotal = widget.cartState.netTotal;
    final double paidCash = double.tryParse(_paidAmountStr) ?? 0.0;
    final double change = paidCash >= netTotal ? paidCash - netTotal : 0.0;

    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutSuccess) {
          // تفريغ السلة بعد نجاح الدفع
          context.read<CartBloc>().add(ClearCartEvent());
          Navigator.pop(context); // إغلاق نافذة الدفع
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم إتمام الدفع بنجاح! رقم الفاتورة: ${state.order.orderNumber}'), 
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is CheckoutError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return AlertDialog(
          title: const Text('إتمام الدفع (كاش)', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 600,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // القسم الأيمن (تفاصيل الحساب)
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildAmountBox('الإجمالي المطلوب', netTotal, Colors.blue.shade100, Colors.blue.shade900),
                        const SizedBox(height: 16),
                        _buildAmountBox('المبلغ المدفوع', paidCash, Colors.green.shade100, Colors.green.shade900),
                        const SizedBox(height: 16),
                        _buildAmountBox('الباقي للعميل', change, Colors.orange.shade100, Colors.orange.shade900),
                        const SizedBox(height: 24),
                        // جلب رقم الوردية من ShiftBloc
                        BlocBuilder<ShiftBloc, ShiftState>(
                          builder: (context, shiftState) {
                            if (shiftState is ShiftActive) {
                              return SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E88E5),
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: state is CheckoutLoading 
                                      ? null 
                                      : () => _processCheckout(context, shiftState.shift.id),
                                  child: state is CheckoutLoading
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : const Text('تأكيد وحفظ الفاتورة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                ),
                              );
                            }
                            return const Text('خطأ: لا توجد وردية مفتوحة!', style: TextStyle(color: Colors.red));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // القسم الأيسر (الـ Numpad)
                  Expanded(
                    flex: 1,
                    child: CustomNumpad(
                      onKeyPress: _onKeyPress,
                      onBackspace: _onBackspace,
                      onClear: _onClear,
                      showClearButton: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: state is CheckoutLoading ? null : () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAmountBox(String title, double amount, Color bgColor, Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withValues()),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            '${amount.toStringAsFixed(2)} ج.م',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
            textDirection: TextDirection.ltr,
          ),
        ],
      ),
    );
  }
}