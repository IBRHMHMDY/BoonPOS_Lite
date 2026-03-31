import 'dart:convert';
import 'package:crypto/crypto.dart';

class LicenseValidator {
  // ⚠️ هذا المفتاح السري يجب أن يطابق تماماً المفتاح في تطبيق الـ Activator
  static const String _appSecret = "YOUR_SUPER_SECURE_OBFUSCATED_SECRET_KEY_2026";

  static bool isValid(String licenseKey, String currentDeviceId) {
    try {
      final List<String> parts = licenseKey.split('.');
      if (parts.length != 2) return false;

      final String payloadBase64 = parts[0];
      final String signature = parts[1];

      // 1. التحقق من صحة التوقيع الرقمي (Signature) باستخدام HMAC-SHA256
      final List<int> key = utf8.encode(_appSecret);
      final List<int> bytes = utf8.encode(payloadBase64);
      final Hmac hmacSha256 = Hmac(sha256, key);
      final Digest digest = hmacSha256.convert(bytes);
      final String expectedSignature = base64Url.encode(digest.bytes);

      if (signature != expectedSignature) return false; // تم التلاعب بالرخصة

      // 2. فك تشفير الـ Payload والتحقق من البيانات
      final String payloadStr = utf8.decode(base64Url.decode(payloadBase64));
      final Map<String, dynamic> payload = json.decode(payloadStr);

      final String licenseDeviceId = payload['device_id'];
      final String expiryDateStr = payload['expiry_date'];
      final DateTime expiryDate = DateTime.parse(expiryDateStr);

      // 3. مطابقة المعرف وتاريخ الصلاحية
      if (licenseDeviceId != currentDeviceId) return false; // رخصة لجهاز آخر
      if (DateTime.now().isAfter(expiryDate)) return false; // رخصة منتهية الصلاحية

      return true; // الرخصة سليمة وفعالة
    } catch (e) {
      return false;
    }
  }
}