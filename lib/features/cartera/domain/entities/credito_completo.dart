import 'package:equatable/equatable.dart';
import 'socio_basico.dart';

class CreditoCompleto extends Equatable {
  final int id;
  final SocioBasico socio;
  final double montoTotal;
  final double montoPagado;
  final double saldoPendiente;
  final String estado;
  final int diasMora;
  final DateTime fechaDesembolso;
  final DateTime? fechaProximoVencimiento;
  final int numeroCuotas;
  final int cuotasPagadas;
  final int cuotasPendientes;
  final double? montoCuota;
  final int asesorId;
  final String nombreAsesor;
  final String agencia;

  const CreditoCompleto({
    required this.id,
    required this.socio,
    required this.montoTotal,
    required this.montoPagado,
    required this.saldoPendiente,
    required this.estado,
    required this.diasMora,
    required this.fechaDesembolso,
    this.fechaProximoVencimiento,
    required this.numeroCuotas,
    required this.cuotasPagadas,
    required this.cuotasPendientes,
    this.montoCuota,
    required this.asesorId,
    required this.nombreAsesor,
    required this.agencia,
  });

  @override
  List<Object?> get props => [
        id,
        socio,
        montoTotal,
        montoPagado,
        saldoPendiente,
        estado,
        diasMora,
        fechaDesembolso,
        fechaProximoVencimiento,
        numeroCuotas,
        cuotasPagadas,
        cuotasPendientes,
        montoCuota,
        asesorId,
        nombreAsesor,
        agencia,
      ];
}
