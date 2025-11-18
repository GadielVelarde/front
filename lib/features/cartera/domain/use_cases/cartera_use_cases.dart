import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cartera.dart';
import '../repositories/cartera_repository.dart';
class GetCarterasUseCase {
  final CarteraRepository repository;

  GetCarterasUseCase(this.repository);

  Future<Either<Failure, List<Cartera>>> call() async {
    return await repository.getCarteras();
  }
}
class GetCarteraByIdUseCase {
  final CarteraRepository repository;

  GetCarteraByIdUseCase(this.repository);

  Future<Either<Failure, Cartera>> call(final String id) async {
    if (id.isEmpty) {
      return const Left(ValidationFailure(message: ''));
    }
    return await repository.getCarteraById(id);
  }
}
class GetCarterasByAsesorUseCase {
  final CarteraRepository repository;

  GetCarterasByAsesorUseCase(this.repository);

  Future<Either<Failure, List<Cartera>>> call(final String asesorId) async {
    if (asesorId.isEmpty) {
      return const Left(ValidationFailure(message: ''));
    }
    return await repository.getCarterasByAsesor(asesorId);
  }
}
class CreateCarteraUseCase {
  final CarteraRepository repository;

  CreateCarteraUseCase(this.repository);

  Future<Either<Failure, Cartera>> call(final Cartera cartera) async {
    if (cartera.nombreCliente.isEmpty) {
      return const Left(ValidationFailure(message: ''));
    }
    if (cartera.dni.isEmpty) {
      return const Left(ValidationFailure(message: ''));
    }
    if (cartera.montoTotal <= 0) {
      return const Left(ValidationFailure(message: ''));
    }

    return await repository.createCartera(cartera);
  }
}
class UpdateCarteraUseCase {
  final CarteraRepository repository;

  UpdateCarteraUseCase(this.repository);

  Future<Either<Failure, Cartera>> call(final Cartera cartera) async {
    if (cartera.id.isEmpty) {
      return const Left(ValidationFailure(message: ''));
    }
    return await repository.updateCartera(cartera);
  }
}
class RegistrarPagoUseCase {
  final CarteraRepository repository;

  RegistrarPagoUseCase(this.repository);

  Future<Either<Failure, Cartera>> call({
    required final String carteraId,
    required final double monto,
    required final DateTime fecha,
    final String? comprobante,
  }) async {
    if (carteraId.isEmpty) {
      return const Left(ValidationFailure(message: ''));
    }
    if (monto <= 0) {
      return const Left(ValidationFailure(message: ''));
    }
    if (fecha.isAfter(DateTime.now())) {
      return const Left(ValidationFailure(message: ''));
    }

    return await repository.registrarPago(
      carteraId: carteraId,
      monto: monto,
      fecha: fecha,
      comprobante: comprobante,
    );
  }
}
class MarcarRequiereVisitaUseCase {
  final CarteraRepository repository;

  MarcarRequiereVisitaUseCase(this.repository);

  Future<Either<Failure, Cartera>> call({
    required final String carteraId,
    required final bool requiere,
    final String? observaciones,
  }) async {
    if (carteraId.isEmpty) {
      return const Left(ValidationFailure(message: ''));
    }

    return await repository.marcarRequiereVisita(
      carteraId: carteraId,
      requiere: requiere,
      observaciones: observaciones,
    );
  }
}
class DeleteCarteraUseCase {
  final CarteraRepository repository;

  DeleteCarteraUseCase(this.repository);

  Future<Either<Failure, void>> call(final String id) async {
    if (id.isEmpty) {
      return const Left(ValidationFailure(message: ''));
    }
    return await repository.deleteCartera(id);
  }
}
