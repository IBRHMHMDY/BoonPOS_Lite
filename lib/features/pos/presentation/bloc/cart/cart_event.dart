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
  final List<ModifierEntity> modifiers; // تمت إضافة هذا الحقل
  final double quantity; // لدعم إضافة أكثر من قطعة مرة واحدة

  const AddProductToCartEvent({
    required this.product, 
    this.modifiers = const [],
    this.quantity = 1.0,
  });

  @override
  List<Object?> get props => [product, modifiers, quantity];
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

class ClearCartEvent extends CartEvent {}