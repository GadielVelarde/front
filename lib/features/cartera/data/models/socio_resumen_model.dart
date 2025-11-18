import '../../domain/entities/socio_resumen.dart';

class SocioResumenModel extends SocioResumen {
  const SocioResumenModel({
    required super.totalSocios,
    required super.sociosAlDia,
    required super.sociosEnMora,
  });

  factory SocioResumenModel.fromJson(final Map<String, dynamic> json) {
    return SocioResumenModel(
      totalSocios: json['totalSocios'] as int,
      sociosAlDia: json['sociosAlDia'] as int,
      sociosEnMora: json['sociosEnMora'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalSocios': totalSocios,
      'sociosAlDia': sociosAlDia,
      'sociosEnMora': sociosEnMora,
    };
  }
}
