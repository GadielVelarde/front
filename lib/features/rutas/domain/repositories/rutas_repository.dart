import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/ruta.dart';
abstract class RutasRepository {
  Future<Either<Failure, List<Ruta>>> getRutas({
    final String? zona,
    final String? agencia,
    final String? asesorId,
  });
  Future<Either<Failure, Ruta>> getRutaById(final String id);
  Future<Either<Failure, Ruta>> createRuta(final Ruta ruta);
  Future<Either<Failure, Ruta>> updateRuta(final Ruta ruta);
  Future<Either<Failure, void>> deleteRuta(final String id);
  Future<Either<Failure, Ruta>> assignAsesor(final String rutaId, final String asesorId);
}
