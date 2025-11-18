import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/cartera.dart';
import '../../domain/repositories/cartera_repository.dart';
import '../data_sources/remote/cartera_api_service.dart';
import '../models/cartera_model.dart';
class CarteraRepositoryImpl implements CarteraRepository {
  final CarteraApiService apiService;

  CarteraRepositoryImpl({required this.apiService});

  @override
  Future<Either<Failure, List<Cartera>>> getCarteras() async {
    try {
      final carteras = await apiService.getCarteras();
      return Right(carteras);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al obtener carteras: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Cartera>> getCarteraById(final String id) async {
    try {
      final cartera = await apiService.getCarteraById(id);
      return Right(cartera);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al obtener cartera: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Cartera>>> getCarterasByAsesor(final String asesorId) async {
    try {
      final carteras = await apiService.getCarterasByAsesor(asesorId);
      return Right(carteras);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al obtener carteras del asesor: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Cartera>> createCartera(final Cartera cartera) async {
    try {
      final carteraModel = await apiService.createCartera(CarteraModel.fromEntity(cartera));
      return Right(carteraModel);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al crear cartera: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Cartera>> updateCartera(final Cartera cartera) async {
    try {
      final carteraModel = await apiService.updateCartera(CarteraModel.fromEntity(cartera));
      return Right(carteraModel);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al actualizar cartera: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Cartera>> registrarPago({
    required final String carteraId,
    required final double monto,
    required final DateTime fecha,
    final String? comprobante,
  }) async {
    try {
      final cartera = await apiService.registrarPago(
        carteraId: carteraId,
        monto: monto,
        fecha: fecha,
        comprobante: comprobante,
      );
      return Right(cartera);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al registrar pago: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Cartera>> marcarRequiereVisita({
    required final String carteraId,
    required final bool requiere,
    final String? observaciones,
  }) async {
    try {
      final cartera = await apiService.marcarRequiereVisita(
        carteraId: carteraId,
        requiere: requiere,
        observaciones: observaciones,
      );
      return Right(cartera);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al marcar visita: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCartera(final String id) async {
    try {
      await apiService.deleteCartera(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al eliminar cartera: ${e.toString()}'));
    }
  }
}
