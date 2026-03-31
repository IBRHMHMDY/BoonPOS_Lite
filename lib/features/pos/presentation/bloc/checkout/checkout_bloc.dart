import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/entities/order_item_entity.dart';
import '../../../domain/usecases/get_next_order_number.dart';
import '../../../domain/usecases/save_order.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final GetNextOrderNumberUseCase getNextOrderNumber;
  final SaveOrderUseCase saveOrder;

  CheckoutBloc({
    required this.getNextOrderNumber,
    required this.saveOrder,
  }) : super(CheckoutInitial()) {
    on<ProcessCheckoutEvent>(_onProcessCheckout);
  }

  Future<void> _onProcessCheckout(ProcessCheckoutEvent event, Emitter<CheckoutState> emit) async {
    emit(CheckoutLoading());
    try {
      // 1. جلب رقم الفاتورة التالي
      final int orderNumber = await getNextOrderNumber(event.shiftId);

      // 2. تجهيز رأس الفاتورة
      final order = OrderEntity(
        id: 0, // سيتم توليده
        shiftId: event.shiftId,
        orderNumber: orderNumber,
        status: 'completed',
        subtotal: event.cartState.subtotal,
        discountAmount: event.cartState.discount,
        taxAmount: event.cartState.tax,
        additionalFees: 0.0,
        netTotal: event.cartState.netTotal,
        paidCash: event.paidCash,
        paidVisa: event.paidVisa,
        paidWallet: event.paidWallet,
        createdAt: DateTime.now().toIso8601String(),
      );

      // 3. تجهيز عناصر الفاتورة (Snapshot)
      final items = event.cartState.items.map((cartItem) {
        // تحويل قائمة الإضافات إلى نص لسهولة عرضها في الفواتير القديمة لاحقاً
        final modifiersText = cartItem.modifiers.isNotEmpty 
            ? cartItem.modifiers.map((m) => m.name).join('، ') 
            : null;

        return OrderItemEntity(
          id: 0,
          orderId: 0, // سيتم ربطه لاحقاً في DataSource
          productId: cartItem.product.id,
          productName: cartItem.product.name,
          quantity: cartItem.quantity,
          unitCostPrice: cartItem.unitCost,
          unitSellingPrice: cartItem.product.sellingPrice,
          modifiersText: modifiersText,
          totalCost: cartItem.totalCost,
          totalPrice: cartItem.totalPrice,
        );
      }).toList();

      // 4. تنفيذ الحفظ
      final savedOrder = await saveOrder(SaveOrderParams(order: order, items: items));
      
      emit(CheckoutSuccess(order: savedOrder));
    } catch (e) {
      emit(const CheckoutError(message: 'حدث خطأ غير متوقع أثناء إتمام عملية الدفع وحفظ الفاتورة.'));
    }
  }
}