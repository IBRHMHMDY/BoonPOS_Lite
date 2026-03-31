import '../../../../core/usecases/usecase.dart';
import '../repositories/menu_repository.dart';

class DeleteModifierUseCase implements UseCase<void, int> {
  final MenuRepository repository;

  DeleteModifierUseCase(this.repository);

  @override
  Future<void> call(int id) async {
    return await repository.deleteModifier(id);
  }
}