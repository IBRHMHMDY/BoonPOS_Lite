import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/repositories/license_repository.dart';
import '../../../../core/utils/device_helper.dart';
import '../../../../core/utils/license_validator.dart';

class LicenseRepositoryImpl implements LicenseRepository {
  final FlutterSecureStorage secureStorage;
  static const String _licenseKeyName = 'pos_lite_license_key';

  LicenseRepositoryImpl({required this.secureStorage});

  @override
  Future<bool> isLicenseValid() async {
    final String? storedKey = await secureStorage.read(key: _licenseKeyName);
    if (storedKey == null) return false;

    final String deviceId = await DeviceHelper.getDeviceId();
    return LicenseValidator.isValid(storedKey, deviceId);
  }

  @override
  Future<bool> activateLicense(String licenseKey) async {
    final String deviceId = await DeviceHelper.getDeviceId();
    final bool isValid = LicenseValidator.isValid(licenseKey, deviceId);
    
    if (isValid) {
      await secureStorage.write(key: _licenseKeyName, value: licenseKey);
      return true;
    }
    return false;
  }
}