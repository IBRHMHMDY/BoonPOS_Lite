import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthSessionEvent extends AuthEvent {}

class LoginWithPinEvent extends AuthEvent {
  final String pinCode;

  const LoginWithPinEvent({required this.pinCode});

  @override
  List<Object> get props => [pinCode];
}

class LogoutEvent extends AuthEvent {}