import 'package:equatable/equatable.dart';

abstract class SeguimientosEvent extends Equatable {
  const SeguimientosEvent();
  @override
  List<Object?> get props => [];
}

class GetSeguimientosEvent extends SeguimientosEvent {
  final String? rutaId;
  final String? asesorId;
  final String? estado;
  const GetSeguimientosEvent({this.rutaId, this.asesorId, this.estado});
  @override
  List<Object?> get props => [rutaId, asesorId, estado];
}

class GetSeguimientoByIdEvent extends SeguimientosEvent {
  final String id;
  const GetSeguimientoByIdEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class CompleteSeguimientoEvent extends SeguimientosEvent {
  final String id;
  final String? observaciones;
  final double? montoRecaudado;
  const CompleteSeguimientoEvent({required this.id, this.observaciones, this.montoRecaudado});
  @override
  List<Object?> get props => [id, observaciones, montoRecaudado];
}

class DeleteSeguimientoEvent extends SeguimientosEvent {
  final String id;
  const DeleteSeguimientoEvent(this.id);
  @override
  List<Object?> get props => [id];
}
