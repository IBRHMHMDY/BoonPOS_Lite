import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetUsersUseCase implements UseCase<List<UserEntity>, NoParams> {
  final AuthRepository repository;

  GetUsersUseCase(this.repository);

  @override
  Future<List<UserEntity>> call(NoParams params) async {
    return await repository.getUsers();
  }
}