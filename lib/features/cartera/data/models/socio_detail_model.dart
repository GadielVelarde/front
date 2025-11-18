import '../../domain/entities/socio_detail.dart';
import 'credito_model.dart';

class SocioDetailModel extends SocioDetail {
  const SocioDetailModel({
    required super.id,
    required super.tdocumento,
    required super.ndocumento,
    required super.nombreCompleto,
    required super.numeroCreditos,
    super.ultimaFechaPago,
    required super.numeroTelefono,
    required super.direccion,
    required super.creditos,
  });

  factory SocioDetailModel.fromJson(final Map<String, dynamic> json) {
    return SocioDetailModel(
      id: json['id'] as int,
      tdocumento: json['tdocumento'] as int,
      ndocumento: json['ndocumento'] as String,
      nombreCompleto: (json['nombreCompleto'] as String).trim(),
      numeroCreditos: json['numeroCreditos'] as int,
      ultimaFechaPago: json['ultimaFechaPago'] != null
          ? DateTime.parse(json['ultimaFechaPago'] as String)
          : null,
      numeroTelefono: json['numeroTelefono'] as String,
      direccion: json['direccion'] as String,
      creditos: (json['creditos'] as List<dynamic>)
          .map((final e) => CreditoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tdocumento': tdocumento,
      'ndocumento': ndocumento,
      'nombreCompleto': nombreCompleto,
      'numeroCreditos': numeroCreditos,
      'ultimaFechaPago': ultimaFechaPago?.toIso8601String(),
      'numeroTelefono': numeroTelefono,
      'direccion': direccion,
      'creditos': creditos.map((final e) => (e as CreditoModel).toJson()).toList(),
    };
  }
}
