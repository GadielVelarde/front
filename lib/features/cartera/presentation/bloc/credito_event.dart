import 'package:equatable/equatable.dart';

abstract class CreditoEvent extends Equatable {
  const CreditoEvent();

  @override
  List<Object> get props => [];
}

class GetCreditosBySocioEvent extends CreditoEvent {
  final int socioId;

  const GetCreditosBySocioEvent(this.socioId);

  @override
  List<Object> get props => [socioId];
}

class GetCreditoDetailEvent extends CreditoEvent {
  final int creditoId;

  const GetCreditoDetailEvent(this.creditoId);

  @override
  List<Object> get props => [creditoId];
}
