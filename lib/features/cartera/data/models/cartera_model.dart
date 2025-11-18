import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/cartera.dart';

part 'cartera_model.g.dart';
@JsonSerializable()
class CarteraModel extends Cartera {
  const CarteraModel({
    required super.id,
    required super.clienteId,
    required super.nombreCliente,
    required super.dni,
    super.telefono,
    super.email,
    required super.agencia,
    required super.zona,
    required super.asesorId,
    required super.nombreAsesor,
    required super.montoTotal,
    required super.montoPagado,
    required super.saldoPendiente,
    required super.diasMora,
    required super.estado,
    super.fechaUltimoPago,
    super.fechaProximoVencimiento,
    super.direccion,
    super.referencia,
    required super.requiereVisita,
    super.observaciones,
  });

  factory CarteraModel.fromJson(final Map<String, dynamic> json) =>
      _$CarteraModelFromJson(json);

  Map<String, dynamic> toJson() => _$CarteraModelToJson(this);
  factory CarteraModel.fromEntity(final Cartera cartera) {
    return CarteraModel(
      id: cartera.id,
      clienteId: cartera.clienteId,
      nombreCliente: cartera.nombreCliente,
      dni: cartera.dni,
      telefono: cartera.telefono,
      email: cartera.email,
      agencia: cartera.agencia,
      zona: cartera.zona,
      asesorId: cartera.asesorId,
      nombreAsesor: cartera.nombreAsesor,
      montoTotal: cartera.montoTotal,
      montoPagado: cartera.montoPagado,
      saldoPendiente: cartera.saldoPendiente,
      diasMora: cartera.diasMora,
      estado: cartera.estado,
      fechaUltimoPago: cartera.fechaUltimoPago,
      fechaProximoVencimiento: cartera.fechaProximoVencimiento,
      direccion: cartera.direccion,
      referencia: cartera.referencia,
      requiereVisita: cartera.requiereVisita,
      observaciones: cartera.observaciones,
    );
  }
}
