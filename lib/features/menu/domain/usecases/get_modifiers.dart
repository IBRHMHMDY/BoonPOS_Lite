import '../../../../core/usecases/usecase.dart';
import '../entities/modifier_entity.dart';
import '../repositories/menu_repository.dart';

class GetModifiersUseCase implements UseCase<List<ModifierEntity>, int> {
  final MenuRepository repository;

  GetModifiersUseCase(this.repository);

  @override
  Future<List<ModifierEntity>> call(int productId) async {
    return await repository.getModifiers(productId);
  }
}