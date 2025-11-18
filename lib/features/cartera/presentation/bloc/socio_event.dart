import 'package:equatable/equatable.dart';

abstract class SocioEvent extends Equatable {
  const SocioEvent();

  @override
  List<Object?> get props => [];
}

class GetSociosEvent extends SocioEvent {
  const GetSociosEvent();
}

class GetSocioDetailEvent extends SocioEvent {
  final int socioId;

  const GetSocioDetailEvent(this.socioId);

  @override
  List<Object?> get props => [socioId];
}
