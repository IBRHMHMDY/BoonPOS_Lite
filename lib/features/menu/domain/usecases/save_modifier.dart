import '../../../../core/usecases/usecase.dart';
import '../entities/modifier_entity.dart';
import '../repositories/menu_repository.dart';

class SaveModifierUseCase implements UseCase<ModifierEntity, ModifierEntity> {
  final MenuRepository repository;

  SaveModifierUseCase(this.repository);

  @override
  Future<ModifierEntity> call(ModifierEntity modifier) async {
    return await repository.saveModifier(modifier);
  }
}