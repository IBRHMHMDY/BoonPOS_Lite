import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class DeleteUserUseCase implements UseCase<void, int> {
  final AuthRepository repository;

  DeleteUserUseCase(this.repository);

  @override
  Future<void> call(int id) async {
    return await repository.deleteUser(id);
  }
}