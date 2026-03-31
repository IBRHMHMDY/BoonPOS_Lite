import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Database
import '../database/database_service.dart';

// License Feature
import '../../features/license/domain/repositories/license_repository.dart';
import '../../features/license/data/repositories/license_repository_impl.dart';
import '../../features/license/domain/usecases/check_license.dart';
import '../../features/license/domain/usecases/activate_license.dart';
import '../../features/license/presentation/bloc/license_bloc.dart';

// Auth Feature
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/login_with_pin.dart';
import '../../features/auth/domain/usecases/logout.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// Shift Feature
import '../../features/shift/domain/repositories/shift_repository.dart';
import '../../features/shift/data/repositories/shift_repository_impl.dart';
import '../../features/shift/domain/usecases/get_active_shift.dart';
import '../../features/shift/domain/usecases/open_shift.dart';
import '../../features/shift/presentation/bloc/shift_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! Core
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  final databaseService = DatabaseService();
  await databaseService.database; 
  sl.registerLazySingleton<DatabaseService>(() => databaseService);

  // ==========================================
  // ! Features - License
  // ==========================================
  // Repository
  sl.registerLazySingleton<LicenseRepository>(
    () => LicenseRepositoryImpl(secureStorage: sl()),
  );
  // UseCases
  sl.registerLazySingleton(() => CheckLicenseUseCase(sl()));
  sl.registerLazySingleton(() => ActivateLicenseUseCase(sl()));
  // Bloc
  sl.registerFactory(() => LicenseBloc(
    checkLicense: sl(),
    activateLicense: sl(),
  ));

  // ==========================================
  // ! Features - Auth
  // ==========================================
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(databaseService: sl(), secureStorage: sl()),
  );
  // UseCases
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => LoginWithPinUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  // Bloc
  sl.registerFactory(() => AuthBloc(
    getCurrentUser: sl(),
    loginWithPin: sl(),
    logout: sl(),
  ));

  // ==========================================
  // ! Features - Shift
  // ==========================================
  // Repository
  sl.registerLazySingleton<ShiftRepository>(
    () => ShiftRepositoryImpl(databaseService: sl()),
  );
  // UseCases
  sl.registerLazySingleton(() => GetActiveShiftUseCase(sl()));
  sl.registerLazySingleton(() => OpenShiftUseCase(sl()));
  // Bloc
  sl.registerFactory(() => ShiftBloc(
    getActiveShift: sl(),
    openShift: sl(),
  ));
}