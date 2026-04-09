import 'package:dio/dio.dart';
import 'package:djembe_bank_mobile/features/dashboard/data/repositories/dashboard_repository_mock.dart';
import 'package:djembe_bank_mobile/features/profile/data/repositories/profile_repository_mock.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:djembe_bank_mobile/core/network/api_client.dart';
import 'package:djembe_bank_mobile/core/services/secure_storage_service.dart';
import 'package:djembe_bank_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:djembe_bank_mobile/features/cards/presentation/cubit/cards_cubit.dart';
import 'package:djembe_bank_mobile/features/budget/presentation/cubit/budget_cubit.dart';
import 'package:djembe_bank_mobile/features/circle/presentation/cubit/circle_cubit.dart';
import 'package:djembe_bank_mobile/features/profile/presentation/cubit/profile_cubit.dart';

import 'package:djembe_bank_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:djembe_bank_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:djembe_bank_mobile/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:djembe_bank_mobile/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:djembe_bank_mobile/features/cards/domain/repositories/cards_repository.dart';
import 'package:djembe_bank_mobile/features/cards/data/repositories/cards_repository_mock.dart';
import 'package:djembe_bank_mobile/features/budget/domain/repositories/budget_repository.dart';
import 'package:djembe_bank_mobile/features/budget/data/repositories/budget_repository_mock.dart';
import 'package:djembe_bank_mobile/features/circle/domain/repositories/circle_repository.dart';
import 'package:djembe_bank_mobile/features/circle/data/repositories/circle_repository_mock.dart';
import 'package:djembe_bank_mobile/features/profile/domain/repositories/profile_repository.dart';
import 'package:djembe_bank_mobile/features/profile/data/repositories/profile_repository_impl.dart';

import 'package:djembe_bank_mobile/features/dashboard/presentation/cubit/dashboard_cubit.dart';

final getIt = GetIt.instance;

void configureDependencies({bool useMocks = false}) {
  // Services de base
  getIt.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
  getIt.registerLazySingleton<SecureStorageService>(() => SecureStorageService());

  // Client API
  final apiClient = ApiClient(
    storage: getIt<SecureStorageService>(),
    baseUrl: ApiClient.baseUrlEmulator,
  );
  getIt.registerSingleton<ApiClient>(apiClient);
  getIt.registerSingleton<Dio>(apiClient.dio);

  // Repositories
  if (useMocks) {
    // Mode mock : tout est mocké
    getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
          getIt<ApiClient>(),
          getIt<SecureStorageService>(),
        ));
    getIt.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryMock());
    getIt.registerLazySingleton<CardsRepository>(() => CardsRepositoryMock());
    getIt.registerLazySingleton<BudgetRepository>(() => BudgetRepositoryMock());
    getIt.registerLazySingleton<CircleRepository>(() => CircleRepositoryMock());
    getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryMock());
  } else {
    // Mode réel : on utilise les implémentations réelles pour les endpoints disponibles
    getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
          getIt<ApiClient>(),
          getIt<SecureStorageService>(),
        ));
    // Dashboard : endpoints /accounts et /transactions existent
    getIt.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(getIt<ApiClient>()));
    // Profil : endpoint /auth/me existe
    getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(getIt<ApiClient>()));
    // Cartes, Budget, Cercle : endpoints non encore exposés, on garde les mocks
    getIt.registerLazySingleton<CardsRepository>(() => CardsRepositoryMock());
    getIt.registerLazySingleton<BudgetRepository>(() => BudgetRepositoryMock());
    getIt.registerLazySingleton<CircleRepository>(() => CircleRepositoryMock());
  }

  // Cubits (enregistrement commun, quel que soit le mode)
  getIt.registerLazySingleton<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()));
  getIt.registerFactory<DashboardCubit>(() => DashboardCubit(getIt<DashboardRepository>()));
  getIt.registerFactory<CardsCubit>(() => CardsCubit(getIt<CardsRepository>()));
  getIt.registerFactory<BudgetCubit>(() => BudgetCubit(getIt<BudgetRepository>()));
  getIt.registerFactory<CircleCubit>(() => CircleCubit(getIt<CircleRepository>()));
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(getIt<ProfileRepository>()));
}