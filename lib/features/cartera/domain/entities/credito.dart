import 'package:equatable/equatable.dart';

class Credito extends Equatable {
  final int id;
  final DateTime? fechaProximoPago;

  const Credito({
    required this.id,
    this.fechaProximoPago,
  });

  @override
  List<Object?> get props => [id, fechaProximoPago];
}
