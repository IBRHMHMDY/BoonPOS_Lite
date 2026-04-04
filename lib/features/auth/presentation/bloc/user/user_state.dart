import 'package:boon_pos_lite/features/auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<UserEntity> users;

  const UsersLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

class UserActionSuccess extends UserState {
  final String message;

  const UserActionSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object> get props => [message];
}