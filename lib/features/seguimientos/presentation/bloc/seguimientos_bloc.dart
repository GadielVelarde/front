import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/seguimientos_use_cases.dart';
import 'seguimientos_event.dart';
import 'seguimientos_state.dart';

class SeguimientosBloc extends Bloc<SeguimientosEvent, SeguimientosState> {
  final GetSeguimientosUseCase getSeguimientosUseCase;
  final GetSeguimientoByIdUseCase getSeguimientoByIdUseCase;
  final CompleteSeguimientoUseCase completeSeguimientoUseCase;
  final DeleteSeguimientoUseCase deleteSeguimientoUseCase;

  SeguimientosBloc({
    required this.getSeguimientosUseCase,
    required this.getSeguimientoByIdUseCase,
    required this.completeSeguimientoUseCase,
    required this.deleteSeguimientoUseCase,
  }) : super(const SeguimientosInitial()) {
    on<GetSeguimientosEvent>(_onGetSeguimientos);
    on<GetSeguimientoByIdEvent>(_onGetSeguimientoById);
    on<CompleteSeguimientoEvent>(_onCompleteSeguimiento);
    on<DeleteSeguimientoEvent>(_onDeleteSeguimiento);
  }

  Future<void> _onGetSeguimientos(final GetSeguimientosEvent event, final Emitter<SeguimientosState> emit) async {
    emit(const SeguimientosLoading());
    final result = await getSeguimientosUseCase(GetSeguimientosParams(rutaId: event.rutaId, asesorId: event.asesorId, estado: event.estado));
    result.fold(
      (final failure) => emit(SeguimientosError(message: failure.message, code: failure.code)),
      (final seguimientos) => emit(SeguimientosLoaded(seguimientos: seguimientos)),
    );
  }

  Future<void> _onGetSeguimientoById(final GetSeguimientoByIdEvent event, final Emitter<SeguimientosState> emit) async {
    emit(const SeguimientosLoading());
    final result = await getSeguimientoByIdUseCase(event.id);
    result.fold(
      (final failure) => emit(SeguimientosError(message: failure.message, code: failure.code)),
      (final seguimiento) => emit(SeguimientoLoaded(seguimiento: seguimiento)),
    );
  }

  Future<void> _onCompleteSeguimiento(final CompleteSeguimientoEvent event, final Emitter<SeguimientosState> emit) async {
    emit(const SeguimientosLoading());
    final result = await completeSeguimientoUseCase(CompleteSeguimientoParams(id: event.id, observaciones: event.observaciones, montoRecaudado: event.montoRecaudado));
    result.fold(
      (final failure) => emit(SeguimientosError(message: failure.message, code: failure.code)),
      (final seguimiento) => emit(SeguimientoOperationSuccess(message: 'Seguimiento completado', seguimiento: seguimiento)),
    );
  }

  Future<void> _onDeleteSeguimiento(final DeleteSeguimientoEvent event, final Emitter<SeguimientosState> emit) async {
    emit(const SeguimientosLoading());
    final result = await deleteSeguimientoUseCase(event.id);
    result.fold(
      (final failure) => emit(SeguimientosError(message: failure.message, code: failure.code)),
      (_) => emit(const SeguimientoOperationSuccess(message: 'Seguimiento eliminado')),
    );
  }
}
