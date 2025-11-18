import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_creditos_by_socio.dart';
import '../../domain/use_cases/get_credito_detail.dart';
import 'credito_event.dart';
import 'credito_state.dart';

class CreditoBloc extends Bloc<CreditoEvent, CreditoState> {
  final GetCreditosBySocio getCreditosBySocioUseCase;
  final GetCreditoDetail getCreditoDetailUseCase;

  CreditoBloc({
    required this.getCreditosBySocioUseCase,
    required this.getCreditoDetailUseCase,
  }) : super(const CreditoInitial()) {
    on<GetCreditosBySocioEvent>(_onGetCreditosBySocio);
    on<GetCreditoDetailEvent>(_onGetCreditoDetail);
  }

  Future<void> _onGetCreditosBySocio(
    final GetCreditosBySocioEvent event,
    final Emitter<CreditoState> emit,
  ) async {
    emit(const CreditoLoading());
    try {
      final creditos = await getCreditosBySocioUseCase(event.socioId);
      emit(CreditosLoaded(creditos: creditos));
    } catch (e) {
      emit(CreditoError(message: e.toString()));
    }
  }

  Future<void> _onGetCreditoDetail(
    final GetCreditoDetailEvent event,
    final Emitter<CreditoState> emit,
  ) async {
    emit(const CreditoLoading());
    try {
      final credito = await getCreditoDetailUseCase(event.creditoId);
      emit(CreditoDetailLoaded(credito: credito));
    } catch (e) {
      emit(CreditoError(message: e.toString()));
    }
  }
}
