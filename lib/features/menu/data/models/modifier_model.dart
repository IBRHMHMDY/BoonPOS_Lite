import '../../domain/entities/modifier_entity.dart';

class ModifierModel extends ModifierEntity {
  const ModifierModel({
    required super.id,
    required super.productId,
    required super.name,
    required super.price,
    required super.isActive,
  });

  factory ModifierModel.fromMap(Map<String, dynamic> map) {
    return ModifierModel(
      id: map['id'] as int,
      productId: map['product_id'] as int,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      isActive: map['is_active'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'product_id': productId,
      'name': name,
      'price': price,
      'is_active': isActive,
    };
    if (id != 0) {
      map['id'] = id;
    }
    return map;
  }
}