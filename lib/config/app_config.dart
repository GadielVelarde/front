import 'package:flutter_dotenv/flutter_dotenv.dart';
class AppConfig {
  AppConfig._();
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
  }
  static String get appName => dotenv.get('APP_NAME', fallback: 'Norandino App');
  static String get appVersion => dotenv.get('APP_VERSION', fallback: '1.0.0');
  static String get apiBaseUrl => dotenv.get('API_BASE_URL', fallback: 'https://vaf0x3nyll.execute-api.us-east-1.amazonaws.com/');
  
  static String get mapboxAccessToken => dotenv.get('MAPBOX_ACCESS_TOKEN', fallback: '');

  static Duration get apiTimeout => Duration(
        milliseconds: int.parse(dotenv.get('API_TIMEOUT', fallback: '30000')),
      );
  static Duration get sessionTimeout => Duration(
        milliseconds: int.parse(dotenv.get('SESSION_TIMEOUT', fallback: '86400000')),
      );
  static int get maxLoginAttempts => int.parse(
        dotenv.get('MAX_LOGIN_ATTEMPTS', fallback: '3'),
      );
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const String userPreferencesKey = 'user_preferences';
  static const String cacheKey = 'app_cache';
  static bool get enableDebugLogs => dotenv.get('ENABLE_DEBUG_LOGS', fallback: 'true') == 'true';
  static const LogLevel logLevel = LogLevel.info;
  static bool get enableOfflineMode => dotenv.get('ENABLE_OFFLINE_MODE', fallback: 'true') == 'true';
  static bool get enableAnalytics => dotenv.get('ENABLE_ANALYTICS', fallback: 'false') == 'true';
  static bool get enableCrashReporting => dotenv.get('ENABLE_CRASH_REPORTING', fallback: 'true') == 'true';
}

enum LogLevel {
  debug,
  info,
  warning,
  error,
}
