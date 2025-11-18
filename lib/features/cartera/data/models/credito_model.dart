import '../../domain/entities/credito.dart';

class CreditoModel extends Credito {
  const CreditoModel({
    required super.id,
    super.fechaProximoPago,
  });

  factory CreditoModel.fromJson(final Map<String, dynamic> json) {
    return CreditoModel(
      id: json['id'] as int,
      fechaProximoPago: json['fechaProximoPago'] != null
          ? DateTime.parse(json['fechaProximoPago'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fechaProximoPago': fechaProximoPago?.toIso8601String(),
    };
  }
}
