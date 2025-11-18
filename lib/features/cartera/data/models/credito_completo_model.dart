import '../../domain/entities/credito_completo.dart';
import 'socio_basico_model.dart';

class CreditoCompletoModel extends CreditoCompleto {
  const CreditoCompletoModel({
    required super.id,
    required super.socio,
    required super.montoTotal,
    required super.montoPagado,
    required super.saldoPendiente,
    required super.estado,
    required super.diasMora,
    required super.fechaDesembolso,
    super.fechaProximoVencimiento,
    required super.numeroCuotas,
    required super.cuotasPagadas,
    required super.cuotasPendientes,
    super.montoCuota,
    required super.asesorId,
    required super.nombreAsesor,
    required super.agencia,
  });

  factory CreditoCompletoModel.fromJson(final Map<String, dynamic> json) {
    return CreditoCompletoModel(
      id: json['id'] as int,
      socio: SocioBasicoModel.fromJson(json['socio'] as Map<String, dynamic>),
      montoTotal: (json['montoTotal'] as num).toDouble(),
      montoPagado: (json['montoPagado'] as num).toDouble(),
      saldoPendiente: (json['saldoPendiente'] as num).toDouble(),
      estado: json['estado'] as String,
      diasMora: json['diasMora'] as int,
      fechaDesembolso: DateTime.parse(json['fechaDesembolso'] as String),
      fechaProximoVencimiento: json['fechaProximoVencimiento'] != null
          ? DateTime.parse(json['fechaProximoVencimiento'] as String)
          : null,
      numeroCuotas: json['numeroCuotas'] as int,
      cuotasPagadas: json['cuotasPagadas'] as int,
      cuotasPendientes: json['cuotasPendientes'] as int,
      montoCuota: json['montoCuota'] != null
          ? (json['montoCuota'] as num).toDouble()
          : null,
      asesorId: json['asesorId'] as int,
      nombreAsesor: (json['nombreAsesor'] as String).trim(),
      agencia: json['agencia'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'socio': (socio as SocioBasicoModel).toJson(),
      'montoTotal': montoTotal,
      'montoPagado': montoPagado,
      'saldoPendiente': saldoPendiente,
      'estado': estado,
      'diasMora': diasMora,
      'fechaDesembolso': fechaDesembolso.toIso8601String(),
      'fechaProximoVencimiento': fechaProximoVencimiento?.toIso8601String(),
      'numeroCuotas': numeroCuotas,
      'cuotasPagadas': cuotasPagadas,
      'cuotasPendientes': cuotasPendientes,
      'montoCuota': montoCuota,
      'asesorId': asesorId,
      'nombreAsesor': nombreAsesor,
      'agencia': agencia,
    };
  }
}
