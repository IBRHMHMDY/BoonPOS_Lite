abstract class LicenseRepository {
  Future<bool> isLicenseValid();
  Future<bool> activateLicense(String licenseKey);
}