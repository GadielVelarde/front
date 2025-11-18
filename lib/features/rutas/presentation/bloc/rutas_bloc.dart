import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/database/services/rutas_sync_service.dart';
import '../../domain/use_cases/rutas_use_cases.dart';
import 'rutas_event.dart';
import 'rutas_state.dart';

class RutasBloc extends Bloc<RutasEvent, RutasState> {
  final GetRutasUseCase getRutasUseCase;
  final GetRutaByIdUseCase getRutaByIdUseCase;
  final CreateRutaUseCase createRutaUseCase;
  final UpdateRutaUseCase updateRutaUseCase;
  final DeleteRutaUseCase deleteRutaUseCase;
  final AssignAsesorUseCase assignAsesorUseCase;
  final ConnectivityService connectivityService;
  final RutasSyncService syncService;

  StreamSubscription<bool>? _connectivitySubscription;

  RutasBloc({
    required this.getRutasUseCase,
    required this.getRutaByIdUseCase,
    required this.createRutaUseCase,
    required this.updateRutaUseCase,
    required this.deleteRutaUseCase,
    required this.assignAsesorUseCase,
    required this.connectivityService,
    required this.syncService,
  }) : super(const RutasInitial()) {
    on<GetRutasEvent>(_onGetRutas);
    on<GetRutaByIdEvent>(_onGetRutaById);
    on<CreateRutaEvent>(_onCreateRuta);
    on<UpdateRutaEvent>(_onUpdateRuta);
    on<DeleteRutaEvent>(_onDeleteRuta);
    on<AssignAsesorEvent>(_onAssignAsesor);
    on<ConnectivityChangedEvent>(_onConnectivityChanged);
    on<ManualSyncEvent>(_onManualSync);
    on<UpdateSyncStatusEvent>(_onUpdateSyncStatus);

    // Escuchar cambios de conectividad
    _connectivitySubscription = connectivityService.connectionStream.listen(
      (final isConnected) => add(ConnectivityChangedEvent(isConnected)),
    );
  }
  Future<void> _onGetRutas(
    final GetRutasEvent event,
    final Emitter<RutasState> emit,
  ) async {
    emit(const RutasLoading());

    final result = await getRutasUseCase(
      GetRutasParams(
        zona: event.zona,
        agencia: event.agencia,
        asesorId: event.asesorId,
      ),
    );

    // Obtener estado de conectividad y sincronización
    final isConnected = await connectivityService.checkConnection();
    final stats = await syncService.getSyncStats();

    result.fold(
      (final failure) => emit(RutasError(
        message: failure.message,
        code: failure.code,
      )),
      (final rutas) => emit(RutasLoaded(
        rutas: rutas,
        isConnected: isConnected,
        syncStatus: 'idle',
        unsyncedCount: (stats['unsynced'] as int?) ?? 0,
      )),
    );
  }
  Future<void> _onGetRutaById(
    final GetRutaByIdEvent event,
    final Emitter<RutasState> emit,
  ) async {
    emit(const RutasLoading());

    final result = await getRutaByIdUseCase(event.id);

    result.fold(
      (final failure) => emit(RutasError(
        message: failure.message,
        code: failure.code,
      )),
      (final ruta) => emit(RutaLoaded(ruta: ruta)),
    );
  }
  Future<void> _onCreateRuta(
    final CreateRutaEvent event,
    final Emitter<RutasState> emit,
  ) async {
    emit(const RutasLoading());

    final result = await createRutaUseCase(
      CreateRutaParams(
        nombre: event.nombre,
        descripcion: event.descripcion,
        zona: event.zona,
        agencia: event.agencia,
        asesorAsignado: event.asesorAsignado,
        tipoRuta: event.tipoRuta,
      ),
    );

    result.fold(
      (final failure) => emit(RutasError(
        message: failure.message,
        code: failure.code,
      )),
      (final ruta) => emit(RutaOperationSuccess(
        message: 'Ruta creada exitosamente',
        ruta: ruta,
      )),
    );
  }
  Future<void> _onUpdateRuta(
    final UpdateRutaEvent event,
    final Emitter<RutasState> emit,
  ) async {
    emit(const RutasLoading());

    final result = await updateRutaUseCase(event.ruta);

    result.fold(
      (final failure) => emit(RutasError(
        message: failure.message,
        code: failure.code,
      )),
      (final ruta) => emit(RutaOperationSuccess(
        message: 'Ruta actualizada exitosamente',
        ruta: ruta,
      )),
    );
  }
  Future<void> _onDeleteRuta(
    final DeleteRutaEvent event,
    final Emitter<RutasState> emit,
  ) async {
    emit(const RutasLoading());

    final result = await deleteRutaUseCase(event.id);

    result.fold(
      (final failure) => emit(RutasError(
        message: failure.message,
        code: failure.code,
      )),
      (_) => emit(const RutaOperationSuccess(
        message: 'Ruta eliminada exitosamente',
      )),
    );
  }
  Future<void> _onAssignAsesor(
    final AssignAsesorEvent event,
    final Emitter<RutasState> emit,
  ) async {
    emit(const RutasLoading());

    final result = await assignAsesorUseCase(
      AssignAsesorParams(
        rutaId: event.rutaId,
        asesorId: event.asesorId,
      ),
    );

    result.fold(
      (final failure) => emit(RutasError(
        message: failure.message,
        code: failure.code,
      )),
      (final ruta) => emit(RutaOperationSuccess(
        message: 'Asesor asignado exitosamente',
        ruta: ruta,
      )),
    );
  }

  // Nuevos handlers para conectividad y sincronización
  Future<void> _onConnectivityChanged(
    final ConnectivityChangedEvent event,
    final Emitter<RutasState> emit,
  ) async {
    final currentState = state;
    
    // Si estamos en estado RutasLoaded, actualizar el estado de conectividad
    if (currentState is RutasLoaded) {
      final stats = await syncService.getSyncStats();
      emit(currentState.copyWith(
        isConnected: event.isConnected,
        unsyncedCount: (stats['unsynced'] as int?) ?? 0,
      ));

      // Si se restauró la conexión, obtener stats actualizados después de sync
      if (event.isConnected) {
        // Esperar un momento para que el auto-sync se ejecute
        await Future<void>.delayed(const Duration(seconds: 2));
        final updatedStats = await syncService.getSyncStats();
        emit(currentState.copyWith(
          unsyncedCount: (updatedStats['unsynced'] as int?) ?? 0,
        ));
      }
    }
  }

  Future<void> _onManualSync(
    final ManualSyncEvent event,
    final Emitter<RutasState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is RutasLoaded) {
      // Indicar que se está sincronizando
      emit(currentState.copyWith(syncStatus: 'syncing'));

      try {
        // Ejecutar sincronización
        await syncService.syncAll();
        
        // Obtener estadísticas actualizadas
        final stats = await syncService.getSyncStats();
        
        // Recargar rutas
        final result = await getRutasUseCase(const GetRutasParams());
        
        result.fold(
          (final failure) {
            emit(currentState.copyWith(
              syncStatus: 'error',
              unsyncedCount: (stats['unsynced'] as int?) ?? 0,
            ));
          },
          (final rutas) {
            emit(RutasLoaded(
              rutas: rutas,
              isConnected: currentState.isConnected,
              syncStatus: 'synced',
              unsyncedCount: (stats['unsynced'] as int?) ?? 0,
            ));
          },
        );
      } catch (e) {
        emit(currentState.copyWith(syncStatus: 'error'));
      }
    }
  }

  Future<void> _onUpdateSyncStatus(
    final UpdateSyncStatusEvent event,
    final Emitter<RutasState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is RutasLoaded) {
      emit(currentState.copyWith(
        syncStatus: event.syncStatus,
        unsyncedCount: event.unsyncedCount,
      ));
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
