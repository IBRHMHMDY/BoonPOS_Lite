import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int id; // سيكون 0 عند الإنشاء الجديد
  final String name;
  final String? colorHex;
  final int sortOrder;
  final int isActive;

  const CategoryEntity({
    required this.id,
    required this.name,
    this.colorHex,
    required this.sortOrder,
    required this.isActive,
  });

  bool get active => isActive == 1;

  @override
  List<Object?> get props => [id, name, colorHex, sortOrder, isActive];
}