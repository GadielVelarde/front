import 'package:equatable/equatable.dart';
import '../../domain/entities/cartera.dart';
abstract class CarteraEvent extends Equatable {
  const CarteraEvent();

  @override
  List<Object?> get props => [];
}
class GetCarterasEvent extends CarteraEvent {
  const GetCarterasEvent();
}
class GetCarteraByIdEvent extends CarteraEvent {
  final String id;

  const GetCarteraByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}
class GetCarterasByAsesorEvent extends CarteraEvent {
  final String asesorId;

  const GetCarterasByAsesorEvent(this.asesorId);

  @override
  List<Object?> get props => [asesorId];
}
class CreateCarteraEvent extends CarteraEvent {
  final Cartera cartera;

  const CreateCarteraEvent(this.cartera);

  @override
  List<Object?> get props => [cartera];
}
class UpdateCarteraEvent extends CarteraEvent {
  final Cartera cartera;

  const UpdateCarteraEvent(this.cartera);

  @override
  List<Object?> get props => [cartera];
}
class RegistrarPagoEvent extends CarteraEvent {
  final String carteraId;
  final double monto;
  final DateTime fecha;
  final String? comprobante;

  const RegistrarPagoEvent({
    required this.carteraId,
    required this.monto,
    required this.fecha,
    this.comprobante,
  });

  @override
  List<Object?> get props => [carteraId, monto, fecha, comprobante];
}
class MarcarRequiereVisitaEvent extends CarteraEvent {
  final String carteraId;
  final bool requiere;
  final String? observaciones;

  const MarcarRequiereVisitaEvent({
    required this.carteraId,
    required this.requiere,
    this.observaciones,
  });

  @override
  List<Object?> get props => [carteraId, requiere, observaciones];
}
class DeleteCarteraEvent extends CarteraEvent {
  final String id;

  const DeleteCarteraEvent(this.id);

  @override
  List<Object?> get props => [id];
}
