import 'package:equatable/equatable.dart';
import '../../../menu/domain/entities/modifier_entity.dart';
import '../../../menu/domain/entities/product_entity.dart';

class CartItemEntity extends Equatable {
  final String id; // مُعرف فريد مؤقت في الـ RAM لكل سطر
  final ProductEntity product;
  final double quantity;
  final List<ModifierEntity> modifiers;

  const CartItemEntity({
    required this.id,
    required this.product,
    this.quantity = 1.0,
    this.modifiers = const [],
  });

  // حسابات مساعدة (Helpers) لمعرفة سعر السطر الواحد بناءً على الإضافات
  double get unitPrice => product.sellingPrice + modifiers.fold(0.0, (sum, mod) => sum + mod.price);
  
  double get unitCost => product.costPrice; // التكلفة لا تتأثر بسعر الإضافات في نظامنا الحالي

  double get totalPrice => unitPrice * quantity;

  double get totalCost => unitCost * quantity;

  // دالة لتسهيل تعديل الكمية أو الإضافات لنفس السطر
  CartItemEntity copyWith({
    String? id,
    ProductEntity? product,
    double? quantity,
    List<ModifierEntity>? modifiers,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      modifiers: modifiers ?? this.modifiers,
    );
  }

  @override
  List<Object?> get props => [id, product, quantity, modifiers];
}