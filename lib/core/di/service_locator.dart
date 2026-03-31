import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../database/database_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! Core - Secure Storage
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // ! Core - Local Database
  final databaseService = DatabaseService();
  await databaseService.database; // التأكد من تهيئة الجداول عند بدء التطبيق
  sl.registerLazySingleton<DatabaseService>(() => databaseService);

  // سيتم إضافة الـ Repositories والـ Blocs هنا في الخطوات القادمة
}