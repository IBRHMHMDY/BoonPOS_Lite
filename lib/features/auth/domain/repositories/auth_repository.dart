import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> loginWithPin(String pinCode);
  Future<UserEntity?> getCurrentUser();
  Future<void> logout();

  Future<List<UserEntity>> getUsers();
  Future<UserEntity> saveUser(UserEntity user);
  Future<void> deleteUser(int id); // Soft Delete
}