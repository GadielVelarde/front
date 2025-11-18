import 'package:equatable/equatable.dart';

class SocioResumen extends Equatable {
  final int totalSocios;
  final int sociosAlDia;
  final int sociosEnMora;

  const SocioResumen({
    required this.totalSocios,
    required this.sociosAlDia,
    required this.sociosEnMora,
  });

  @override
  List<Object?> get props => [totalSocios, sociosAlDia, sociosEnMora];
}
