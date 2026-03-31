import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/database/database_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DatabaseService databaseService;
  final FlutterSecureStorage secureStorage;

  static const String _currentUserKey = 'current_user_session';

  AuthRepositoryImpl({
    required this.databaseService,
    required this.secureStorage,
  });

  @override
  Future<UserEntity?> loginWithPin(String pinCode) async {
    final db = await databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'pin_code = ? AND is_active = 1',
      whereArgs: [pinCode],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      final userModel = UserModel.fromMap(maps.first);
      // حفظ الجلسة في التخزين الآمن (Secure Storage) بتنسيق JSON
      await secureStorage.write(
        key: _currentUserKey,
        value: json.encode(userModel.toMap()),
      );
      return userModel; // نُرجع الموديل الذي يُعتبر أيضاً Entity بفضل الوراثة
    }
    return null; // الرمز خاطئ أو المستخدم موقوف
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final String? userJson = await secureStorage.read(key: _currentUserKey);
    if (userJson != null) {
      return UserModel.fromMap(json.decode(userJson));
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await secureStorage.delete(key: _currentUserKey);
  }
}