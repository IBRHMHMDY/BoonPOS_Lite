import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.categoryId,
    super.barcode,
    required super.name,
    required super.costPrice,
    required super.sellingPrice,
    required super.isActive,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int,
      categoryId: map['category_id'] as int,
      barcode: map['barcode'] as String?,
      name: map['name'] as String,
      costPrice: (map['cost_price'] as num).toDouble(),
      sellingPrice: (map['selling_price'] as num).toDouble(),
      isActive: map['is_active'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'category_id': categoryId,
      'barcode': barcode,
      'name': name,
      'cost_price': costPrice,
      'selling_price': sellingPrice,
      'is_active': isActive,
    };
    if (id != 0) {
      map['id'] = id;
    }
    return map;
  }
}