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
      id: map['id'],
      name: map['name'],
      pinCode: map['pin_code'],
      role: map['role'],
      isActive: map['is_active'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pin_code': pinCode,
      'role': role,
      'is_active': isActive,
    };
  }
}