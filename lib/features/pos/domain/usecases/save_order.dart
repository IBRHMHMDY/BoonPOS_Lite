import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_entity.dart';
import '../entities/order_item_entity.dart';
import '../repositories/pos_repository.dart';

class SaveOrderParams extends Equatable {
  final OrderEntity order;
  final List<OrderItemEntity> items;

  const SaveOrderParams({required this.order, required this.items});

  @override
  List<Object> get props => [order, items];
}

class SaveOrderUseCase implements UseCase<OrderEntity, SaveOrderParams> {
  final PosRepository repository;

  SaveOrderUseCase(this.repository);

  @override
  Future<OrderEntity> call(SaveOrderParams params) async {
    return await repository.saveOrder(params.order, params.items);
  }
}