import 'package:equatable/equatable.dart';

class Socio extends Equatable {
  final int id;
  final String cdocumento;
  final int tdocumento;
  final int numeroCreditos;
  final DateTime? ultimaFechaPago;
  final String numeroTelefono;
  final String direccion;

  const Socio({
    required this.id,
    required this.cdocumento,
    required this.tdocumento,
    required this.numeroCreditos,
    this.ultimaFechaPago,
    required this.numeroTelefono,
    required this.direccion,
  });

  // Getters para compatibilidad con código existente
  String get dni => cdocumento;
  String get nombreCompleto => 'DNI: $cdocumento';
  
  // Getter para dirección limpia sin "CASERIO:" o "CASERÍO:"
  String get direccionLimpia {
    final direccionUpper = direccion.toUpperCase();
    if (direccionUpper.startsWith('CASERIO:') || direccionUpper.startsWith('CASERÍO:')) {
      return direccion.substring(8).trim();
    }
    return direccion;
  }

  @override
  List<Object?> get props => [
        id,
        cdocumento,
        tdocumento,
        numeroCreditos,
        ultimaFechaPago,
        numeroTelefono,
        direccion,
      ];
}
