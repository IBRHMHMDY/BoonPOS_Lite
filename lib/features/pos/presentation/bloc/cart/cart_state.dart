import 'package:equatable/equatable.dart';
import '../../../domain/entities/cart_item_entity.dart';

class CartState extends Equatable {
  final List<CartItemEntity> items;
  final double subtotal;
  final double discount;
  final double tax;
  final double netTotal;

  const CartState({
    this.items = const [],
    this.subtotal = 0.0,
    this.discount = 0.0,
    this.tax = 0.0,
    this.netTotal = 0.0,
  });

  CartState copyWith({
    List<CartItemEntity>? items,
    double? subtotal,
    double? discount,
    double? tax,
    double? netTotal,
  }) {
    return CartState(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      netTotal: netTotal ?? this.netTotal,
    );
  }

  @override
  List<Object?> get props => [items, subtotal, discount, tax, netTotal];
}