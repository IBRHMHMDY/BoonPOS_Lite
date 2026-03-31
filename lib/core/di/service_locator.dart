import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! Core - Secure Storage
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // سيتم إضافة تهيئة قاعدة البيانات والـ Repositories والـ Blocs تباعاً في الخطوات القادمة
}