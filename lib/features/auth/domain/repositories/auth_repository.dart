import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// تسجيل الدخول باستخدام الرمز السري
  /// يرجع [UserEntity] إذا كان الرمز صحيحاً والمستخدم نشطاً، وإلا يرجع null
  Future<UserEntity?> loginWithPin(String pinCode);

  /// جلب المستخدم المسجل دخوله حالياً من الجلسة (Session)
  Future<UserEntity?> getCurrentUser();

  /// تسجيل الخروج ومسح الجلسة
  Future<void> logout();
}