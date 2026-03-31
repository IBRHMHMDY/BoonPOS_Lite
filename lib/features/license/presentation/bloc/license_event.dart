import 'package:equatable/equatable.dart';

abstract class LicenseEvent extends Equatable {
  const LicenseEvent();

  @override
  List<Object> get props => [];
}

class CheckLicenseEvent extends LicenseEvent {}

class ActivateLicenseEvent extends LicenseEvent {
  final String licenseKey;

  const ActivateLicenseEvent({required this.licenseKey});

  @override
  List<Object> get props => [licenseKey];
}