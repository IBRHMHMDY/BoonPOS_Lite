import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/cart_item_entity.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddProductToCartEvent>(_onAddProduct);
    on<RemoveItemFromCartEvent>(_onRemoveItem);
    on<UpdateItemQuantityEvent>(_onUpdateQuantity);
    on<AddModifierToItemEvent>(_onAddModifier);
    on<RemoveModifierFromItemEvent>(_onRemoveModifier);
    on<ApplyDiscountEvent>(_onApplyDiscount);
    on<ApplyTaxEvent>(_onApplyTax);
    on<ClearCartEvent>(_onClearCart);
  }

  void _onAddProduct(AddProductToCartEvent event, Emitter<CartState> emit) {
    List<CartItemEntity> updatedItems = List.from(state.items);

    // التحقق مما إذا كان المنتج موجوداً مسبقاً في السلة وبدون إضافات لزيادة كميته فقط
    final existingIndex = updatedItems.indexWhere(
      (item) => item.product.id == event.product.id && item.modifiers.isEmpty
    );

    if (existingIndex >= 0) {
      final existingItem = updatedItems[existingIndex];
      updatedItems[existingIndex] = existingItem.copyWith(quantity: existingItem.quantity + 1);
    } else {
      // إنشاء سطر جديد بمعرف فريد يعتمد على الوقت بالمايكروثانية
      final newItem = CartItemEntity(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        product: event.product,
        quantity: 1,
        modifiers: const [],
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
    if (event.quantity <= 0) return; // منع الكميات السالبة أو الصفر
    final updatedItems = state.items.map((item) {
      if (item.id == event.cartItemId) {
        return item.copyWith(quantity: event.quantity);
      }
      return item;
    }).toList();
    emit(_recalculate(updatedItems, state.discount, state.tax));
  }

  void _onAddModifier(AddModifierToItemEvent event, Emitter<CartState> emit) {
    final updatedItems = state.items.map((item) {
      if (item.id == event.cartItemId) {
        // منع إضافة نفس الـ Modifier مرتين لنفس السطر
        if (!item.modifiers.any((m) => m.id == event.modifier.id)) {
          final newMods = List.of(item.modifiers)..add(event.modifier);
          return item.copyWith(modifiers: newMods);
        }
      }
      return item;
    }).toList();
    emit(_recalculate(updatedItems, state.discount, state.tax));
  }

  void _onRemoveModifier(RemoveModifierFromItemEvent event, Emitter<CartState> emit) {
    final updatedItems = state.items.map((item) {
      if (item.id == event.cartItemId) {
        final newMods = item.modifiers.where((m) => m.id != event.modifier.id).toList();
        return item.copyWith(modifiers: newMods);
      }
      return item;
    }).toList();
    emit(_recalculate(updatedItems, state.discount, state.tax));
  }

  void _onApplyDiscount(ApplyDiscountEvent event, Emitter<CartState> emit) {
    emit(_recalculate(state.items, event.discountAmount, state.tax));
  }

  void _onApplyTax(ApplyTaxEvent event, Emitter<CartState> emit) {
    emit(_recalculate(state.items, state.discount, event.taxAmount));
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    emit(const CartState()); // العودة للحالة الصفرية
  }

  // المحرك الأساسي للحسابات (الصافي = المجموع الفرعي - الخصم + الضريبة)
  CartState _recalculate(List<CartItemEntity> items, double discount, double tax) {
    double subtotal = 0.0;
    for (var item in items) {
      subtotal += item.totalPrice;
    }

    double netTotal = subtotal - discount + tax;
    if (netTotal < 0) netTotal = 0; // حماية من القيم السالبة

    return CartState(
      items: items,
      subtotal: subtotal,
      discount: discount,
      tax: tax,
      netTotal: netTotal,
    );
  }
}