import '../../../../core/usecases/usecases.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithPinUseCase implements UseCase<UserEntity?, String> {
  final AuthRepository repository;

  LoginWithPinUseCase(this.repository);

  @override
  Future<UserEntity?> call(String pinCode) async {
    return await repository.loginWithPin(pinCode);
  }
}