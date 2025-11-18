import '../../domain/entities/socio_basico.dart';

class SocioBasicoModel extends SocioBasico {
  const SocioBasicoModel({
    required super.id,
    required super.tdocumento,
    required super.cdocumento,
    required super.nombreCompleto,
    required super.numeroTelefono,
    required super.direccion,
  });

  factory SocioBasicoModel.fromJson(final Map<String, dynamic> json) {
    return SocioBasicoModel(
      id: json['id'] as int,
      tdocumento: json['tdocumento'] as int,
      cdocumento: json['cdocumento'] as String,
      nombreCompleto: (json['nombreCompleto'] as String).trim(),
      numeroTelefono: json['numeroTelefono'] as String,
      direccion: json['direccion'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tdocumento': tdocumento,
      'cdocumento': cdocumento,
      'nombreCompleto': nombreCompleto,
      'numeroTelefono': numeroTelefono,
      'direccion': direccion,
    };
  }
}
