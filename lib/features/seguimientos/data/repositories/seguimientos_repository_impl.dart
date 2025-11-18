import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/seguimiento.dart';
import '../../domain/repositories/seguimientos_repository.dart';
import '../data_sources/remote/seguimientos_api_service.dart';
import '../models/seguimiento_model.dart';

class SeguimientosRepositoryImpl implements SeguimientosRepository {
  final SeguimientosApiService apiService;

  SeguimientosRepositoryImpl({required this.apiService});

  @override
  Future<Either<Failure, List<Seguimiento>>> getSeguimientos({final String? rutaId, final String? asesorId, final String? estado}) async {
    try {
      final seguimientos = await apiService.fetchSeguimientos(rutaId: rutaId, asesorId: asesorId, estado: estado);
      return Right(seguimientos);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Error al obtener seguimientos', data: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Seguimiento>> getSeguimientoById(final String id) async {
    try {
      final seguimiento = await apiService.fetchSeguimientoById(id);
      if (seguimiento != null) return Right(seguimiento);
      return const Left(CacheFailure(message: 'Seguimiento no encontrado'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Error al obtener seguimiento', data: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createSeguimiento(final Seguimiento seguimiento) async {
    try {
      final seguimientoModel = await apiService.createSeguimiento(SeguimientoModel.fromEntity(seguimiento));
      return Right(seguimientoModel);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Error al crear seguimiento', data: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Seguimiento>> updateSeguimiento(final Seguimiento seguimiento) async {
    try {
      final seguimientoModel = await apiService.updateSeguimiento(SeguimientoModel.fromEntity(seguimiento));
      return Right(seguimientoModel);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Error al actualizar seguimiento', data: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSeguimiento(final String id) async {
    try {
      await apiService.deleteSeguimiento(id);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Error al eliminar seguimiento', data: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Seguimiento>> completeSeguimiento(final String id, {final String? observaciones, final double? montoRecaudado}) async {
    try {
      final seguimiento = await apiService.completeSeguimiento(id, observaciones: observaciones, montoRecaudado: montoRecaudado);
      return Right(seguimiento);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Error al completar seguimiento', data: e.toString()));
    }
  }
}
