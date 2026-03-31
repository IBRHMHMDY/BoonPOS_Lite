import 'package:equatable/equatable.dart';

class ModifierEntity extends Equatable {
  final int id;
  final int productId;
  final String name;
  final double price;
  final int isActive;

  const ModifierEntity({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.isActive,
  });

  bool get active => isActive == 1;

  @override
  List<Object?> get props => [id, productId, name, price, isActive];
}