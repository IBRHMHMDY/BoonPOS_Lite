import 'package:equatable/equatable.dart';
import '../../../domain/entities/product_entity.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class GetProductsEvent extends ProductEvent {
  final int? categoryId;

  const GetProductsEvent({this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class SaveProductEvent extends ProductEvent {
  final ProductEntity product;
  final int? currentCategoryId; // لجلب نفس القائمة بعد الحفظ

  const SaveProductEvent({required this.product, this.currentCategoryId});

  @override
  List<Object?> get props => [product, currentCategoryId];
}

class DeleteProductEvent extends ProductEvent {
  final int id;
  final int? currentCategoryId;

  const DeleteProductEvent({required this.id, this.currentCategoryId});

  @override
  List<Object?> get props => [id, currentCategoryId];
}