import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_item_entity.dart';
import '../../domain/repositories/pos_repository.dart';
import '../datasources/pos_local_data_source.dart';
import '../models/order_item_model.dart';
import '../models/order_model.dart';

class PosRepositoryImpl implements PosRepository {
  final PosLocalDataSource localDataSource;

  PosRepositoryImpl({required this.localDataSource});

  @override
  Future<int> getNextOrderNumber(int shiftId) async {
    return await localDataSource.getNextOrderNumber(shiftId);
  }

  @override
  Future<OrderEntity> saveOrder(OrderEntity order, List<OrderItemEntity> items) async {
    // تحويل الـ Entity إلى Model
    final orderModel = OrderModel(
      id: order.id,
      shiftId: order.shiftId,
      orderNumber: order.orderNumber,
      status: order.status,
      subtotal: order.subtotal,
      discountAmount: order.discountAmount,
      taxAmount: order.taxAmount,
      additionalFees: order.additionalFees,
      netTotal: order.netTotal,
      paidCash: order.paidCash,
      paidVisa: order.paidVisa,
      paidWallet: order.paidWallet,
      createdAt: order.createdAt,
    );

    // تحويل قائمة الـ Entities إلى Models
    final itemModels = items.map((item) => OrderItemModel(
      id: item.id,
      orderId: item.orderId,
      productId: item.productId,
      productName: item.productName,
      quantity: item.quantity,
      unitCostPrice: item.unitCostPrice,
      unitSellingPrice: item.unitSellingPrice,
      modifiersText: item.modifiersText,
      totalCost: item.totalCost,
      totalPrice: item.totalPrice,
    )).toList();

    // استدعاء مصدر البيانات
    return await localDataSource.saveOrder(orderModel, itemModels);
  }
}