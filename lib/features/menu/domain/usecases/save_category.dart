import '../../../../core/usecases/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/menu_repository.dart';

class SaveCategoryUseCase implements UseCase<CategoryEntity, CategoryEntity> {
  final MenuRepository repository;

  SaveCategoryUseCase(this.repository);

  @override
  Future<CategoryEntity> call(CategoryEntity category) async {
    return await repository.saveCategory(category);
  }
}