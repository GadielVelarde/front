import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/seguimiento.dart';
abstract class SeguimientosRepository {
  Future<Either<Failure, List<Seguimiento>>> getSeguimientos({
    final String? rutaId,
    final String? asesorId,
    final String? estado,
  });
  Future<Either<Failure, Seguimiento>> getSeguimientoById(final String id);
  Future<Either<Failure, Map<String, dynamic>>> createSeguimiento(final Seguimiento seguimiento);
  Future<Either<Failure, Seguimiento>> updateSeguimiento(final Seguimiento seguimiento);
  Future<Either<Failure, void>> deleteSeguimiento(final String id);
  Future<Either<Failure, Seguimiento>> completeSeguimiento(
    final String id, {
    final String? observaciones,
    final double? montoRecaudado,
  });
}
