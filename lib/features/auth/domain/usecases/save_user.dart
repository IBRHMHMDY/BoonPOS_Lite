import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SaveUserUseCase implements UseCase<UserEntity, UserEntity> {
  final AuthRepository repository;

  SaveUserUseCase(this.repository);

  @override
  Future<UserEntity> call(UserEntity user) async {
    return await repository.saveUser(user);
  }
}