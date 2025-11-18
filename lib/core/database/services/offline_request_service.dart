import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../models/offline_request_model.dart';

/// Servicio para gestionar solicitudes de red fallidas en modo offline
/// Guarda las solicitudes localmente y las reintenta cuando hay conexión
class OfflineRequestService {
  static final OfflineRequestService _instance = OfflineRequestService._internal();
  factory OfflineRequestService() => _instance;
  OfflineRequestService._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  static const String _tableName = 'offline_requests';
  static const int _maxRetries = 3;

  /// Guarda una solicitud offline para reintentarla después
  Future<void> saveRequest(final OfflineRequestModel request) async {
    try {
      final db = await _databaseHelper.database;
      await db.insert(
        _tableName,
        request.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Failed to save offline request: $e');
    }
  }

  /// Obtiene todas las solicitudes pendientes de enviar
  Future<List<OfflineRequestModel>> getPendingRequests() async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'status = ?',
        whereArgs: ['waiting'],
        orderBy: 'created_at ASC',
      );

      return maps.map((final map) => OfflineRequestModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get pending requests: $e');
    }
  }

  /// Obtiene todas las solicitudes (para debugging/UI)
  Future<List<OfflineRequestModel>> getAllRequests() async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        orderBy: 'created_at DESC',
      );

      return maps.map((final map) => OfflineRequestModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get all requests: $e');
    }
  }

  /// Intenta enviar una solicitud específica
  Future<bool> sendRequest(final OfflineRequestModel request, final Dio dio) async {
    try {
      // Preparar opciones
      final options = Options(
        method: request.method,
        headers: request.headers,
      );

      // Realizar la solicitud
      Response<dynamic> response;
      switch (request.method.toUpperCase()) {
        case 'GET':
          response = await dio.get(request.url, options: options);
          break;
        case 'POST':
          response = await dio.post(
            request.url,
            data: request.body,
            options: options,
          );
          break;
        case 'PUT':
          response = await dio.put(
            request.url,
            data: request.body,
            options: options,
          );
          break;
        case 'DELETE':
          response = await dio.delete(request.url, options: options);
          break;
        default:
          throw Exception('Unsupported HTTP method: ${request.method}');
      }

      // Si la solicitud fue exitosa
      if (response.statusCode != null && 
          response.statusCode! >= 200 && 
          response.statusCode! < 300) {
        await _updateRequestStatus(request.id!, 'success');
        return true;
      } else {
        await _updateRequestStatus(
          request.id!,
          'failed',
          errorMessage: 'HTTP ${response.statusCode}: ${response.statusMessage}',
        );
        return false;
      }
    } catch (e) {
      // Incrementar contador de reintentos
      final newRetryCount = request.retryCount + 1;
      
      // Si excedió el máximo de reintentos, marcar como fallido
      if (newRetryCount >= _maxRetries) {
        await _updateRequestStatus(
          request.id!,
          'failed',
          errorMessage: e.toString(),
        );
        return false;
      } else {
        // Actualizar contador de reintentos
        await _incrementRetryCount(request.id!);
        return false;
      }
    }
  }

  /// Intenta enviar todas las solicitudes pendientes
  Future<Map<String, int>> syncAllPendingRequests(final Dio dio) async {
    final pendingRequests = await getPendingRequests();
    int successCount = 0;
    int failedCount = 0;

    for (final request in pendingRequests) {
      final success = await sendRequest(request, dio);
      if (success) {
        successCount++;
      } else {
        failedCount++;
      }
    }

    return {
      'success': successCount,
      'failed': failedCount,
      'total': pendingRequests.length,
    };
  }

  /// Actualiza el estado de una solicitud
  Future<void> _updateRequestStatus(
    final int requestId,
    final String status, {
    final String? errorMessage,
  }) async {
    try {
      final db = await _databaseHelper.database;
      await db.update(
        _tableName,
        {
          'status': status,
          'error_message': errorMessage,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [requestId],
      );
    } catch (e) {
      throw Exception('Failed to update request status: $e');
    }
  }

  /// Incrementa el contador de reintentos
  Future<void> _incrementRetryCount(final int requestId) async {
    try {
      final db = await _databaseHelper.database;
      await db.rawUpdate('''
        UPDATE $_tableName 
        SET retry_count = retry_count + 1,
            updated_at = ?
        WHERE id = ?
      ''', [DateTime.now().toIso8601String(), requestId]);
    } catch (e) {
      throw Exception('Failed to increment retry count: $e');
    }
  }

  /// Elimina una solicitud específica
  Future<void> deleteRequest(final int requestId) async {
    try {
      final db = await _databaseHelper.database;
      await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [requestId],
      );
    } catch (e) {
      throw Exception('Failed to delete request: $e');
    }
  }

  /// Elimina todas las solicitudes exitosas
  Future<void> clearSuccessfulRequests() async {
    try {
      final db = await _databaseHelper.database;
      await db.delete(
        _tableName,
        where: 'status = ?',
        whereArgs: ['success'],
      );
    } catch (e) {
      throw Exception('Failed to clear successful requests: $e');
    }
  }

  /// Elimina todas las solicitudes fallidas
  Future<void> clearFailedRequests() async {
    try {
      final db = await _databaseHelper.database;
      await db.delete(
        _tableName,
        where: 'status = ?',
        whereArgs: ['failed'],
      );
    } catch (e) {
      throw Exception('Failed to clear failed requests: $e');
    }
  }

  /// Obtiene el conteo de solicitudes por estado
  Future<Map<String, int>> getRequestsCount() async {
    try {
      final db = await _databaseHelper.database;
      
      final waitingCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $_tableName WHERE status = ?', ['waiting']),
      ) ?? 0;
      
      final successCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $_tableName WHERE status = ?', ['success']),
      ) ?? 0;
      
      final failedCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $_tableName WHERE status = ?', ['failed']),
      ) ?? 0;

      return {
        'waiting': waitingCount,
        'success': successCount,
        'failed': failedCount,
        'total': waitingCount + successCount + failedCount,
      };
    } catch (e) {
      throw Exception('Failed to get requests count: $e');
    }
  }
}
