import '../../domain/use_cases/get_socio_detail.dart';
import '../../domain/use_cases/get_socios.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'socio_event.dart';
import 'socio_state.dart';

class SocioBloc extends Bloc<SocioEvent, SocioState> {
  final GetSocios getSociosUseCase;
  final GetSocioDetail getSocioDetailUseCase;

  SocioBloc({
    required this.getSociosUseCase,
    required this.getSocioDetailUseCase,
  }) : super(const SocioInitial()) {
    on<GetSociosEvent>(_onGetSocios);
    on<GetSocioDetailEvent>(_onGetSocioDetail);
  }

  Future<void> _onGetSocios(
    final GetSociosEvent event,
    final Emitter<SocioState> emit,
  ) async {
    emit(const SocioLoading());
    try {
      final (resumen, socios) = await getSociosUseCase();
      emit(SociosLoaded(resumen: resumen, socios: socios));
    } catch (e) {
      emit(SocioError(message: e.toString()));
    }
  }

  Future<void> _onGetSocioDetail(
    final GetSocioDetailEvent event,
    final Emitter<SocioState> emit,
  ) async {
    emit(const SocioLoading());
    try {
      final socio = await getSocioDetailUseCase(event.socioId);
      emit(SocioDetailLoaded(socio: socio));
    } catch (e) {
      emit(SocioError(message: e.toString()));
    }
  }
}
