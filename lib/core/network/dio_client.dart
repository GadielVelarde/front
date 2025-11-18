import 'package:dio/dio.dart';
import '../../config/app_config.dart';
import 'auth_interceptor.dart';
import 'cache_interceptor.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(AuthInterceptor());

    dio.interceptors.add(CacheInterceptor(
      cacheDuration: const Duration(minutes: 5),
      cacheablePaths: [
        '/socios/me',
        '/socios/',
        '/creditos',
      ],
    ));

    // Interceptor de logs
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
    ));
  }
}