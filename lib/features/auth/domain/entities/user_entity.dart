import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String pinCode;
  final String role; // 'admin' or 'cashier'
  final int isActive;

  const UserEntity({
    required this.id,
    required this.name,
    required this.pinCode,
    required this.role,
    required this.isActive,
  });

  bool get active => isActive == 1;
  bool get isAdmin => role == 'admin';

  @override
  List<Object?> get props => [id, name, pinCode, role, isActive];
}