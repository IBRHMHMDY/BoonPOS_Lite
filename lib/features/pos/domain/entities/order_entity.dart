import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final int id;
  final int shiftId;
  final int orderNumber;
  final String status; // 'completed', 'refunded'
  final double subtotal;
  final double discountAmount;
  final double taxAmount;
  final double additionalFees;
  final double netTotal;
  final double paidCash;
  final double paidVisa;
  final double paidWallet;
  final String createdAt;

  const OrderEntity({
    required this.id,
    required this.shiftId,
    required this.orderNumber,
    required this.status,
    required this.subtotal,
    required this.discountAmount,
    required this.taxAmount,
    required this.additionalFees,
    required this.netTotal,
    required this.paidCash,
    required this.paidVisa,
    required this.paidWallet,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        shiftId,
        orderNumber,
        status,
        subtotal,
        discountAmount,
        taxAmount,
        additionalFees,
        netTotal,
        paidCash,
        paidVisa,
        paidWallet,
        createdAt,
      ];
}