import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cartera.dart';
abstract class CarteraRepository {
  Future<Either<Failure, List<Cartera>>> getCarteras();
  Future<Either<Failure, Cartera>> getCarteraById(final String id);
  Future<Either<Failure, List<Cartera>>> getCarterasByAsesor(final String asesorId);
  Future<Either<Failure, Cartera>> createCartera(final Cartera cartera);
  Future<Either<Failure, Cartera>> updateCartera(final Cartera cartera);
  Future<Either<Failure, Cartera>> registrarPago({
    required final String carteraId,
    required final double monto,
    required final DateTime fecha,
    final String? comprobante,
  });
  Future<Either<Failure, Cartera>> marcarRequiereVisita({
    required final String carteraId,
    required final bool requiere,
    final String? observaciones,
  });
  Future<Either<Failure, void>> deleteCartera(final String id);
}
