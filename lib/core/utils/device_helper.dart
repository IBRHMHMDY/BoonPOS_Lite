import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceHelper {
  static Future<String> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    
    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        // نستخدم الـ id كمعرف فريد للجهاز
        return androidInfo.id; 
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? 'UNKNOWN_IOS_ID';
      }
    } catch (e) {
      return 'ERROR_FETCHING_ID';
    }
    
    return 'UNKNOWN_DEVICE_ID';
  }
}