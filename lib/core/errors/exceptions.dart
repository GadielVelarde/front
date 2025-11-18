class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AppException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}
class AuthException extends AppException {
  AuthException({
    required super.message,
    super.code,
    super.originalError,
  });

  factory AuthException.invalidCredentials() => AuthException(
        message: 'Usuario o contraseña incorrectos',
        code: 'AUTH_INVALID_CREDENTIALS',
      );

  factory AuthException.sessionExpired() => AuthException(
        message: 'Sesión expirada',
        code: 'AUTH_SESSION_EXPIRED',
      );

  factory AuthException.unauthorized() => AuthException(
        message: 'No autorizado',
        code: 'AUTH_UNAUTHORIZED',
      );

  factory AuthException.userNotFound() => AuthException(
        message: 'Usuario no encontrado',
        code: 'AUTH_USER_NOT_FOUND',
      );
  factory AuthException.serverError() => AuthException(
        message: 'Error del servidor',
        code: 'AUTH_ERROR_SERVER',
      );
}
class NetworkException extends AppException {
  NetworkException({
    required super.message,
    super.code,
    super.originalError,
  });

  factory NetworkException.noConnection() => NetworkException(
        message: 'Sin conexión a internet',
        code: 'NETWORK_NO_CONNECTION',
      );

  factory NetworkException.timeout() => NetworkException(
        message: 'Tiempo de espera agotado',
        code: 'NETWORK_TIMEOUT',
      );

  factory NetworkException.serverError([final int? statusCode]) => NetworkException(
        message: 'Error del servidor${statusCode != null ? ' (código $statusCode)' : ''}',
        code: 'NETWORK_SERVER_ERROR',
      );

  factory NetworkException.badRequest() => NetworkException(
        message: 'Solicitud incorrecta',
        code: 'NETWORK_BAD_REQUEST',
      );
}
class CacheException extends AppException {
  CacheException({
    required super.message,
    super.code,
    super.originalError,
  });

  factory CacheException.notFound() => CacheException(
        message: 'Datos no encontrados en cache',
        code: 'CACHE_NOT_FOUND',
      );

  factory CacheException.writeError() => CacheException(
        message: 'Error al escribir en cache',
        code: 'CACHE_WRITE_ERROR',
      );

  factory CacheException.readError() => CacheException(
        message: 'Error al leer del cache',
        code: 'CACHE_READ_ERROR',
      );
}
class ValidationException extends AppException {
  ValidationException({
    required super.message,
    super.code,
    super.originalError,
  });

  factory ValidationException.invalidEmail() => ValidationException(
        message: 'Email inválido',
        code: 'VALIDATION_INVALID_EMAIL',
      );

  factory ValidationException.emptyField(final String fieldName) => ValidationException(
        message: 'El campo $fieldName es requerido',
        code: 'VALIDATION_EMPTY_FIELD',
      );

  factory ValidationException.invalidFormat(final String fieldName) => ValidationException(
        message: 'Formato inválido para $fieldName',
        code: 'VALIDATION_INVALID_FORMAT',
      );
}
class ServerException extends AppException {
  ServerException({
    required super.message,
    super.code,
    super.originalError,
  });

  factory ServerException.internalError() => ServerException(
        message: 'Error interno del servidor',
        code: 'SERVER_INTERNAL_ERROR',
      );

  factory ServerException.maintenance() => ServerException(
        message: 'Servidor en mantenimiento',
        code: 'SERVER_MAINTENANCE',
      );
}
