import 'package:dio/dio.dart';

class CacheInterceptor extends Interceptor {
  final Map<String, CachedResponse> _cache = {};
  final Duration cacheDuration;
  final List<String> cacheablePaths;

  CacheInterceptor({
    this.cacheDuration = const Duration(minutes: 5),
    this.cacheablePaths = const [
      '/socios/me',
      '/creditos',
      // NO cachear /routes para siempre obtener datos frescos
    ],
  });

  @override
  Future<void> onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) async {
    // Solo cachear GET requests
    if (options.method.toUpperCase() != 'GET') {
      return handler.next(options);
    }

    // Verificar si la ruta es cacheable
    final isCacheable = cacheablePaths.any((final path) => options.path.contains(path));
    if (!isCacheable) {
      return handler.next(options);
    }

    final cacheKey = _generateCacheKey(options);
    final cachedResponse = _cache[cacheKey];

    if (cachedResponse != null && !cachedResponse.isExpired) {
      // Retornar respuesta cacheada
      return handler.resolve(
        Response(
          requestOptions: options,
          data: cachedResponse.data,
          statusCode: 200,
          headers: Headers.fromMap({
            'x-cache': ['HIT'],
          }),
        ),
      );
    }

    // Si no hay cache válido, continuar con la petición
    return handler.next(options);
  }

  @override
  void onResponse(final Response<dynamic> response, final ResponseInterceptorHandler handler) {
    // Solo cachear respuestas exitosas de GET
    if (response.requestOptions.method.toUpperCase() == 'GET' &&
        response.statusCode == 200) {
      final isCacheable = cacheablePaths.any(
        (final path) => response.requestOptions.path.contains(path),
      );

      if (isCacheable) {
        final cacheKey = _generateCacheKey(response.requestOptions);
        _cache[cacheKey] = CachedResponse(
          data: response.data,
          timestamp: DateTime.now(),
          duration: cacheDuration,
        );
      }
    }

    return handler.next(response);
  }

  @override
  void onError(final DioException err, final ErrorInterceptorHandler handler) {
    // En caso de error, intentar retornar cache aunque esté expirado
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      final cacheKey = _generateCacheKey(err.requestOptions);
      final cachedResponse = _cache[cacheKey];

      if (cachedResponse != null) {
        return handler.resolve(
          Response(
            requestOptions: err.requestOptions,
            data: cachedResponse.data,
            statusCode: 200,
            headers: Headers.fromMap({
              'x-cache': ['STALE'],
            }),
          ),
        );
      }
    }

    return handler.next(err);
  }

  String _generateCacheKey(final RequestOptions options) {
    // Incluir método, path y query parameters en la clave
    return '${options.method}:${options.path}:${options.queryParameters.toString()}';
  }

  void clearCache() {
    _cache.clear();
  }

  void removeCacheForPath(final String path) {
    _cache.removeWhere((final key, final value) => key.contains(path));
  }
}

class CachedResponse {
  final dynamic data;
  final DateTime timestamp;
  final Duration duration;

  CachedResponse({
    required this.data,
    required this.timestamp,
    required this.duration,
  });

  bool get isExpired {
    return DateTime.now().difference(timestamp) > duration;
  }
}
