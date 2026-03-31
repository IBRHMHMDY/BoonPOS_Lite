import '../../../../core/usecases/usecase.dart';
import '../repositories/menu_repository.dart';

class DeleteCategoryUseCase implements UseCase<void, int> {
  final MenuRepository repository;

  DeleteCategoryUseCase(this.repository);

  @override
  Future<void> call(int id) async {
    return await repository.deleteCategory(id);
  }
}