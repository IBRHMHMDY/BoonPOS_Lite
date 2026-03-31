import 'package:boon_pos_lite/core/database/database_service.dart';
import 'package:boon_pos_lite/features/license/data/repositories/license_repository_impl.dart';
import 'package:boon_pos_lite/features/license/domain/repositories/license_repository.dart';
import 'package:boon_pos_lite/features/license/presentation/bloc/license_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


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

  // ! Features - License
  sl.registerLazySingleton<LicenseRepository>(
    () => LicenseRepositoryImpl(secureStorage: sl()),
  );
  sl.registerFactory(() => LicenseBloc(repository: sl()));

  // سيتم إضافة الـ Repositories والـ Blocs هنا في الخطوات القادمة
}