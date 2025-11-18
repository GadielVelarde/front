import 'socio_model.dart';
import 'socio_resumen_model.dart';

class SociosResponseModel {
  final SocioResumenModel resumen;
  final List<SocioModel> socios;

  const SociosResponseModel({
    required this.resumen,
    required this.socios,
  });

  factory SociosResponseModel.fromJson(final Map<String, dynamic> json) {
    return SociosResponseModel(
      resumen: SocioResumenModel.fromJson(json['resumen'] as Map<String, dynamic>),
      socios: (json['socios'] as List<dynamic>)
          .map((final e) => SocioModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resumen': resumen.toJson(),
      'socios': socios.map((final e) => e.toJson()).toList(),
    };
  }
}
