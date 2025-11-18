import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../database/database_helper.dart';
import '../network/connectivity_service.dart';
import '../database/services/offline_request_service.dart';
import '../../features/auth/data/data_sources/local/auth_local_service.dart';
import '../../features/auth/data/data_sources/local/auth_local_service_impl.dart';
import '../../features/auth/data/data_sources/remote/auth_api_service.dart';
import '../../features/auth/data/data_sources/remote/auth_api_service_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/use_cases/auth_use_cases.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/cartera/domain/use_cases/get_socio_detail.dart';
import '../../features/cartera/domain/use_cases/get_socios.dart';
import '../../features/rutas/data/data_sources/remote/rutas_api_service.dart';
import '../../features/rutas/data/data_sources/remote/rutas_api_service_impl.dart';
import '../../features/rutas/data/data_sources/local/rutas_local_data_source.dart';
import '../../features/rutas/data/repositories/rutas_repository_impl.dart';
import '../../features/rutas/domain/repositories/rutas_repository.dart';
import '../../features/rutas/domain/use_cases/rutas_use_cases.dart';
import '../../features/rutas/presentation/bloc/rutas_bloc.dart';
import '../database/services/rutas_sync_service.dart';
import '../../features/seguimientos/data/data_sources/remote/seguimientos_api_service.dart';
import '../../features/seguimientos/data/data_sources/remote/seguimientos_api_service_impl.dart';
import '../../features/seguimientos/data/repositories/seguimientos_repository_impl.dart';
import '../../features/seguimientos/domain/repositories/seguimientos_repository.dart';
import '../../features/seguimientos/domain/use_cases/seguimientos_use_cases.dart';
import '../../features/seguimientos/presentation/bloc/seguimientos_bloc.dart';
import '../../features/cartera/data/data_sources/remote/cartera_api_service.dart';
import '../../features/cartera/data/data_sources/remote/cartera_api_service_impl.dart';
import '../../features/cartera/data/repositories/cartera_repository_impl.dart';
import '../../features/cartera/domain/repositories/cartera_repository.dart';
import '../../features/cartera/domain/use_cases/cartera_use_cases.dart';
import '../../features/cartera/presentation/bloc/cartera_bloc.dart';
import '../../features/cartera/data/repositories/socio_repository_impl.dart';
import '../../features/cartera/domain/repositories/socio_repository.dart';
import '../../features/cartera/presentation/bloc/socio_bloc.dart';
import '../../features/cartera/data/data_sources/remote/socio_api_service.dart';
import '../../features/cartera/data/data_sources/remote/socio_api_service_impl.dart';
import '../../features/cartera/data/data_sources/remote/credito_api_service.dart';
import '../../features/cartera/data/data_sources/remote/credito_api_service_impl.dart';
import '../../features/cartera/data/repositories/credito_repository_impl.dart';
import '../../features/cartera/domain/repositories/credito_repository.dart';
import '../../features/cartera/domain/use_cases/get_creditos_by_socio.dart';
import '../../features/cartera/domain/use_cases/get_credito_detail.dart';
import '../../features/cartera/presentation/bloc/credito_bloc.dart';

final sl = GetIt.instance;

Future<void> initInjections() async {
  // Core - Network
  sl.registerLazySingleton<Dio>(() => DioClient().dio);
  
  // Core - Offline Services (must be initialized before feature injections)
  await initOfflineServices();
  
  await initAuthInjections();
  await initRutasInjections();
  await initSeguimientosInjections();
  await initCarteraInjections();
}

//Offline Services
Future<void> initOfflineServices() async {
  // Database
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  
  // Connectivity
  sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  
  // Offline Request Queue
  sl.registerLazySingleton<OfflineRequestService>(() => OfflineRequestService());
}

//Auth
Future<void> initAuthInjections() async {
  sl.registerLazySingleton<AuthLocalService>(
    () => AuthLocalServiceImpl(),
  );
  sl.registerLazySingleton<AuthApiService>(
    () => AuthApiServiceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      apiService: sl(),
      localService: sl(), 
      connectivityService: sl(),
    ),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      checkAuthStatusUseCase: sl(),
      connectivityService: sl(),
    ),
  );
}
//Rutas
Future<void> initRutasInjections() async {
  // Remote Data Source
  sl.registerLazySingleton<RutasApiService>(
    () => RutasApiServiceImpl(sl<Dio>()),
  );
  
  // Local Data Source
  sl.registerLazySingleton<RutasLocalDataSource>(
    () => RutasLocalDataSource(),
  );
  
  // Sync Service
  sl.registerLazySingleton<RutasSyncService>(
    () => RutasSyncService(
      localDataSource: sl<RutasLocalDataSource>(),
      apiService: sl<RutasApiService>(),
      connectivityService: sl<ConnectivityService>(),
      offlineRequestService: sl<OfflineRequestService>(),
    ),
  );
  
  // Repository (with offline-first support)
  sl.registerLazySingleton<RutasRepository>(
    () => RutasRepositoryImpl(
      apiService: sl<RutasApiService>(),
      localDataSource: sl<RutasLocalDataSource>(),
      connectivityService: sl<ConnectivityService>(),
      syncService: sl<RutasSyncService>(),
    ),
  );
  
  // Use Cases
  sl.registerLazySingleton(() => GetRutasUseCase(sl()));
  sl.registerLazySingleton(() => GetRutaByIdUseCase(sl()));
  sl.registerLazySingleton(() => CreateRutaUseCase(sl()));
  sl.registerLazySingleton(() => UpdateRutaUseCase(sl()));
  sl.registerLazySingleton(() => DeleteRutaUseCase(sl()));
  sl.registerLazySingleton(() => AssignAsesorUseCase(sl()));
  
  // BLoC (with connectivity and sync support)
  sl.registerFactory(
    () => RutasBloc(
      getRutasUseCase: sl(),
      getRutaByIdUseCase: sl(),
      createRutaUseCase: sl(),
      updateRutaUseCase: sl(),
      deleteRutaUseCase: sl(),
      assignAsesorUseCase: sl(),
      connectivityService: sl<ConnectivityService>(),
      syncService: sl<RutasSyncService>(),
    ),
  );
}
//Seguimientos
Future<void> initSeguimientosInjections() async {
  sl.registerLazySingleton<SeguimientosApiService>(
    () => SeguimientosApiServiceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<SeguimientosRepository>(
    () => SeguimientosRepositoryImpl(apiService: sl()),
  );
  sl.registerLazySingleton(() => GetSeguimientosUseCase(sl()));
  sl.registerLazySingleton(() => GetSeguimientoByIdUseCase(sl()));
  sl.registerLazySingleton(() => CompleteSeguimientoUseCase(sl()));
  sl.registerLazySingleton(() => DeleteSeguimientoUseCase(sl()));
  sl.registerFactory(
    () => SeguimientosBloc(
      getSeguimientosUseCase: sl(),
      getSeguimientoByIdUseCase: sl(),
      completeSeguimientoUseCase: sl(),
      deleteSeguimientoUseCase: sl(),
    ),
  );
}
Future<void> initCarteraInjections() async {
  sl.registerLazySingleton<CarteraApiService>(
    () => CarteraApiServiceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<CarteraRepository>(
    () => CarteraRepositoryImpl(apiService: sl()),
  );
  sl.registerLazySingleton(() => GetCarterasUseCase(sl()));
  sl.registerLazySingleton(() => GetCarteraByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetCarterasByAsesorUseCase(sl()));
  sl.registerLazySingleton(() => CreateCarteraUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCarteraUseCase(sl()));
  sl.registerLazySingleton(() => RegistrarPagoUseCase(sl()));
  sl.registerLazySingleton(() => MarcarRequiereVisitaUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCarteraUseCase(sl()));
  sl.registerFactory(
    () => CarteraBloc(
      getCarterasUseCase: sl(),
      getCarteraByIdUseCase: sl(),
      getCarterasByAsesorUseCase: sl(),
      createCarteraUseCase: sl(),
      updateCarteraUseCase: sl(),
      registrarPagoUseCase: sl(),
      marcarRequiereVisitaUseCase: sl(),
      deleteCarteraUseCase: sl(),
    ),
  );

  // Socio
  sl.registerLazySingleton<SocioApiService>(
    () => SocioApiServiceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<SocioRepository>(
    () => SocioRepositoryImpl(apiService: sl()),
  );
  sl.registerLazySingleton(() => GetSocios(sl()));
  sl.registerLazySingleton(() => GetSocioDetail(sl()));
  sl.registerFactory(
    () => SocioBloc(
      getSociosUseCase: sl(),
      getSocioDetailUseCase: sl(),
    ),
  );

  // Credito
  sl.registerLazySingleton<CreditoApiService>(
    () => CreditoApiServiceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<CreditoRepository>(
    () => CreditoRepositoryImpl(apiService: sl()),
  );
  sl.registerLazySingleton(() => GetCreditosBySocio(sl()));
  sl.registerLazySingleton(() => GetCreditoDetail(sl()));
  sl.registerFactory(
    () => CreditoBloc(
      getCreditosBySocioUseCase: sl(),
      getCreditoDetailUseCase: sl(),
    ),
  );
}
