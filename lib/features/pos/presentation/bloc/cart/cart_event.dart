import 'package:equatable/equatable.dart';
import '../../../../menu/domain/entities/modifier_entity.dart';
import '../../../../menu/domain/entities/product_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddProductToCartEvent extends CartEvent {
  final ProductEntity product;
  const AddProductToCartEvent({required this.product});

  @override
  List<Object?> get props => [product];
}

class RemoveItemFromCartEvent extends CartEvent {
  final String cartItemId;
  const RemoveItemFromCartEvent({required this.cartItemId});

  @override
  List<Object?> get props => [cartItemId];
}

class UpdateItemQuantityEvent extends CartEvent {
  final String cartItemId;
  final double quantity;
  const UpdateItemQuantityEvent({required this.cartItemId, required this.quantity});

  @override
  List<Object?> get props => [cartItemId, quantity];
}

class AddModifierToItemEvent extends CartEvent {
  final String cartItemId;
  final ModifierEntity modifier;
  const AddModifierToItemEvent({required this.cartItemId, required this.modifier});

  @override
  List<Object?> get props => [cartItemId, modifier];
}

class RemoveModifierFromItemEvent extends CartEvent {
  final String cartItemId;
  final ModifierEntity modifier;
  const RemoveModifierFromItemEvent({required this.cartItemId, required this.modifier});

  @override
  List<Object?> get props => [cartItemId, modifier];
}

class ApplyDiscountEvent extends CartEvent {
  final double discountAmount;
  const ApplyDiscountEvent({required this.discountAmount});

  @override
  List<Object?> get props => [discountAmount];
}

class ApplyTaxEvent extends CartEvent {
  final double taxAmount;
  const ApplyTaxEvent({required this.taxAmount});

  @override
  List<Object?> get props => [taxAmount];
}

class ClearCartEvent extends CartEvent {}