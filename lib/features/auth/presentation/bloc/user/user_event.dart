import 'package:boon_pos_lite/features/auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUsersEvent extends UserEvent {}

class SaveUserEvent extends UserEvent {
  final UserEntity user;

  const SaveUserEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class DeleteUserEvent extends UserEvent {
  final int id;

  const DeleteUserEvent({required this.id});

  @override
  List<Object> get props => [id];
}