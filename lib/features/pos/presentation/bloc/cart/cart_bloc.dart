import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../menu/domain/entities/modifier_entity.dart';
import '../../../domain/entities/cart_item_entity.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddProductToCartEvent>(_onAddProduct);
    on<RemoveItemFromCartEvent>(_onRemoveItem);
    on<UpdateItemQuantityEvent>(_onUpdateQuantity);
    on<ClearCartEvent>(_onClearCart);
  }

  // دالة مساعدة لمقارنة تطابق الإضافات بين سطرين في السلة
  bool _areModifiersEqual(List<ModifierEntity> m1, List<ModifierEntity> m2) {
    if (m1.length != m2.length) return false;
    final ids1 = m1.map((e) => e.id).toSet();
    final ids2 = m2.map((e) => e.id).toSet();
    return ids1.containsAll(ids2);
  }

  void _onAddProduct(AddProductToCartEvent event, Emitter<CartState> emit) {
    List<CartItemEntity> updatedItems = List.from(state.items);

    // البحث عن نفس المنتج بنفس الإضافات تماماً لدمج الكمية
    final existingIndex = updatedItems.indexWhere(
      (item) => item.product.id == event.product.id && _areModifiersEqual(item.modifiers, event.modifiers)
    );

    if (existingIndex >= 0) {
      final existingItem = updatedItems[existingIndex];
      updatedItems[existingIndex] = existingItem.copyWith(quantity: existingItem.quantity + event.quantity);
    } else {
      final newItem = CartItemEntity(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        product: event.product,
        quantity: event.quantity,
        modifiers: event.modifiers,
      );
      updatedItems.add(newItem);
    }

    emit(_recalculate(updatedItems, state.discount, state.tax));
  }

  void _onRemoveItem(RemoveItemFromCartEvent event, Emitter<CartState> emit) {
    final updatedItems = state.items.where((item) => item.id != event.cartItemId).toList();
    emit(_recalculate(updatedItems, state.discount, state.tax));
  }

  void _onUpdateQuantity(UpdateItemQuantityEvent event, Emitter<CartState> emit) {
    if (event.quantity <= 0) return;
    final updatedItems = state.items.map((item) {
      if (item.id == event.cartItemId) return item.copyWith(quantity: event.quantity);
      return item;
    }).toList();
    emit(_recalculate(updatedItems, state.discount, state.tax));
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    emit(const CartState());
  }

  CartState _recalculate(List<CartItemEntity> items, double discount, double tax) {
    double subtotal = 0.0;
    for (var item in items) {
      subtotal += item.totalPrice;
    }
    double netTotal = subtotal - discount + tax;
    if (netTotal < 0) netTotal = 0;

    return CartState(
      items: items,
      subtotal: subtotal,
      discount: discount,
      tax: tax,
      netTotal: netTotal,
    );
  }
}