import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:djembe_bank_mobile/core/network/api_client.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:djembe_bank_mobile/core/services/secure_storage_service.dart';
import 'package:djembe_bank_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:djembe_bank_mobile/features/auth/domain/repositories/auth_repository.dart';

import 'package:djembe_bank_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:djembe_bank_mobile/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:djembe_bank_mobile/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:djembe_bank_mobile/features/dashboard/domain/repositories/dashboard_repository_mock.dart';

final getIt = GetIt.instance;

void configureDependencies({bool useMocks = false}) {
  // Services de base
  getIt.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
  getIt.registerLazySingleton<SecureStorageService>(() => SecureStorageService());

  // Client API (avec intercepteur tenant + token)
  final apiClient = ApiClient(
    storage: getIt<SecureStorageService>(),
    baseUrl: ApiClient.baseUrlEmulator,
  );
  getIt.registerSingleton<ApiClient>(apiClient);
  getIt.registerSingleton<Dio>(apiClient.dio);

  // Repositories
  if (useMocks) {
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        getIt<ApiClient>(),
        getIt<SecureStorageService>(),
      ));
  getIt.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryMock());
  } else {
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        getIt<ApiClient>(),
        getIt<SecureStorageService>(),
      ));
  // Pour le moment, on utilise le mock pour le dashboard car les endpoints ne sont pas encore implémentés
  getIt.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryMock());
  }

  // Cubits
  getIt.registerLazySingleton<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()));
  getIt.registerFactory<DashboardCubit>(() => DashboardCubit(getIt<DashboardRepository>()));
}