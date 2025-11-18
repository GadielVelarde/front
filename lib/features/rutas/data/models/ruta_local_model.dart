import '../../domain/entities/ruta.dart';
import '../models/ruta_model.dart';

/// Modelo extendido de Ruta para la base de datos local
/// Incluye campos adicionales para sincronización offline
class RutaLocalModel extends RutaModel {
  final DateTime? lastSyncedAt;
  final bool isDeleted;
  final int version;
  final String syncStatus; // 'pending', 'synced', 'failed'

  const RutaLocalModel({
    required super.id,
    required super.nombre,
    required super.descripcion,
    required super.zona,
    required super.agencia,
    super.asesorAsignado,
    super.tipoRuta,
    super.fechaCreacion,
    super.fechaActualizacion,
    super.estado,
    super.totalVisitas,
    super.visitasCompletadas,
    this.lastSyncedAt,
    this.isDeleted = false,
    this.version = 1,
    this.syncStatus = 'pending',
  });

  /// Convierte el modelo a un Map para SQLite
  Map<String, dynamic> toLocalMap() {
    final map = super.toJson();
    map.addAll({
      'created_at': fechaCreacion?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'updated_at': fechaActualizacion?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'is_deleted': isDeleted ? 1 : 0,
      'version': version,
      'sync_status': syncStatus,
    });
    return map;
  }

  /// Crea una instancia desde un Map de SQLite
  factory RutaLocalModel.fromLocalMap(final Map<String, dynamic> map) {
    return RutaLocalModel(
      id: map['id'] as String? ?? '',
      nombre: map['nombre'] as String? ?? '',
      descripcion: map['descripcion'] as String? ?? '',
      zona: map['zona'] as String? ?? '',
      agencia: map['agencia'] as String? ?? '',
      asesorAsignado: map['asesor_asignado'] as String?,
      tipoRuta: map['tipo_ruta'] as String?,
      fechaCreacion: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      fechaActualizacion: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
      estado: map['estado'] as String?,
      totalVisitas: map['total_visitas'] as int?,
      visitasCompletadas: map['visitas_completadas'] as int?,
      lastSyncedAt: map['last_synced_at'] != null
          ? DateTime.parse(map['last_synced_at'] as String)
          : null,
      isDeleted: (map['is_deleted'] as int?) == 1,
      version: map['version'] as int? ?? 1,
      syncStatus: map['sync_status'] as String? ?? 'pending',
    );
  }

  /// Crea una instancia desde la entidad Ruta
  factory RutaLocalModel.fromEntity(final Ruta ruta, {
    final DateTime? lastSyncedAt,
    final bool isDeleted = false,
    final int version = 1,
    final String syncStatus = 'pending',
  }) {
    return RutaLocalModel(
      id: ruta.id,
      nombre: ruta.nombre,
      descripcion: ruta.descripcion,
      zona: ruta.zona,
      agencia: ruta.agencia,
      asesorAsignado: ruta.asesorAsignado,
      tipoRuta: ruta.tipoRuta,
      fechaCreacion: ruta.fechaCreacion,
      fechaActualizacion: ruta.fechaActualizacion,
      estado: ruta.estado,
      totalVisitas: ruta.totalVisitas,
      visitasCompletadas: ruta.visitasCompletadas,
      lastSyncedAt: lastSyncedAt,
      isDeleted: isDeleted,
      version: version,
      syncStatus: syncStatus,
    );
  }

  /// Crea una instancia desde RutaModel
  factory RutaLocalModel.fromRutaModel(final RutaModel model, {
    final DateTime? lastSyncedAt,
    final bool isDeleted = false,
    final int version = 1,
    final String syncStatus = 'synced',
  }) {
    return RutaLocalModel(
      id: model.id,
      nombre: model.nombre,
      descripcion: model.descripcion,
      zona: model.zona,
      agencia: model.agencia,
      asesorAsignado: model.asesorAsignado,
      tipoRuta: model.tipoRuta,
      fechaCreacion: model.fechaCreacion,
      fechaActualizacion: model.fechaActualizacion,
      estado: model.estado,
      totalVisitas: model.totalVisitas,
      visitasCompletadas: model.visitasCompletadas,
      lastSyncedAt: lastSyncedAt ?? DateTime.now(),
      isDeleted: isDeleted,
      version: version,
      syncStatus: syncStatus,
    );
  }

  /// Crea una copia con campos actualizados
  @override
  RutaLocalModel copyWith({
    final String? id,
    final String? nombre,
    final String? descripcion,
    final String? zona,
    final String? agencia,
    final String? asesorAsignado,
    final String? tipoRuta,
    final DateTime? fechaCreacion,
    final DateTime? fechaActualizacion,
    final String? estado,
    final int? totalVisitas,
    final int? visitasCompletadas,
    final DateTime? lastSyncedAt,
    final bool? isDeleted,
    final int? version,
    final String? syncStatus,
  }) {
    return RutaLocalModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      zona: zona ?? this.zona,
      agencia: agencia ?? this.agencia,
      asesorAsignado: asesorAsignado ?? this.asesorAsignado,
      tipoRuta: tipoRuta ?? this.tipoRuta,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      estado: estado ?? this.estado,
      totalVisitas: totalVisitas ?? this.totalVisitas,
      visitasCompletadas: visitasCompletadas ?? this.visitasCompletadas,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      version: version ?? this.version,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  /// Verifica si necesita sincronización
  bool get needsSync => syncStatus == 'pending' || syncStatus == 'failed';

  /// Verifica si está sincronizado
  bool get isSynced => syncStatus == 'synced';

  @override
  List<Object?> get props => [
        ...super.props,
        lastSyncedAt,
        isDeleted,
        version,
        syncStatus,
      ];
}
