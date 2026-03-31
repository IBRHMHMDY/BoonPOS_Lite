import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String pinCode;
  final String role;
  final int isActive;

  const UserEntity({
    required this.id,
    required this.name,
    required this.pinCode,
    required this.role,
    required this.isActive,
  });

  // مساعدة برمجية (Helper) لمعرفة إذا كان المستخدم مديراً
  bool get isAdmin => role == 'admin';

  @override
  List<Object?> get props => [id, name, pinCode, role, isActive];
}