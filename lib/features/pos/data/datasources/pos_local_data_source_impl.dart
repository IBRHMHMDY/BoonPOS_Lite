import '../../../../core/database/database_service.dart';
import '../models/order_item_model.dart';
import '../models/order_model.dart';
import 'pos_local_data_source.dart';

class PosLocalDataSourceImpl implements PosLocalDataSource {
  final DatabaseService databaseService;

  PosLocalDataSourceImpl({required this.databaseService});

  @override
  Future<int> getNextOrderNumber(int shiftId) async {
    final db = await databaseService.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT MAX(order_number) as max_num FROM orders WHERE shift_id = ?',
      [shiftId],
    );

    int maxNum = (result.first['max_num'] as int?) ?? 0;
    return maxNum + 1; // الرقم التسلسلي التالي لهذه الوردية
  }

  @override
  Future<OrderModel> saveOrder(OrderModel order, List<OrderItemModel> items) async {
    final db = await databaseService.database;
    late int newOrderId;

    // استخدام Transaction لضمان إما حفظ الفاتورة وعناصرها بالكامل، أو التراجع بالكامل
    await db.transaction((txn) async {
      // 1. إدراج رأس الفاتورة
      newOrderId = await txn.insert('orders', order.toMap());

      // 2. إدراج جميع عناصر الفاتورة وربطها بالـ newOrderId
      for (var item in items) {
        final itemMap = item.toMap();
        itemMap['order_id'] = newOrderId; // تحديث معرف الفاتورة للعنصر
        await txn.insert('order_items', itemMap);
      }
    });

    // إرجاع الفاتورة مع الـ ID الحقيقي الذي تم توليده
    return OrderModel(
      id: newOrderId,
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
  }
}