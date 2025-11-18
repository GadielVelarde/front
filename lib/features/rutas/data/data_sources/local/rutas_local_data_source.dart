import 'package:sqflite/sqflite.dart';
import '../../../../../core/database/database_helper.dart';
import '../../models/ruta_local_model.dart';

/// Servicio de base de datos local para Rutas
/// Gestiona todas las operaciones CRUD offline para rutas
class RutasLocalDataSource {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  static const String _tableName = 'rutas';

  /// Obtiene todas las rutas no eliminadas
  Future<List<RutaLocalModel>> getAllRutas({final bool includeDeleted = false}) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: includeDeleted ? null : 'is_deleted = ?',
        whereArgs: includeDeleted ? null : [0],
        orderBy: 'updated_at DESC',
      );

      return maps.map((final map) => RutaLocalModel.fromLocalMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get rutas from local database: $e');
    }
  }

  /// Obtiene una ruta específica por ID
  Future<RutaLocalModel?> getRutaById(final String id) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'id = ? AND is_deleted = ?',
        whereArgs: [id, 0],
        limit: 1,
      );

      if (maps.isEmpty) return null;
      return RutaLocalModel.fromLocalMap(maps.first);
    } catch (e) {
      throw Exception('Failed to get ruta by id from local database: $e');
    }
  }

  /// Inserta o actualiza una ruta en la base de datos local
  Future<void> upsertRuta(final RutaLocalModel ruta) async {
    try {
      final db = await _databaseHelper.database;
      await db.insert(
        _tableName,
        ruta.toLocalMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Failed to upsert ruta in local database: $e');
    }
  }

  /// Inserta múltiples rutas (útil para sincronización inicial)
  Future<void> upsertMultipleRutas(final List<RutaLocalModel> rutas) async {
    try {
      final db = await _databaseHelper.database;
      final batch = db.batch();

      for (final ruta in rutas) {
        batch.insert(
          _tableName,
          ruta.toLocalMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception('Failed to upsert multiple rutas in local database: $e');
    }
  }

  /// Actualiza una ruta existente
  Future<void> updateRuta(final RutaLocalModel ruta) async {
    try {
      final db = await _databaseHelper.database;
      final updatedRuta = ruta.copyWith(
        fechaActualizacion: DateTime.now(),
        version: ruta.version + 1,
        syncStatus: 'pending',
      );

      final rowsAffected = await db.update(
        _tableName,
        updatedRuta.toLocalMap(),
        where: 'id = ?',
        whereArgs: [ruta.id],
      );

      if (rowsAffected == 0) {
        throw Exception('Ruta not found for update');
      }
    } catch (e) {
      throw Exception('Failed to update ruta in local database: $e');
    }
  }

  /// Elimina una ruta (soft delete)
  Future<void> deleteRuta(final String id) async {
    try {
      final db = await _databaseHelper.database;
      final rowsAffected = await db.update(
        _tableName,
        {
          'is_deleted': 1,
          'updated_at': DateTime.now().toIso8601String(),
          'sync_status': 'pending',
        },
        where: 'id = ?',
        whereArgs: [id],
      );

      if (rowsAffected == 0) {
        throw Exception('Ruta not found for deletion');
      }
    } catch (e) {
      throw Exception('Failed to delete ruta in local database: $e');
    }
  }

  /// Elimina permanentemente una ruta (hard delete)
  Future<void> permanentlyDeleteRuta(final String id) async {
    try {
      final db = await _databaseHelper.database;
      await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to permanently delete ruta: $e');
    }
  }

  /// Obtiene rutas que necesitan sincronización
  Future<List<RutaLocalModel>> getUnsyncedRutas() async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'sync_status IN (?, ?)',
        whereArgs: ['pending', 'failed'],
        orderBy: 'updated_at ASC',
      );

      return maps.map((final map) => RutaLocalModel.fromLocalMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get unsynced rutas: $e');
    }
  }

  /// Marca una ruta como sincronizada
  Future<void> markAsSynced(final String id) async {
    try {
      final db = await _databaseHelper.database;
      await db.update(
        _tableName,
        {
          'sync_status': 'synced',
          'last_synced_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to mark ruta as synced: $e');
    }
  }

  /// Marca una ruta como fallida en la sincronización
  Future<void> markAsFailed(final String id) async {
    try {
      final db = await _databaseHelper.database;
      await db.update(
        _tableName,
        {
          'sync_status': 'failed',
        },
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to mark ruta as failed: $e');
    }
  }

  /// Obtiene el conteo de rutas por estado de sincronización
  Future<Map<String, int>> getSyncStatusCount() async {
    try {
      final db = await _databaseHelper.database;

      final syncedCount = Sqflite.firstIntValue(
        await db.rawQuery(
          'SELECT COUNT(*) FROM $_tableName WHERE sync_status = ? AND is_deleted = ?',
          ['synced', 0],
        ),
      ) ?? 0;

      final pendingCount = Sqflite.firstIntValue(
        await db.rawQuery(
          'SELECT COUNT(*) FROM $_tableName WHERE sync_status = ? AND is_deleted = ?',
          ['pending', 0],
        ),
      ) ?? 0;

      final failedCount = Sqflite.firstIntValue(
        await db.rawQuery(
          'SELECT COUNT(*) FROM $_tableName WHERE sync_status = ? AND is_deleted = ?',
          ['failed', 0],
        ),
      ) ?? 0;

      return {
        'synced': syncedCount,
        'pending': pendingCount,
        'failed': failedCount,
        'total': syncedCount + pendingCount + failedCount,
      };
    } catch (e) {
      throw Exception('Failed to get sync status count: $e');
    }
  }

  /// Limpia todas las rutas (útil para logout o reset)
  Future<void> clearAllRutas() async {
    try {
      final db = await _databaseHelper.database;
      await db.delete(_tableName);
    } catch (e) {
      throw Exception('Failed to clear all rutas: $e');
    }
  }

  /// Busca rutas por nombre o descripción
  Future<List<RutaLocalModel>> searchRutas(final String query) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: '(nombre LIKE ? OR descripcion LIKE ?) AND is_deleted = ?',
        whereArgs: ['%$query%', '%$query%', 0],
        orderBy: 'updated_at DESC',
      );

      return maps.map((final map) => RutaLocalModel.fromLocalMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to search rutas: $e');
    }
  }

  /// Obtiene rutas por estado
  Future<List<RutaLocalModel>> getRutasByEstado(final String estado) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'estado = ? AND is_deleted = ?',
        whereArgs: [estado, 0],
        orderBy: 'updated_at DESC',
      );

      return maps.map((final map) => RutaLocalModel.fromLocalMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get rutas by estado: $e');
    }
  }

  /// Verifica si existe una ruta localmente
  Future<bool> rutaExists(final String id) async {
    try {
      final db = await _databaseHelper.database;
      final count = Sqflite.firstIntValue(
        await db.rawQuery(
          'SELECT COUNT(*) FROM $_tableName WHERE id = ? AND is_deleted = ?',
          [id, 0],
        ),
      );
      return (count ?? 0) > 0;
    } catch (e) {
      throw Exception('Failed to check if ruta exists: $e');
    }
  }
}
