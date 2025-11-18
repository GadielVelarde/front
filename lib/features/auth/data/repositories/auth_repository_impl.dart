import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/remote/auth_api_service.dart';
import '../data_sources/local/auth_local_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService apiService;
  final AuthLocalService localService;
  final ConnectivityService connectivityService;

  AuthRepositoryImpl({
    required this.apiService,
    required this.localService,
    required this.connectivityService,
  });

  @override
  Future<Either<Failure, User>> login(final String usuario, final String password) async {
    try {
      final response = await apiService.authenticateUser(usuario, password);
      if (response != null) {
        // Guardar token y usuario
        await localService.saveToken(response.token);
        await localService.saveTokenExpiry(response.tokenExpiry);
        await localService.saveUser(response.user);
        await localService.setAuthenticated(true);

        return Right(response.user);
      }
      return Left(AuthFailure.invalidCredentials());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(
        message: 'Error inesperado al iniciar sesión',
        data: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final token = await localService.getToken();
      if (token != null) {
        await apiService.invalidateToken(token);
      }
      await _clearLocalSession();
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(
        message: 'Error inesperado al cerrar sesión',
        data: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final localUser = await localService.getUser();
      if (localUser != null) {
        return Right(localUser);
      }
      final token = await localService.getToken();
      if (token != null) {
        final apiUser = await apiService.fetchUserData(token);
        if (apiUser != null) {
          await localService.saveUser(apiUser);
          return Right(apiUser);
        }
      }

      return const Left(CacheFailure(message: 'No hay usuario autenticado'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(
        message: 'Error al obtener usuario actual',
        data: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final isAuth = await localService.isAuthenticated();
      if (!isAuth) {
        return const Right(false);
      }

      final tokenExpiry = await localService.getTokenExpiry();
      if (tokenExpiry == null) {
        return const Right(true);
      }

      final hasExpired = DateTime.now().isAfter(tokenExpiry);
      if (!hasExpired) {
        return const Right(true);
      }

      final currentUser = await localService.getUser();
      final isAsesor = currentUser?.authRole.isAsesor ?? false;

      if (isAsesor) {
        final isOnline = await connectivityService.checkConnection();
        if (!isOnline) {
          return const Right(true);
        }
      }

      await _clearLocalSession();
      return const Right(false);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(
        message: 'Error al verificar autenticaci�n',
        data: e.toString(),
      ));
    }
  }

@override
  Future<Either<Failure, String>> refreshToken() async {
    try {
      final oldToken = await localService.getToken();
      if (oldToken == null) {
        return const Left(AuthFailure(message: 'No hay token para refrescar'));
      }

      final newToken = await apiService.refreshAuthToken(oldToken);
      await localService.saveToken(newToken);
      return Right(newToken);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(
        message: 'Error al refrescar token',
        data: e.toString(),
      ));
    }
  }

  Future<void> _clearLocalSession() async {
    await localService.clearUserData();
    await localService.setAuthenticated(false);
  }
}
