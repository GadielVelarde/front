import 'package:equatable/equatable.dart';
import '../../domain/entities/ruta.dart';
abstract class RutasEvent extends Equatable {
  const RutasEvent();

  @override
  List<Object?> get props => [];
}
class GetRutasEvent extends RutasEvent {
  final String? zona;
  final String? agencia;
  final String? asesorId;

  const GetRutasEvent({
    this.zona,
    this.agencia,
    this.asesorId,
  });

  @override
  List<Object?> get props => [zona, agencia, asesorId];
}
class GetRutaByIdEvent extends RutasEvent {
  final String id;

  const GetRutaByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}
class CreateRutaEvent extends RutasEvent {
  final String nombre;
  final String descripcion;
  final String zona;
  final String agencia;
  final String? asesorAsignado;
  final String? tipoRuta;

  const CreateRutaEvent({
    required this.nombre,
    required this.descripcion,
    required this.zona,
    required this.agencia,
    this.asesorAsignado,
    this.tipoRuta,
  });

  @override
  List<Object?> get props => [nombre, descripcion, zona, agencia, asesorAsignado, tipoRuta];
}
class UpdateRutaEvent extends RutasEvent {
  final Ruta ruta;

  const UpdateRutaEvent(this.ruta);

  @override
  List<Object?> get props => [ruta];
}
class DeleteRutaEvent extends RutasEvent {
  final String id;

  const DeleteRutaEvent(this.id);

  @override
  List<Object?> get props => [id];
}
class AssignAsesorEvent extends RutasEvent {
  final String rutaId;
  final String asesorId;

  const AssignAsesorEvent({
    required this.rutaId,
    required this.asesorId,
  });

  @override
  List<Object?> get props => [rutaId, asesorId];
}

// Nuevos eventos para conectividad y sincronización
class ConnectivityChangedEvent extends RutasEvent {
  final bool isConnected;

  const ConnectivityChangedEvent(this.isConnected);

  @override
  List<Object?> get props => [isConnected];
}

class ManualSyncEvent extends RutasEvent {
  const ManualSyncEvent();
}

class UpdateSyncStatusEvent extends RutasEvent {
  final String syncStatus;
  final int unsyncedCount;

  const UpdateSyncStatusEvent({
    required this.syncStatus,
    required this.unsyncedCount,
  });

  @override
  List<Object?> get props => [syncStatus, unsyncedCount];
}
