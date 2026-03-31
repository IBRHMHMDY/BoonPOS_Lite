import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.shiftId,
    required super.orderNumber,
    required super.status,
    required super.subtotal,
    required super.discountAmount,
    required super.taxAmount,
    required super.additionalFees,
    required super.netTotal,
    required super.paidCash,
    required super.paidVisa,
    required super.paidWallet,
    required super.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as int,
      shiftId: map['shift_id'] as int,
      orderNumber: map['order_number'] as int,
      status: map['status'] as String,
      subtotal: (map['subtotal'] as num).toDouble(),
      discountAmount: (map['discount_amount'] as num).toDouble(),
      taxAmount: (map['tax_amount'] as num).toDouble(),
      additionalFees: (map['additional_fees'] as num).toDouble(),
      netTotal: (map['net_total'] as num).toDouble(),
      paidCash: (map['paid_cash'] as num).toDouble(),
      paidVisa: (map['paid_visa'] as num).toDouble(),
      paidWallet: (map['paid_wallet'] as num).toDouble(),
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'shift_id': shiftId,
      'order_number': orderNumber,
      'status': status,
      'subtotal': subtotal,
      'discount_amount': discountAmount,
      'tax_amount': taxAmount,
      'additional_fees': additionalFees,
      'net_total': netTotal,
      'paid_cash': paidCash,
      'paid_visa': paidVisa,
      'paid_wallet': paidWallet,
      'created_at': createdAt,
    };
    if (id != 0) {
      map['id'] = id;
    }
    return map;
  }
}