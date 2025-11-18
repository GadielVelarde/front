import 'package:equatable/equatable.dart';
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic data;

  const Failure({
    required this.message,
    this.code,
    this.data,
  });

  @override
  List<Object?> get props => [message, code, data];
}
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
    super.data,
  });

  factory AuthFailure.invalidCredentials() => const AuthFailure(
        message: 'Email o contraseña incorrectos',
        code: 'AUTH_INVALID_CREDENTIALS',
      );

  factory AuthFailure.sessionExpired() => const AuthFailure(
        message: 'Tu sesión ha expirado. Por favor, inicia sesión nuevamente',
        code: 'AUTH_SESSION_EXPIRED',
      );

  factory AuthFailure.unauthorized() => const AuthFailure(
        message: 'No tienes autorización para realizar esta acción',
        code: 'AUTH_UNAUTHORIZED',
      );

  factory AuthFailure.userNotFound() => const AuthFailure(
        message: 'Usuario no encontrado',
        code: 'AUTH_USER_NOT_FOUND',
      );
}
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.data,
  });

  factory NetworkFailure.noConnection() => const NetworkFailure(
        message: 'No hay conexión a internet',
        code: 'NETWORK_NO_CONNECTION',
      );

  factory NetworkFailure.timeout() => const NetworkFailure(
        message: 'La solicitud ha tardado demasiado. Intenta nuevamente',
        code: 'NETWORK_TIMEOUT',
      );

  factory NetworkFailure.serverError() => const NetworkFailure(
        message: 'Error en el servidor. Intenta más tarde',
        code: 'NETWORK_SERVER_ERROR',
      );
}
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
    super.data,
  });

  factory CacheFailure.readError() => const CacheFailure(
        message: 'Error al leer datos locales',
        code: 'CACHE_READ_ERROR',
      );

  factory CacheFailure.writeError() => const CacheFailure(
        message: 'Error al guardar datos locales',
        code: 'CACHE_WRITE_ERROR',
      );
}
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.data,
  });

  factory ValidationFailure.invalidEmail() => const ValidationFailure(
        message: 'El email no es válido',
        code: 'VALIDATION_INVALID_EMAIL',
      );

  factory ValidationFailure.emptyField(final String fieldName) => ValidationFailure(
        message: 'El campo $fieldName no puede estar vacío',
        code: 'VALIDATION_EMPTY_FIELD',
        data: fieldName,
      );
}
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.data,
  });
}
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'Ha ocurrido un error inesperado',
    super.code,
    super.data,
  });
}
