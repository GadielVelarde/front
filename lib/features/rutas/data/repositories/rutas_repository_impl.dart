import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/database/services/rutas_sync_service.dart';
import '../../domain/entities/ruta.dart';
import '../../domain/repositories/rutas_repository.dart';
import '../data_sources/remote/rutas_api_service.dart';
import '../data_sources/local/rutas_local_data_source.dart';
import '../models/ruta_model.dart';
import '../models/ruta_local_model.dart';

class RutasRepositoryImpl implements RutasRepository {
  final RutasApiService apiService;
  final RutasLocalDataSource localDataSource;
  final ConnectivityService connectivityService;
  final RutasSyncService syncService;

  RutasRepositoryImpl({
    required this.apiService,
    required this.localDataSource,
    required this.connectivityService,
    required this.syncService,
  });

  @override
  Future<Either<Failure, List<Ruta>>> getRutas({
    final String? zona,
    final String? agencia,
    final String? asesorId,
  }) async {
    try {
      final isConnected = await connectivityService.checkConnection();
      
      // Si HAY CONEXIÓN: Obtener del API y sincronizar con BD local
      if (isConnected) {
        try {
          
          final rutas = await apiService.fetchRutas(
            zona: zona,
            agencia: agencia,
            asesorId: asesorId,
          );
          
          _syncRutasToLocal(rutas);
          
          return Right(rutas);
        } catch (e) {
          // Si falla el API pero hay datos locales, usar esos como fallback
          final localRutas = await localDataSource.getAllRutas();
          if (localRutas.isNotEmpty) {
            final rutasEntities = localRutas
                .where((final r) => !r.isDeleted)
                .cast<Ruta>()
                .toList();
            return Right(rutasEntities);
          }
          
          // Si no hay datos locales tampoco, retornar el error
          return Left(UnexpectedFailure(
            message: 'Error al obtener rutas del servidor',
            data: e.toString(),
          ));
        }
      }
      
      // Si NO HAY CONEXIÓN: Usar datos locales (modo offline)
      final localRutas = await localDataSource.getAllRutas();
      final rutasEntities = localRutas
          .where((final r) => !r.isDeleted)
          .cast<Ruta>()
          .toList();
      
      if (rutasEntities.isEmpty) {
        return const Left(CacheFailure(
          message: 'No hay datos disponibles offline. Conecta a internet para obtener rutas.',
        ));
      }
      
      return Right(rutasEntities);
    } catch (e) {
      return Left(UnexpectedFailure(
        message: 'Error al obtener rutas',
        data: e.toString(),
      ));
    }
  }
  
  /// Sincroniza las rutas del API con la base de datos local
  /// Se ejecuta en background sin bloquear la respuesta
  void _syncRutasToLocal(final List<Ruta> rutas) {
    // Fire and forget - no esperamos la respuesta
    Future(() async {
      try {
        for (final ruta in rutas) {
          final localRuta = RutaLocalModel.fromRutaModel(
            RutaModel.fromEntity(ruta),
            syncStatus: 'synced',
            lastSyncedAt: DateTime.now(),
          );
          await localDataSource.upsertRuta(localRuta);
        }
      } catch (e) {
        throw Exception('⚠️ Error al sincronizar rutas con BD local: $e');
      }
    });
  }

  @override
  Future<Either<Failure, Ruta>> getRutaById(final String id) async {
    try {
      final isConnected = await connectivityService.checkConnection();
      
      // Si HAY CONEXIÓN: Obtener del API
      if (isConnected) {
        try {
          final ruta = await apiService.fetchRutaById(id);
          
          if (ruta != null) {
            // Sincronizar con BD local en background
            _syncRutaToLocal(ruta);
            return Right(ruta);
          }
          
          return const Left(CacheFailure(message: 'Ruta no encontrada'));
        } catch (e) {
          // Fallback a datos locales
          final localRuta = await localDataSource.getRutaById(id);
          if (localRuta != null && !localRuta.isDeleted) {
            return Right(localRuta as Ruta);
          }
          
          return Left(UnexpectedFailure(
            message: 'Error al obtener ruta',
            data: e.toString(),
          ));
        }
      }
      
      // Si NO HAY CONEXIÓN: Usar datos locales
      final localRuta = await localDataSource.getRutaById(id);
      
      if (localRuta != null && !localRuta.isDeleted) {
        return Right(localRuta as Ruta);
      }
      
      return const Left(CacheFailure(
        message: 'Ruta no disponible offline. Conecta a internet.',
      ));
    } catch (e) {
      return Left(UnexpectedFailure(
        message: 'Error al obtener ruta',
        data: e.toString(),
      ));
    }
  }
  
  /// Sincroniza una ruta del API con la base de datos local
  void _syncRutaToLocal(final Ruta ruta) {
    Future(() async {
      try {
        final localRuta = RutaLocalModel.fromRutaModel(
          RutaModel.fromEntity(ruta),
          syncStatus: 'synced',
          lastSyncedAt: DateTime.now(),
        );
        await localDataSource.upsertRuta(localRuta);
      } catch (e) {
          throw Exception('⚠️ Error al sincronizar ruta con BD local: $e');
      }
    });
  }

  @override
  Future<Either<Failure, Ruta>> createRuta(final Ruta ruta) async {
    try {
      // 1. OFFLINE-FIRST: Guardar localmente primero
      final localRuta = RutaLocalModel.fromEntity(
        ruta,
        syncStatus: 'pending',
      );
      await localDataSource.upsertRuta(localRuta);

      // 2. Si hay conexión, intentar sincronizar inmediatamente
      final isConnected = await connectivityService.checkConnection();
      if (isConnected) {
        try {
          final rutaModel = await apiService.createRuta(
            RutaModel.fromEntity(ruta),
          );
          // Actualizar como sincronizado
          await localDataSource.markAsSynced(ruta.id);
          return Right(rutaModel);
        } catch (e) {
          // Si falla la sincronización, el auto-sync lo reintentará
         throw Exception('⚠️  al sincronizar creación: $e');
        }
      }

      // Retornar la ruta local (se sincronizará después)
      return Right(localRuta as Ruta);
    } catch (e) {
      return Left(UnexpectedFailure(
        message: 'Error al crear ruta',
        data: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, Ruta>> updateRuta(final Ruta ruta) async {
    try {
      // 1. Obtener la ruta local actual para mantener metadata
      final currentRuta = await localDataSource.getRutaById(ruta.id);
      
      // 2. OFFLINE-FIRST: Actualizar localmente
      final updatedRuta = RutaLocalModel.fromEntity(
        ruta,
        version: (currentRuta?.version ?? 0) + 1,
        syncStatus: 'pending',
      );
      await localDataSource.updateRuta(updatedRuta);

      // 3. Si hay conexión, intentar sincronizar inmediatamente
      final isConnected = await connectivityService.checkConnection();
      if (isConnected) {
        try {
          final rutaModel = await apiService.updateRuta(
            RutaModel.fromEntity(ruta),
          );
          // Actualizar como sincronizado
          await localDataSource.markAsSynced(ruta.id);
          return Right(rutaModel);
        } catch (e) {
          // Si falla la sincronización, el auto-sync lo reintentará
          throw Exception('⚠️  al sincronizar actualización: $e');
        }
      }

      // Retornar la ruta local actualizada
      return Right(updatedRuta as Ruta);
    } catch (e) {
      return Left(UnexpectedFailure(
        message: 'Error al actualizar ruta',
        data: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRuta(final String id) async {
    try {
      // 1. OFFLINE-FIRST: Soft delete local (marcar como eliminado)
      await localDataSource.deleteRuta(id);

      // 2. Si hay conexión, intentar eliminar del servidor
      final isConnected = await connectivityService.checkConnection();
      if (isConnected) {
        try {
          await apiService.deleteRutafinal(id);
        } catch (e) {
          // Si falla, el auto-sync lo reintentará
          throw Exception('⚠️ Error al sincronizar eliminación: $e');
        }
      }

      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(
        message: 'Error al eliminar ruta',
        data: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, Ruta>> assignAsesor(final String rutaId, final String asesorId) async {
    try {
      // 1. Obtener ruta local actual
      final currentRuta = await localDataSource.getRutaById(rutaId);
      if (currentRuta == null) {
        return const Left(CacheFailure(message: 'Ruta no encontrada'));
      }

      // 2. OFFLINE-FIRST: Actualizar asesor localmente
      final updatedRuta = RutaLocalModel(
        id: currentRuta.id,
        nombre: currentRuta.nombre,
        descripcion: currentRuta.descripcion,
        zona: currentRuta.zona,
        agencia: currentRuta.agencia,
        asesorAsignado: asesorId, // Actualizar asesor
        tipoRuta: currentRuta.tipoRuta,
        fechaCreacion: currentRuta.fechaCreacion,
        fechaActualizacion: DateTime.now(),
        estado: currentRuta.estado,
        totalVisitas: currentRuta.totalVisitas,
        visitasCompletadas: currentRuta.visitasCompletadas,
        lastSyncedAt: currentRuta.lastSyncedAt,
        isDeleted: currentRuta.isDeleted,
        version: currentRuta.version + 1,
        syncStatus: 'pending',
      );
      await localDataSource.updateRuta(updatedRuta);

      // 3. Si hay conexión, intentar sincronizar inmediatamente
      final isConnected = await connectivityService.checkConnection();
      if (isConnected) {
        try {
          final ruta = await apiService.assignAsesor(rutaId, asesorId);
          await localDataSource.markAsSynced(rutaId);
          return Right(ruta);
        } catch (e) {
          throw Exception('⚠️  al sincronizar asignación: $e');
        }
      }

      return Right(updatedRuta as Ruta);
    } catch (e) {
      return Left(UnexpectedFailure(
        message: 'Error al asignar asesor',
        data: e.toString(),
      ));
    }
  }
}
