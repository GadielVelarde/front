import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  static const String _tokenKey = 'auth_token';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  @override
  Future<void> onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) async {
    // Endpoints que NO requieren autenticación
    final publicEndpoints = [
      '/auth/login',
      '/auth/register',
    ];

    final isPublicEndpoint = publicEndpoints.any((final endpoint) => 
      options.path.contains(endpoint)
    );

    if (!isPublicEndpoint) {
      try {
        final token = await _secureStorage.read(key: _tokenKey);
        
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      } catch (e) {
        // Si hay error al leer el token, continuar sin él
      }
    }
    
    handler.next(options);
  }

  @override
  void onError(final DioException err, final ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Aquí podrías agregar lógica para limpiar el token y redirigir al login
    }
    handler.next(err);
  }
}
