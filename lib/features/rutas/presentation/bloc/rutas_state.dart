import 'package:equatable/equatable.dart';
import '../../domain/entities/ruta.dart';
abstract class RutasState extends Equatable {
  const RutasState();

  @override
  List<Object?> get props => [];
}
class RutasInitial extends RutasState {
  const RutasInitial();
}
class RutasLoading extends RutasState {
  const RutasLoading();
}
class RutasLoaded extends RutasState {
  final List<Ruta> rutas;
  final bool isConnected;
  final String syncStatus; // 'idle', 'syncing', 'synced', 'error'
  final int unsyncedCount;

  const RutasLoaded({
    required this.rutas,
    this.isConnected = true,
    this.syncStatus = 'idle',
    this.unsyncedCount = 0,
  });

  RutasLoaded copyWith({
    final List<Ruta>? rutas,
    final bool? isConnected,
    final String? syncStatus,
    final int? unsyncedCount,
  }) {
    return RutasLoaded(
      rutas: rutas ?? this.rutas,
      isConnected: isConnected ?? this.isConnected,
      syncStatus: syncStatus ?? this.syncStatus,
      unsyncedCount: unsyncedCount ?? this.unsyncedCount,
    );
  }

  @override
  List<Object?> get props => [rutas, isConnected, syncStatus, unsyncedCount];
}
class RutaLoaded extends RutasState {
  final Ruta ruta;

  const RutaLoaded({required this.ruta});

  @override
  List<Object?> get props => [ruta];
}
class RutaOperationSuccess extends RutasState {
  final String message;
  final Ruta? ruta;

  const RutaOperationSuccess({
    required this.message,
    this.ruta,
  });

  @override
  List<Object?> get props => [message, ruta];
}
class RutasError extends RutasState {
  final String message;
  final String? code;

  const RutasError({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}
