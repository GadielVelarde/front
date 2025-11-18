import 'package:equatable/equatable.dart';
class Cartera extends Equatable {
  final String id;
  final String clienteId;
  final String nombreCliente;
  final String dni;
  final String? telefono;
  final String? email;
  final String agencia;
  final String zona;
  final String asesorId;
  final String nombreAsesor;
  final double montoTotal;
  final double montoPagado;
  final double saldoPendiente;
  final int diasMora;
  final String estado; // al_dia, en_mora, vencido, juridico
  final DateTime? fechaUltimoPago;
  final DateTime? fechaProximoVencimiento;
  final String? direccion;
  final String? referencia;
  final bool requiereVisita;
  final String? observaciones;

  const Cartera({
    required this.id,
    required this.clienteId,
    required this.nombreCliente,
    required this.dni,
    this.telefono,
    this.email,
    required this.agencia,
    required this.zona,
    required this.asesorId,
    required this.nombreAsesor,
    required this.montoTotal,
    required this.montoPagado,
    required this.saldoPendiente,
    required this.diasMora,
    required this.estado,
    this.fechaUltimoPago,
    this.fechaProximoVencimiento,
    this.direccion,
    this.referencia,
    required this.requiereVisita,
    this.observaciones,
  });

  @override
  List<Object?> get props => [
        id,
        clienteId,
        nombreCliente,
        dni,
        telefono,
        email,
        agencia,
        zona,
        asesorId,
        nombreAsesor,
        montoTotal,
        montoPagado,
        saldoPendiente,
        diasMora,
        estado,
        fechaUltimoPago,
        fechaProximoVencimiento,
        direccion,
        referencia,
        requiereVisita,
        observaciones,
      ];
  double get porcentajePagado => montoTotal > 0 ? (montoPagado / montoTotal * 100) : 0;
  bool get estaAlDia => estado == 'al_dia';
  bool get estaEnMora => estado == 'en_mora';
  bool get estaVencido => estado == 'vencido';
  bool get estaEnJuridico => estado == 'juridico';
  bool get tieneMora => diasMora > 0;

  @override
  bool get stringify => true;
}
