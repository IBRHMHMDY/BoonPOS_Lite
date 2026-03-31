import '../entities/order_entity.dart';
import '../entities/order_item_entity.dart';

abstract class PosRepository {
  /// جلب رقم الطلب التالي للوردية الحالية
  Future<int> getNextOrderNumber(int shiftId);

  /// حفظ الفاتورة مع عناصرها بشكل آمن (Transaction)
  Future<OrderEntity> saveOrder(OrderEntity order, List<OrderItemEntity> items);
}