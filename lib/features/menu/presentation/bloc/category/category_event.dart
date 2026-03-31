import 'package:equatable/equatable.dart';
import '../../../domain/entities/category_entity.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class GetCategoriesEvent extends CategoryEvent {}

class SaveCategoryEvent extends CategoryEvent {
  final CategoryEntity category;

  const SaveCategoryEvent({required this.category});

  @override
  List<Object> get props => [category];
}

class DeleteCategoryEvent extends CategoryEvent {
  final int id;

  const DeleteCategoryEvent({required this.id});

  @override
  List<Object> get props => [id];
}