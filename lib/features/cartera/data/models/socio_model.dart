import '../../domain/entities/socio.dart';

class SocioModel extends Socio {
  const SocioModel({
    required super.id,
    required super.cdocumento,
    required super.tdocumento,
    required super.numeroCreditos,
    super.ultimaFechaPago,
    required super.numeroTelefono,
    required super.direccion,
  });

  factory SocioModel.fromJson(final Map<String, dynamic> json) {
    return SocioModel(
      id: json['id'] as int,
      cdocumento: json['cdocumento'] as String,
      tdocumento: json['tdocumento'] as int,
      numeroCreditos: json['numeroCreditos'] as int,
      ultimaFechaPago: json['ultimaFechaPago'] != null 
          ? DateTime.parse(json['ultimaFechaPago'] as String)
          : null,
      numeroTelefono: json['numeroTelefono'] as String,
      direccion: json['direccion'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cdocumento': cdocumento,
      'tdocumento': tdocumento,
      'numeroCreditos': numeroCreditos,
      'ultimaFechaPago': ultimaFechaPago?.toIso8601String(),
      'numeroTelefono': numeroTelefono,
      'direccion': direccion,
    };
  }
}
