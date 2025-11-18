import '../../domain/entities/ruta.dart';
class RutaModel extends Ruta {
  const RutaModel({
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
  });

  factory RutaModel.fromJson(final Map<String, dynamic> json) {
    return RutaModel(
      id: json['id']?.toString() ?? '',
      nombre: json['numero'] as String? ?? 'Sin nombre',
      descripcion: json['observacion'] as String? ?? '',
      zona: json['zona'] as String? ?? 'Sin zona',
      agencia: json['agencia_id']?.toString() ?? 'Sin agencia',
      asesorAsignado: json['user_id']?.toString(),
      tipoRuta: json['tiporuta_id']?.toString(),
      fechaCreacion: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      fechaActualizacion: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      estado: json['estado'] as String? ?? 'Sin estado',
      totalVisitas: 0,
      visitasCompletadas: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'zona': zona,
      'agencia': agencia,
      'asesor_asignado': asesorAsignado,
      'tipo_ruta': tipoRuta,
      'fecha_creacion': fechaCreacion?.toIso8601String(),
      'fecha_actualizacion': fechaActualizacion?.toIso8601String(),
      'estado': estado,
      'total_visitas': totalVisitas,
      'visitas_completadas': visitasCompletadas,
    };
  }
  factory RutaModel.fromEntity(final Ruta ruta) {
    return RutaModel(
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
    );
  }

  RutaModel copyWith({
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
  }) {
    return RutaModel(
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
    );
  }
}
