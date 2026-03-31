import '../../../../core/usecases/usecase.dart';
import '../repositories/menu_repository.dart';

class DeleteProductUseCase implements UseCase<void, int> {
  final MenuRepository repository;

  DeleteProductUseCase(this.repository);

  @override
  Future<void> call(int id) async {
    return await repository.deleteProduct(id);
  }
}