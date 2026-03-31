import '../../../../core/usecases/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/menu_repository.dart';

class GetCategoriesUseCase implements UseCase<List<CategoryEntity>, NoParams> {
  final MenuRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<List<CategoryEntity>> call(NoParams params) async {
    return await repository.getCategories();
  }
}