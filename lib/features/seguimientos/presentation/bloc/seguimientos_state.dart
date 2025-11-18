import 'package:equatable/equatable.dart';
import '../../domain/entities/seguimiento.dart';

abstract class SeguimientosState extends Equatable {
  const SeguimientosState();
  @override
  List<Object?> get props => [];
}

class SeguimientosInitial extends SeguimientosState {
  const SeguimientosInitial();
}

class SeguimientosLoading extends SeguimientosState {
  const SeguimientosLoading();
}

class SeguimientosLoaded extends SeguimientosState {
  final List<Seguimiento> seguimientos;
  const SeguimientosLoaded({required this.seguimientos});
  @override
  List<Object?> get props => [seguimientos];
}

class SeguimientoLoaded extends SeguimientosState {
  final Seguimiento seguimiento;
  const SeguimientoLoaded({required this.seguimiento});
  @override
  List<Object?> get props => [seguimiento];
}

class SeguimientoOperationSuccess extends SeguimientosState {
  final String message;
  final Seguimiento? seguimiento;
  const SeguimientoOperationSuccess({required this.message, this.seguimiento});
  @override
  List<Object?> get props => [message, seguimiento];
}

class SeguimientosError extends SeguimientosState {
  final String message;
  final String? code;
  const SeguimientosError({required this.message, this.code});
  @override
  List<Object?> get props => [message, code];
}
