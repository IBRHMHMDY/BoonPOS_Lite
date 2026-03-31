import 'package:equatable/equatable.dart';

abstract class LicenseState extends Equatable {
  const LicenseState();
  
  @override
  List<Object?> get props => [];
}

class LicenseInitial extends LicenseState {}

class LicenseLoading extends LicenseState {}

class LicenseValid extends LicenseState {}

class LicenseInvalid extends LicenseState {
  final String deviceId;

  const LicenseInvalid({required this.deviceId});

  @override
  List<Object> get props => [deviceId];
}

class LicenseError extends LicenseState {
  final String message;
  final String? deviceId;

  const LicenseError({required this.message, this.deviceId});

  @override
  List<Object?> get props => [message, deviceId];
}