import '../../domain/entities/order_item_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.id,
    required super.orderId,
    super.productId,
    required super.productName,
    required super.quantity,
    required super.unitCostPrice,
    required super.unitSellingPrice,
    super.modifiersText,
    required super.totalCost,
    required super.totalPrice,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      id: map['id'] as int,
      orderId: map['order_id'] as int,
      productId: map['product_id'] as int?,
      productName: map['product_name'] as String,
      quantity: (map['quantity'] as num).toDouble(),
      unitCostPrice: (map['unit_cost_price'] as num).toDouble(),
      unitSellingPrice: (map['unit_selling_price'] as num).toDouble(),
      modifiersText: map['modifiers_text'] as String?,
      totalCost: (map['total_cost'] as num).toDouble(),
      totalPrice: (map['total_price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'unit_cost_price': unitCostPrice,
      'unit_selling_price': unitSellingPrice,
      'modifiers_text': modifiersText,
      'total_cost': totalCost,
      'total_price': totalPrice,
    };
    if (id != 0) {
      map['id'] = id;
    }
    return map;
  }
}