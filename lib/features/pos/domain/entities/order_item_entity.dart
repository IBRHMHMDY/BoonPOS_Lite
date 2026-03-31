import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final int id;
  final int orderId;
  final int? productId; // قد يكون null لو تم حذف المنتج نهائياً لاحقاً
  final String productName;
  final double quantity;
  final double unitCostPrice;
  final double unitSellingPrice;
  final String? modifiersText; // الإضافات كنص لحفظها في الفاتورة (مثال: "زيادة جبنة، صوص حار")
  final double totalCost;
  final double totalPrice;

  const OrderItemEntity({
    required this.id,
    required this.orderId,
    this.productId,
    required this.productName,
    required this.quantity,
    required this.unitCostPrice,
    required this.unitSellingPrice,
    this.modifiersText,
    required this.totalCost,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [
        id,
        orderId,
        productId,
        productName,
        quantity,
        unitCostPrice,
        unitSellingPrice,
        modifiersText,
        totalCost,
        totalPrice,
      ];
}