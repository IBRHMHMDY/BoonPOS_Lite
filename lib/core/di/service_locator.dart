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

// ==========================================
// Menu Feature
// ==========================================
import '../../features/menu/domain/repositories/menu_repository.dart';
import '../../features/menu/domain/usecases/get_categories.dart';
import '../../features/menu/domain/usecases/save_category.dart';
import '../../features/menu/domain/usecases/delete_category.dart';
import '../../features/menu/domain/usecases/get_products.dart';
import '../../features/menu/domain/usecases/save_product.dart';
import '../../features/menu/domain/usecases/delete_product.dart';
import '../../features/menu/domain/usecases/get_modifiers.dart';
import '../../features/menu/domain/usecases/save_modifier.dart';
import '../../features/menu/domain/usecases/delete_modifier.dart';
import '../../features/menu/data/repositories/menu_repository_impl.dart';
import '../../features/menu/data/datasources/menu_local_data_source.dart';
import '../../features/menu/data/datasources/menu_local_data_source_impl.dart';
import '../../features/menu/presentation/bloc/category/category_bloc.dart';
import '../../features/menu/presentation/bloc/product/product_bloc.dart';
import '../../features/menu/presentation/bloc/modifier/modifier_bloc.dart';
// POS
import '../../features/pos/domain/repositories/pos_repository.dart';
import '../../features/pos/data/repositories/pos_repository_impl.dart';
import '../../features/pos/data/datasources/pos_local_data_source.dart';
import '../../features/pos/data/datasources/pos_local_data_source_impl.dart';
import '../../features/pos/domain/usecases/get_next_order_number.dart';
import '../../features/pos/domain/usecases/save_order.dart';


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


  // ! Features - Menu
  sl.registerLazySingleton<MenuLocalDataSource>(
    () => MenuLocalDataSourceImpl(databaseService: sl()),
  );
  // Repository
  sl.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(localDataSource: sl()),
  );
  
  // UseCases - Categories
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => SaveCategoryUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCategoryUseCase(sl()));
  
  // UseCases - Products
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => SaveProductUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProductUseCase(sl()));
  
  // UseCases - Modifiers
  sl.registerLazySingleton(() => GetModifiersUseCase(sl()));
  sl.registerLazySingleton(() => SaveModifierUseCase(sl()));
  sl.registerLazySingleton(() => DeleteModifierUseCase(sl()));
  // Blocs - Menu
  sl.registerFactory(() => CategoryBloc(
    getCategories: sl(),
    saveCategory: sl(),
    deleteCategory: sl(),
  ));

  sl.registerFactory(() => ProductBloc(
    getProducts: sl(),
    saveProduct: sl(),
    deleteProduct: sl(),
  ));

  sl.registerFactory(() => ModifierBloc(
    getModifiers: sl(),
    saveModifier: sl(),
    deleteModifier: sl(),
  ));

  // ! Features - POS Engine
  // DataSource
  sl.registerLazySingleton<PosLocalDataSource>(
    () => PosLocalDataSourceImpl(databaseService: sl()),
  );

  // Repository
  sl.registerLazySingleton<PosRepository>(
    () => PosRepositoryImpl(localDataSource: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetNextOrderNumberUseCase(sl()));
  sl.registerLazySingleton(() => SaveOrderUseCase(sl()));
}