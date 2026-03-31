import 'package:boon_pos_lite/core/usecases/usecase.dart';

import '../repositories/license_repository.dart';

class CheckLicenseUseCase implements UseCase<bool, NoParams> {
  final LicenseRepository repository;

  CheckLicenseUseCase(this.repository);

  @override
  Future<bool> call(NoParams params) async {
    return await repository.isLicenseValid();
  }
}