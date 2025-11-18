import 'package:equatable/equatable.dart';
class Ruta extends Equatable {
  final String id;
  final String nombre;
  final String descripcion;
  final String zona;
  final String agencia;
  final String? asesorAsignado;
  final String? tipoRuta; // jefe, asesor
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;
  final String? estado; // activa, inactiva, completada
  final int? totalVisitas;
  final int? visitasCompletadas;

  const Ruta({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.zona,
    required this.agencia,
    this.asesorAsignado,
    this.tipoRuta,
    this.fechaCreacion,
    this.fechaActualizacion,
    this.estado,
    this.totalVisitas,
    this.visitasCompletadas,
  });

  @override
  List<Object?> get props => [
        id,
        nombre,
        descripcion,
        zona,
        agencia,
        asesorAsignado,
        tipoRuta,
        fechaCreacion,
        fechaActualizacion,
        estado,
        totalVisitas,
        visitasCompletadas,
      ];

  double get progreso {
    if (totalVisitas == null || totalVisitas == 0) return 0.0;
    return (visitasCompletadas ?? 0) / totalVisitas!;
  }

  bool get estaCompleta => estado == 'completada';
  bool get estaActiva => estado == 'activa';
}
