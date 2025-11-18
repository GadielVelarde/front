import 'package:equatable/equatable.dart';
class Seguimiento extends Equatable {
  final String id;
  final String rutaId;
  final String nombreRuta;
  final String asesorId;
  final String nombreAsesor;
  final String clienteId;
  final String nombreCliente;
  final String tipoVisita; // cobranza, supervision, verificacion
  final String? observaciones;
  final String? ubicacionLatitud;
  final String? ubicacionLongitud;
  final DateTime? fechaProgramada;
  final DateTime? fechaRealizada;
  final String estado; // pendiente, en_proceso, completada, cancelada
  final double? montoRecaudado;
  final String? comprobante; // URL o path del comprobante
  final List<String>? fotos; // URLs o paths de fotos
  final bool requiereAccion;
  final String? accionRequerida;

  const Seguimiento({
    required this.id,
    required this.rutaId,
    required this.nombreRuta,
    required this.asesorId,
    required this.nombreAsesor,
    required this.clienteId,
    required this.nombreCliente,
    required this.tipoVisita,
    this.observaciones,
    this.ubicacionLatitud,
    this.ubicacionLongitud,
    this.fechaProgramada,
    this.fechaRealizada,
    required this.estado,
    this.montoRecaudado,
    this.comprobante,
    this.fotos,
    required this.requiereAccion,
    this.accionRequerida,
  });

  @override
  List<Object?> get props => [
        id,
        rutaId,
        nombreRuta,
        asesorId,
        nombreAsesor,
        clienteId,
        nombreCliente,
        tipoVisita,
        observaciones,
        ubicacionLatitud,
        ubicacionLongitud,
        fechaProgramada,
        fechaRealizada,
        estado,
        montoRecaudado,
        comprobante,
        fotos,
        requiereAccion,
        accionRequerida,
      ];

  bool get estaCompletado => estado == 'completada';
  bool get estaPendiente => estado == 'pendiente';
  bool get enProceso => estado == 'en_proceso';
  bool get estaCancelado => estado == 'cancelada';

  Seguimiento copyWith({
    final String? id,
    final String? rutaId,
    final String? nombreRuta,
    final String? asesorId,
    final String? nombreAsesor,
    final String? clienteId,
    final String? nombreCliente,
    final String? tipoVisita,
    final String? observaciones,
    final String? ubicacionLatitud,
    final String? ubicacionLongitud,
    final DateTime? fechaProgramada,
    final DateTime? fechaRealizada,
    final String? estado,
    final double? montoRecaudado,
    final String? comprobante,
    final List<String>? fotos,
    final bool? requiereAccion,
    final String? accionRequerida,
  }) {
    return Seguimiento(
      id: id ?? this.id,
      rutaId: rutaId ?? this.rutaId,
      nombreRuta: nombreRuta ?? this.nombreRuta,
      asesorId: asesorId ?? this.asesorId,
      nombreAsesor: nombreAsesor ?? this.nombreAsesor,
      clienteId: clienteId ?? this.clienteId,
      nombreCliente: nombreCliente ?? this.nombreCliente,
      tipoVisita: tipoVisita ?? this.tipoVisita,
      observaciones: observaciones ?? this.observaciones,
      ubicacionLatitud: ubicacionLatitud ?? this.ubicacionLatitud,
      ubicacionLongitud: ubicacionLongitud ?? this.ubicacionLongitud,
      fechaProgramada: fechaProgramada ?? this.fechaProgramada,
      fechaRealizada: fechaRealizada ?? this.fechaRealizada,
      estado: estado ?? this.estado,
      montoRecaudado: montoRecaudado ?? this.montoRecaudado,
      comprobante: comprobante ?? this.comprobante,
      fotos: fotos ?? this.fotos,
      requiereAccion: requiereAccion ?? this.requiereAccion,
      accionRequerida: accionRequerida ?? this.accionRequerida,
    );
  }
}
