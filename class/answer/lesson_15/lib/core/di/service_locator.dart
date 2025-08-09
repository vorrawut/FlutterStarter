import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/local/auth_local_storage.dart';
import '../../data/datasources/local/theme_local_storage.dart';
import '../../data/datasources/local/preferences_local_storage.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/theme_repository_impl.dart';
import '../../data/repositories/preferences_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/theme_repository.dart';
import '../../domain/repositories/user_preferences_repository.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../services/analytics_service.dart';
import '../services/biometric_service.dart';
import '../services/notification_service.dart';
import '../services/security_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  await Hive.openBox('auth');
  await Hive.openBox('theme');
  await Hive.openBox('preferences');

  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Core services
  getIt.registerLazySingleton<SecurityService>(() => SecurityServiceImpl());
  getIt.registerLazySingleton<BiometricService>(() => BiometricServiceImpl());
  getIt.registerLazySingleton<AnalyticsService>(() => AnalyticsServiceImpl());
  getIt.registerLazySingleton<NotificationService>(() => NotificationServiceImpl());

  // Data sources
  getIt.registerLazySingleton<AuthLocalStorage>(
    () => AuthLocalStorageImpl(Hive.box('auth')),
  );
  getIt.registerLazySingleton<ThemeLocalStorage>(
    () => ThemeLocalStorageImpl(Hive.box('theme')),
  );
  getIt.registerLazySingleton<PreferencesLocalStorage>(
    () => PreferencesLocalStorageImpl(Hive.box('preferences')),
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localStorage: getIt<AuthLocalStorage>(),
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      securityService: getIt<SecurityService>(),
    ),
  );
  getIt.registerLazySingleton<ThemeRepository>(
    () => ThemeRepositoryImpl(
      localStorage: getIt<ThemeLocalStorage>(),
    ),
  );
  getIt.registerLazySingleton<UserPreferencesRepository>(
    () => UserPreferencesRepositoryImpl(
      localStorage: getIt<PreferencesLocalStorage>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      repository: getIt<AuthRepository>(),
      securityService: getIt<SecurityService>(),
      analyticsService: getIt<AnalyticsService>(),
    ),
  );
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(
      repository: getIt<AuthRepository>(),
      securityService: getIt<SecurityService>(),
      analyticsService: getIt<AnalyticsService>(),
    ),
  );
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(
      repository: getIt<AuthRepository>(),
      securityService: getIt<SecurityService>(),
      analyticsService: getIt<AnalyticsService>(),
    ),
  );
}
