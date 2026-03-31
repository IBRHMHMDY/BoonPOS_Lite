import 'package:boon_pos_lite/core/usecases/usecase.dart';

import '../repositories/license_repository.dart';

class ActivateLicenseUseCase implements UseCase<bool, String> {
  final LicenseRepository repository;

  ActivateLicenseUseCase(this.repository);

  @override
  Future<bool> call(String licenseKey) async {
    return await repository.activateLicense(licenseKey);
  }
}