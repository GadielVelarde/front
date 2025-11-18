import 'package:equatable/equatable.dart';
import 'credito.dart';

class SocioDetail extends Equatable {
  final int id;
  final int tdocumento;
  final String ndocumento;
  final String nombreCompleto;
  final int numeroCreditos;
  final DateTime? ultimaFechaPago;
  final String numeroTelefono;
  final String direccion;
  final List<Credito> creditos;

  const SocioDetail({
    required this.id,
    required this.tdocumento,
    required this.ndocumento,
    required this.nombreCompleto,
    required this.numeroCreditos,
    this.ultimaFechaPago,
    required this.numeroTelefono,
    required this.direccion,
    required this.creditos,
  });

  // Getter para compatibilidad con código existente
  String get dni => ndocumento;
  
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
        tdocumento,
        ndocumento,
        nombreCompleto,
        numeroCreditos,
        ultimaFechaPago,
        numeroTelefono,
        direccion,
        creditos,
      ];
}
