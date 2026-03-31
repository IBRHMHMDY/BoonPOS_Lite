import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int id;
  final int categoryId;
  final String? barcode;
  final String name;
  final double costPrice;
  final double sellingPrice;
  final int isActive;

  const ProductEntity({
    required this.id,
    required this.categoryId,
    this.barcode,
    required this.name,
    required this.costPrice,
    required this.sellingPrice,
    required this.isActive,
  });

  bool get active => isActive == 1;

  @override
  List<Object?> get props => [
        id,
        categoryId,
        barcode,
        name,
        costPrice,
        sellingPrice,
        isActive,
      ];
}