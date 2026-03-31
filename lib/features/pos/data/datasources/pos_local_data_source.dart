import '../models/order_model.dart';
import '../models/order_item_model.dart';

abstract class PosLocalDataSource {
  Future<int> getNextOrderNumber(int shiftId);
  Future<OrderModel> saveOrder(OrderModel order, List<OrderItemModel> items);
}