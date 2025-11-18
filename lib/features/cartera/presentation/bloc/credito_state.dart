import 'package:equatable/equatable.dart';
import '../../domain/entities/credito_completo.dart';

abstract class CreditoState extends Equatable {
  const CreditoState();

  @override
  List<Object?> get props => [];
}

class CreditoInitial extends CreditoState {
  const CreditoInitial();
}

class CreditoLoading extends CreditoState {
  const CreditoLoading();
}

class CreditosLoaded extends CreditoState {
  final List<CreditoCompleto> creditos;

  const CreditosLoaded({required this.creditos});

  @override
  List<Object?> get props => [creditos];
}

class CreditoDetailLoaded extends CreditoState {
  final CreditoCompleto credito;

  const CreditoDetailLoaded({required this.credito});

  @override
  List<Object?> get props => [credito];
}

class CreditoError extends CreditoState {
  final String message;

  const CreditoError({required this.message});

  @override
  List<Object?> get props => [message];
}
