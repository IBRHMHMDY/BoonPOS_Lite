import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    super.colorHex,
    required super.sortOrder,
    required super.isActive,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int,
      name: map['name'] as String,
      colorHex: map['color_hex'] as String?,
      sortOrder: map['sort_order'] as int,
      isActive: map['is_active'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'color_hex': colorHex,
      'sort_order': sortOrder,
      'is_active': isActive,
    };
    // لا نرسل الـ id إذا كان 0 لكي يقوم SQLite بتوليده تلقائياً
    if (id != 0) {
      map['id'] = id;
    }
    return map;
  }
}