import 'dart:async';
import 'package:dio/dio.dart';
import '../../network/connectivity_service.dart';
import '../services/offline_request_service.dart';
import '../../../features/rutas/data/data_sources/local/rutas_local_data_source.dart';
import '../../../features/rutas/data/data_sources/remote/rutas_api_service.dart';
import '../../../features/rutas/data/models/ruta_local_model.dart';
import '../../../features/rutas/data/models/ruta_model.dart';

/// Servicio de sincronización para rutas offline
/// Gestiona la sincronización entre la base de datos local y el API remoto
class RutasSyncService {
  final RutasLocalDataSource _localDataSource;
  final RutasApiService _apiService;
  final ConnectivityService _connectivityService;
  final OfflineRequestService _offlineRequestService;
  
  bool _isSyncing = false;
  Timer? _autoSyncTimer;
  StreamSubscription<bool>? _connectivitySubscription;

  RutasSyncService({
    required final RutasLocalDataSource localDataSource,
    required final RutasApiService apiService,
    required final ConnectivityService connectivityService,
    required final OfflineRequestService offlineRequestService,
  })  : _localDataSource = localDataSource,
        _apiService = apiService,
        _connectivityService = connectivityService,
        _offlineRequestService = offlineRequestService;

  /// Indica si está en proceso de sincronización
  bool get isSyncing => _isSyncing;

  /// Inicializa el servicio de sincronización
  /// Comienza a escuchar cambios de conectividad y programa sincronizaciones automáticas
  Future<void> initialize({final bool enableAutoSync = true}) async {
    // Escuchar cambios de conectividad
    _connectivitySubscription = _connectivityService.connectionStream.listen((final isConnected) {
      if (isConnected && !_isSyncing) {
        // Sincronizar automáticamente cuando se restablece la conexión
        syncAll();
      }
    });

    // Configurar sincronización automática cada 5 minutos
    if (enableAutoSync) {
      _autoSyncTimer = Timer.periodic(
        const Duration(minutes: 5),
        (_) {
          if (_connectivityService.isConnected && !_isSyncing) {
            syncAll();
          }
        },
      );
    }

    // Realizar sincronización inicial si hay conexión
    if (_connectivityService.isConnected) {
      await syncAll();
    }
  }

  /// Sincroniza todas las rutas: descarga del servidor y sube cambios locales
  Future<Map<String, dynamic>> syncAll() async {
    if (_isSyncing) {
      return {'status': 'already_syncing'};
    }

    if (!_connectivityService.isConnected) {
      return {'status': 'no_connection', 'message': 'No hay conexión a internet'};
    }

    _isSyncing = true;

    try {
      // 1. Sincronizar solicitudes offline pendientes
      final offlineResults = await _offlineRequestService.syncAllPendingRequests(
        Dio(), // Aquí deberías usar tu instancia de Dio configurada
      );

      // 2. Subir cambios locales al servidor
      final uploadResults = await _uploadLocalChanges();

      // 3. Descargar datos del servidor
      final downloadResults = await _downloadRemoteData();

      _isSyncing = false;

      return {
        'status': 'success',
        'offline_requests': offlineResults,
        'upload': uploadResults,
        'download': downloadResults,
      };
    } catch (e) {
      _isSyncing = false;
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }

  /// Sube los cambios locales al servidor
  Future<Map<String, int>> _uploadLocalChanges() async {
    final unsyncedRutas = await _localDataSource.getUnsyncedRutas();
    int successCount = 0;
    int failedCount = 0;

    for (final ruta in unsyncedRutas) {
      try {
        if (ruta.isDeleted) {
          // Si está marcada como eliminada, eliminarla del servidor
          await _apiService.deleteRutafinal(ruta.id);
        } else {
          // Verificar si existe en el servidor para decidir si crear o actualizar
          final exists = await _checkIfRutaExistsOnServer(ruta.id);
          
          if (exists) {
            // Actualizar en el servidor
            await _apiService.updateRuta(RutaModel.fromEntity(ruta));
          } else {
            // Crear en el servidor
            await _apiService.createRuta(RutaModel.fromEntity(ruta));
          }
        }

        // Marcar como sincronizada
        await _localDataSource.markAsSynced(ruta.id);
        successCount++;
      } catch (e) {
        // Marcar como fallida
        await _localDataSource.markAsFailed(ruta.id);
        failedCount++;
        
        // Guardar la solicitud para reintentarla más tarde
        // (esto se puede implementar según necesidades específicas)
      }
    }

    return {
      'success': successCount,
      'failed': failedCount,
      'total': unsyncedRutas.length,
    };
  }

  /// Descarga datos remotos y los guarda localmente
  Future<Map<String, int>> _downloadRemoteData() async {
    try {
      // Obtener todas las rutas del servidor
      final remoteRutas = await _apiService.fetchRutas();
      int insertedCount = 0;
      int updatedCount = 0;

      for (final remoteRuta in remoteRutas) {
        // Verificar si existe localmente
        final localRuta = await _localDataSource.getRutaById(remoteRuta.id);

        if (localRuta == null) {
          // No existe localmente, insertarla
          final localModel = RutaLocalModel.fromRutaModel(
            remoteRuta,
            syncStatus: 'synced',
            lastSyncedAt: DateTime.now(),
          );
          await _localDataSource.upsertRuta(localModel);
          insertedCount++;
        } else {
          // Existe localmente, verificar si necesita actualizarse
          if (_shouldUpdateLocal(localRuta, remoteRuta)) {
            final updatedModel = RutaLocalModel.fromRutaModel(
              remoteRuta,
              syncStatus: 'synced',
              lastSyncedAt: DateTime.now(),
              version: localRuta.version,
            );
            await _localDataSource.upsertRuta(updatedModel);
            updatedCount++;
          }
        }
      }

      return {
        'inserted': insertedCount,
        'updated': updatedCount,
        'total': remoteRutas.length,
      };
    } catch (e) {
      throw Exception('Failed to download remote data: $e');
    }
  }

  /// Verifica si una ruta existe en el servidor
  Future<bool> _checkIfRutaExistsOnServer(final String id) async {
    try {
      final ruta = await _apiService.fetchRutaById(id);
      return ruta != null;
    } catch (e) {
      return false;
    }
  }

  /// Determina si se debe actualizar la versión local con la remota
  /// Estrategia: Last Write Wins basado en updated_at
  bool _shouldUpdateLocal(final RutaLocalModel local, final RutaModel remote) {
    // Si la local está pendiente de sincronización, no sobrescribirla
    if (local.syncStatus == 'pending') {
      return false;
    }

    // Si ambas tienen fecha de actualización, comparar
    if (local.fechaActualizacion != null && remote.fechaActualizacion != null) {
      return remote.fechaActualizacion!.isAfter(local.fechaActualizacion!);
    }

    // Por defecto, actualizar
    return true;
  }

  /// Sincroniza una ruta específica
  Future<bool> syncRuta(final String rutaId) async {
    try {
      final localRuta = await _localDataSource.getRutaById(rutaId);
      
      if (localRuta == null) {
        throw Exception('Ruta no encontrada localmente');
      }

      if (!_connectivityService.isConnected) {
        // Sin conexión, solo marcar como pendiente
        if (localRuta.syncStatus != 'pending') {
          await _localDataSource.updateRuta(
            localRuta.copyWith(syncStatus: 'pending'),
          );
        }
        return false;
      }

      // Con conexión, intentar sincronizar
      if (localRuta.isDeleted) {
        await _apiService.deleteRutafinal(rutaId);
      } else {
        final exists = await _checkIfRutaExistsOnServer(rutaId);
        
        if (exists) {
          await _apiService.updateRuta(RutaModel.fromEntity(localRuta));
        } else {
          await _apiService.createRuta(RutaModel.fromEntity(localRuta));
        }
      }

      await _localDataSource.markAsSynced(rutaId);
      return true;
    } catch (e) {
      await _localDataSource.markAsFailed(rutaId);
      return false;
    }
  }

  /// Obtiene estadísticas de sincronización
  Future<Map<String, dynamic>> getSyncStats() async {
    final statusCount = await _localDataSource.getSyncStatusCount();
    final offlineRequestCount = await _offlineRequestService.getRequestsCount();

    return {
      'rutas': statusCount,
      'offline_requests': offlineRequestCount,
      'is_syncing': _isSyncing,
      'is_connected': _connectivityService.isConnected,
    };
  }

  /// Detiene el servicio de sincronización y libera recursos
  Future<void> dispose() async {
    _autoSyncTimer?.cancel();
    await _connectivitySubscription?.cancel();
  }
}
