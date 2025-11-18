import 'package:equatable/equatable.dart';
import '../../domain/entities/socio.dart';
import '../../domain/entities/socio_resumen.dart';
import '../../domain/entities/socio_detail.dart';

abstract class SocioState extends Equatable {
  const SocioState();

  @override
  List<Object?> get props => [];
}

class SocioInitial extends SocioState {
  const SocioInitial();
}

class SocioLoading extends SocioState {
  const SocioLoading();
}

class SociosLoaded extends SocioState {
  final SocioResumen resumen;
  final List<Socio> socios;

  const SociosLoaded({
    required this.resumen,
    required this.socios,
  });

  @override
  List<Object?> get props => [resumen, socios];
}

class SocioDetailLoaded extends SocioState {
  final SocioDetail socio;

  const SocioDetailLoaded({required this.socio});

  @override
  List<Object?> get props => [socio];
}

class SocioError extends SocioState {
  final String message;

  const SocioError({required this.message});

  @override
  List<Object?> get props => [message];
}
