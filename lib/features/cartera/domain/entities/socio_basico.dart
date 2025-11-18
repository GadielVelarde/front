import 'package:equatable/equatable.dart';

class SocioBasico extends Equatable {
  final int id;
  final int tdocumento;
  final String cdocumento;
  final String nombreCompleto;
  final String numeroTelefono;
  final String direccion;

  const SocioBasico({
    required this.id,
    required this.tdocumento,
    required this.cdocumento,
    required this.nombreCompleto,
    required this.numeroTelefono,
    required this.direccion,
  });

  @override
  List<Object?> get props => [
        id,
        tdocumento,
        cdocumento,
        nombreCompleto,
        numeroTelefono,
        direccion,
      ];
}
