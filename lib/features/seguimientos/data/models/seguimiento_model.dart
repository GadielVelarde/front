import '../../domain/entities/seguimiento.dart';
class SeguimientoModel extends Seguimiento {
  const SeguimientoModel({
    required super.id,
    required super.rutaId,
    required super.nombreRuta,
    required super.asesorId,
    required super.nombreAsesor,
    required super.clienteId,
    required super.nombreCliente,
    required super.tipoVisita,
    super.observaciones,
    super.ubicacionLatitud,
    super.ubicacionLongitud,
    super.fechaProgramada,
    super.fechaRealizada,
    required super.estado,
    super.montoRecaudado,
    super.comprobante,
    super.fotos,
    required super.requiereAccion,
    super.accionRequerida,
  });

  factory SeguimientoModel.fromJson(final Map<String, dynamic> json) {
    return SeguimientoModel(
      id: json['id'] as String? ?? '',
      rutaId: json['ruta_id'] as String? ?? '',
      nombreRuta: json['nombre_ruta'] as String? ?? '',
      asesorId: json['asesor_id'] as String? ?? '',
      nombreAsesor: json['nombre_asesor'] as String? ?? '',
      clienteId: json['cliente_id'] as String? ?? '',
      nombreCliente: json['nombre_cliente'] as String? ?? '',
      tipoVisita: json['tipo_visita'] as String? ?? '',
      observaciones: json['observaciones'] as String?,
      ubicacionLatitud: json['ubicacion_latitud'] as String?,
      ubicacionLongitud: json['ubicacion_longitud'] as String?,
      fechaProgramada: json['fecha_programada'] != null
          ? DateTime.parse(json['fecha_programada'] as String)
          : null,
      fechaRealizada: json['fecha_realizada'] != null
          ? DateTime.parse(json['fecha_realizada'] as String)
          : null,
      estado: json['estado'] as String? ?? 'pendiente',
      montoRecaudado: json['monto_recaudado'] != null
          ? (json['monto_recaudado'] as num).toDouble()
          : null,
      comprobante: json['comprobante'] as String?,
      fotos: json['fotos'] != null
          ? (json['fotos'] as List).map((final e) => e.toString()).toList()
          : null,
      requiereAccion: json['requiere_accion'] as bool? ?? false,
      accionRequerida: json['accion_requerida'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ruta_id': rutaId,
      'nombre_ruta': nombreRuta,
      'asesor_id': asesorId,
      'nombre_asesor': nombreAsesor,
      'cliente_id': clienteId,
      'nombre_cliente': nombreCliente,
      'tipo_visita': tipoVisita,
      'observaciones': observaciones,
      'ubicacion_latitud': ubicacionLatitud,
      'ubicacion_longitud': ubicacionLongitud,
      'fecha_programada': fechaProgramada?.toIso8601String(),
      'fecha_realizada': fechaRealizada?.toIso8601String(),
      'estado': estado,
      'monto_recaudado': montoRecaudado,
      'comprobante': comprobante,
      'fotos': fotos,
      'requiere_accion': requiereAccion,
      'accion_requerida': accionRequerida,
    };
  }

  factory SeguimientoModel.fromEntity(final Seguimiento seguimiento) {
    return SeguimientoModel(
      id: seguimiento.id,
      rutaId: seguimiento.rutaId,
      nombreRuta: seguimiento.nombreRuta,
      asesorId: seguimiento.asesorId,
      nombreAsesor: seguimiento.nombreAsesor,
      clienteId: seguimiento.clienteId,
      nombreCliente: seguimiento.nombreCliente,
      tipoVisita: seguimiento.tipoVisita,
      observaciones: seguimiento.observaciones,
      ubicacionLatitud: seguimiento.ubicacionLatitud,
      ubicacionLongitud: seguimiento.ubicacionLongitud,
      fechaProgramada: seguimiento.fechaProgramada,
      fechaRealizada: seguimiento.fechaRealizada,
      estado: seguimiento.estado,
      montoRecaudado: seguimiento.montoRecaudado,
      comprobante: seguimiento.comprobante,
      fotos: seguimiento.fotos,
      requiereAccion: seguimiento.requiereAccion,
      accionRequerida: seguimiento.accionRequerida,
    );
  }
}
