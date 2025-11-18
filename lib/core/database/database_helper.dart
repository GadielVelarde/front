import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

/// Database Helper para gestionar la base de datos local SQLite
/// Implementa el patrón Singleton para asegurar una única instancia
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  static const String _databaseName = 'norandino_offline.db';
  static const int _databaseVersion = 2; // Incrementado para forzar migración

  /// Obtiene la instancia de la base de datos
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Inicializa la base de datos
  Future<Database> _initDatabase() async {
    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, _databaseName);

      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onConfigure: _onConfigure,
      );
    } catch (e) {
      throw Exception('Failed to initialize database: $e');
    }
  }

  /// Habilita foreign keys y otras restricciones
  Future<void> _onConfigure(final Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// Crea las tablas iniciales
  Future<void> _onCreate(final Database db, final int version) async {
    // Tabla de Rutas
    await db.execute('''
      CREATE TABLE rutas (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL,
        descripcion TEXT,
        zona TEXT,
        agencia TEXT,
        asesor_asignado TEXT,
        tipo_ruta TEXT,
        fecha_creacion TEXT,
        fecha_actualizacion TEXT,
        estado TEXT,
        total_visitas INTEGER,
        visitas_completadas INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        last_synced_at TEXT,
        is_deleted INTEGER NOT NULL DEFAULT 0,
        version INTEGER NOT NULL DEFAULT 1,
        sync_status TEXT NOT NULL DEFAULT 'pending'
      )
    ''');

    // Tabla de Clientes en Ruta
    await db.execute('''
      CREATE TABLE ruta_clientes (
        id TEXT PRIMARY KEY,
        ruta_id TEXT NOT NULL,
        cliente_id TEXT NOT NULL,
        orden INTEGER NOT NULL,
        visitado INTEGER NOT NULL DEFAULT 0,
        observaciones TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        last_synced_at TEXT,
        is_deleted INTEGER NOT NULL DEFAULT 0,
        sync_status TEXT NOT NULL DEFAULT 'pending',
        FOREIGN KEY (ruta_id) REFERENCES rutas (id) ON DELETE CASCADE
      )
    ''');

    // Tabla de Solicitudes Offline
    await db.execute('''
      CREATE TABLE offline_requests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        method TEXT NOT NULL,
        url TEXT NOT NULL,
        body TEXT,
        headers TEXT,
        entity_type TEXT NOT NULL,
        entity_id TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'waiting',
        error_message TEXT,
        retry_count INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Índices para mejor rendimiento
    await db.execute('''
      CREATE INDEX idx_rutas_updated_at ON rutas(updated_at)
    ''');

    await db.execute('''
      CREATE INDEX idx_rutas_sync_status ON rutas(sync_status)
    ''');

    await db.execute('''
      CREATE INDEX idx_rutas_is_deleted ON rutas(is_deleted)
    ''');

    await db.execute('''
      CREATE INDEX idx_ruta_clientes_ruta_id ON ruta_clientes(ruta_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_offline_requests_status ON offline_requests(status)
    ''');
  }

  /// Maneja las migraciones de base de datos
  Future<void> _onUpgrade(final Database db, final int oldVersion, final int newVersion) async {
    if (oldVersion < 2) {      
      // Crear tabla temporal con el nuevo esquema
      await db.execute('''
        CREATE TABLE rutas_new (
          id TEXT PRIMARY KEY,
          nombre TEXT NOT NULL,
          descripcion TEXT,
          zona TEXT,
          agencia TEXT,
          asesor_asignado TEXT,
          tipo_ruta TEXT,
          fecha_creacion TEXT,
          fecha_actualizacion TEXT,
          estado TEXT,
          total_visitas INTEGER,
          visitas_completadas INTEGER,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          last_synced_at TEXT,
          is_deleted INTEGER NOT NULL DEFAULT 0,
          version INTEGER NOT NULL DEFAULT 1,
          sync_status TEXT NOT NULL DEFAULT 'pending'
        )
      ''');
      
      // Copiar datos existentes (si hay) mapeando campos antiguos a nuevos
      await db.execute('''
        INSERT INTO rutas_new (
          id, nombre, descripcion, zona, agencia, asesor_asignado, 
          estado, created_at, updated_at, last_synced_at, 
          is_deleted, version, sync_status
        )
        SELECT 
          id, nombre, descripcion, '', '', asesor_id,
          estado, created_at, updated_at, last_synced_at,
          is_deleted, version, sync_status
        FROM rutas
      ''');
      
      // Eliminar tabla antigua
      await db.execute('DROP TABLE rutas');
      
      // Renombrar tabla nueva
      await db.execute('ALTER TABLE rutas_new RENAME TO rutas');
      
      // Recrear índices
      await db.execute('CREATE INDEX idx_rutas_updated_at ON rutas(updated_at)');
      await db.execute('CREATE INDEX idx_rutas_sync_status ON rutas(sync_status)');
      await db.execute('CREATE INDEX idx_rutas_is_deleted ON rutas(is_deleted)');
      
    }
  }

  /// Cierra la conexión a la base de datos
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// Elimina la base de datos (útil para testing)
  Future<void> deleteDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  /// Limpia todas las tablas (útil para logout)
  Future<void> clearAllData() async {
    final db = await database;
    await db.transaction((final txn) async {
      await txn.delete('rutas');
      await txn.delete('ruta_clientes');
      await txn.delete('offline_requests');
    });
  }
}
