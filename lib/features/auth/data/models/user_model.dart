import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.pinCode,
    required super.role,
    required super.isActive,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      name: map['name'] as String,
      pinCode: map['pin_code'] as String,
      role: map['role'] as String,
      isActive: map['is_active'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'pin_code': pinCode,
      'role': role,
      'is_active': isActive,
    };
    if (id != 0) {
      map['id'] = id;
    }
    return map;
  }
}