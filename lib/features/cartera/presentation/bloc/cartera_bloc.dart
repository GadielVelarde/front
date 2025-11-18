import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/cartera_use_cases.dart';
import 'cartera_event.dart';
import 'cartera_state.dart';
class CarteraBloc extends Bloc<CarteraEvent, CarteraState> {
  final GetCarterasUseCase getCarterasUseCase;
  final GetCarteraByIdUseCase getCarteraByIdUseCase;
  final GetCarterasByAsesorUseCase getCarterasByAsesorUseCase;
  final CreateCarteraUseCase createCarteraUseCase;
  final UpdateCarteraUseCase updateCarteraUseCase;
  final RegistrarPagoUseCase registrarPagoUseCase;
  final MarcarRequiereVisitaUseCase marcarRequiereVisitaUseCase;
  final DeleteCarteraUseCase deleteCarteraUseCase;

  CarteraBloc({
    required this.getCarterasUseCase,
    required this.getCarteraByIdUseCase,
    required this.getCarterasByAsesorUseCase,
    required this.createCarteraUseCase,
    required this.updateCarteraUseCase,
    required this.registrarPagoUseCase,
    required this.marcarRequiereVisitaUseCase,
    required this.deleteCarteraUseCase,
  }) : super(const CarteraInitial()) {
    on<GetCarterasEvent>(_onGetCarteras);
    on<GetCarteraByIdEvent>(_onGetCarteraById);
    on<GetCarterasByAsesorEvent>(_onGetCarterasByAsesor);
    on<CreateCarteraEvent>(_onCreateCartera);
    on<UpdateCarteraEvent>(_onUpdateCartera);
    on<RegistrarPagoEvent>(_onRegistrarPago);
    on<MarcarRequiereVisitaEvent>(_onMarcarRequiereVisita);
    on<DeleteCarteraEvent>(_onDeleteCartera);
  }

  Future<void> _onGetCarteras(
    final GetCarterasEvent event,
    final Emitter<CarteraState> emit,
  ) async {
    emit(const CarteraLoading());
    final result = await getCarterasUseCase();
    result.fold(
      (final failure) => emit(CarteraError(message: failure.message)),
      (final carteras) => emit(CarteraLoaded(carteras: carteras)),
    );
  }

  Future<void> _onGetCarteraById(
    final GetCarteraByIdEvent event,
    final Emitter<CarteraState> emit,
  ) async {
    emit(const CarteraLoading());
    final result = await getCarteraByIdUseCase(event.id);
    result.fold(
      (final failure) => emit(CarteraError(message: failure.message)),
      (final cartera) => emit(CarteraSingleLoaded(cartera: cartera)),
    );
  }

  Future<void> _onGetCarterasByAsesor(
    final GetCarterasByAsesorEvent event,
    final Emitter<CarteraState> emit,
  ) async {
    emit(const CarteraLoading());
    final result = await getCarterasByAsesorUseCase(event.asesorId);
    result.fold(
      (final failure) => emit(CarteraError(message: failure.message)),
      (final carteras) => emit(CarteraLoaded(carteras: carteras)),
    );
  }

  Future<void> _onCreateCartera(
    final CreateCarteraEvent event,
    final Emitter<CarteraState> emit,
  ) async {
    emit(const CarteraLoading());
    final result = await createCarteraUseCase(event.cartera);
    result.fold(
      (final failure) => emit(CarteraError(message: failure.message)),
      (final cartera) => emit(CarteraOperationSuccess(
        message: 'Cartera creada exitosamente',
        cartera: cartera,
      )),
    );
  }

  Future<void> _onUpdateCartera(
    final UpdateCarteraEvent event,
    final Emitter<CarteraState> emit,
  ) async {
    emit(const CarteraLoading());
    final result = await updateCarteraUseCase(event.cartera);
    result.fold(
      (final failure) => emit(CarteraError(message: failure.message)),
      (final cartera) => emit(CarteraOperationSuccess(
        message: 'Cartera actualizada exitosamente',
        cartera: cartera,
      )),
    );
  }

  Future<void> _onRegistrarPago(
    final RegistrarPagoEvent event,
    final Emitter<CarteraState> emit,
  ) async {
    emit(const CarteraLoading());
    final result = await registrarPagoUseCase(
      carteraId: event.carteraId,
      monto: event.monto,
      fecha: event.fecha,
      comprobante: event.comprobante,
    );
    result.fold(
      (final failure) => emit(CarteraError(message: failure.message)),
      (final cartera) => emit(CarteraOperationSuccess(
        message: 'Pago registrado exitosamente',
        cartera: cartera,
      )),
    );
  }

  Future<void> _onMarcarRequiereVisita(
    final MarcarRequiereVisitaEvent event,
    final Emitter<CarteraState> emit,
  ) async {
    emit(const CarteraLoading());
    final result = await marcarRequiereVisitaUseCase(
      carteraId: event.carteraId,
      requiere: event.requiere,
      observaciones: event.observaciones,
    );
    result.fold(
      (final failure) => emit(CarteraError(message: failure.message)),
      (final cartera) => emit(CarteraOperationSuccess(
        message: event.requiere
            ? 'Marcado como requiere visita'
            : 'Visita no requerida',
        cartera: cartera,
      )),
    );
  }

  Future<void> _onDeleteCartera(
    final DeleteCarteraEvent event,
    final Emitter<CarteraState> emit,
  ) async {
    emit(const CarteraLoading());
    final result = await deleteCarteraUseCase(event.id);
    result.fold(
      (final failure) => emit(CarteraError(message: failure.message)),
      (_) => emit(const CarteraOperationSuccess(
        message: 'Cartera eliminada exitosamente',
      )),
    );
  }
}
