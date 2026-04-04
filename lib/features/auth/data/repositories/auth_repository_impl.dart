import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/database/database_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DatabaseService databaseService;
  final FlutterSecureStorage secureStorage;

  AuthRepositoryImpl({
    required this.databaseService,
    required this.secureStorage,
  });

  // ==========================================
  // عمليات المصادقة (Auth)
  // ==========================================
  @override
  Future<UserEntity?> loginWithPin(String pinCode) async {
    final db = await databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'pin_code = ? AND is_active = 1',
      whereArgs: [pinCode],
    );

    if (maps.isNotEmpty) {
      final user = UserModel.fromMap(maps.first);
      // حفظ الجلسة في Secure Storage
      await secureStorage.write(key: 'current_user', value: jsonEncode(user.toMap()));
      return user;
    }
    return null;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userData = await secureStorage.read(key: 'current_user');
    if (userData != null) {
      final map = jsonDecode(userData) as Map<String, dynamic>;
      return UserModel.fromMap(map);
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await secureStorage.delete(key: 'current_user');
  }

  // ==========================================
  // عمليات إدارة المستخدمين (User Management)
  // ==========================================
  @override
  Future<List<UserEntity>> getUsers() async {
    final db = await databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'is_active = 1',
    );
    return maps.map((e) => UserModel.fromMap(e)).toList();
  }

  @override
  Future<UserEntity> saveUser(UserEntity user) async {
    final db = await databaseService.database;
    final model = UserModel(
      id: user.id,
      name: user.name,
      pinCode: user.pinCode,
      role: user.role,
      isActive: user.isActive,
    );

    if (model.id == 0) {
      final id = await db.insert('users', model.toMap());
      return UserModel(
        id: id,
        name: model.name,
        pinCode: model.pinCode,
        role: model.role,
        isActive: model.isActive,
      );
    } else {
      await db.update('users', model.toMap(), where: 'id = ?', whereArgs: [model.id]);
      return model;
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    final db = await databaseService.database;
    // الحذف المنطقي لمنع كسر فواتير أو ورديات مسجلة باسم المستخدم
    await db.update('users', {'is_active': 0}, where: 'id = ?', whereArgs: [id]);
  }
}