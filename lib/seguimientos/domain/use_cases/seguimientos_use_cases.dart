import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/seguimiento.dart';
import '../repositories/seguimientos_repository.dart';
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(final Params params);
}
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
class GetSeguimientosUseCase implements UseCase<List<Seguimiento>, GetSeguimientosParams> {
  final SeguimientosRepository repository;

  GetSeguimientosUseCase(this.repository);

  @override
  Future<Either<Failure, List<Seguimiento>>> call(final GetSeguimientosParams params) async {
    return await repository.getSeguimientos(
      rutaId: params.rutaId,
      asesorId: params.asesorId,
      estado: params.estado,
    );
  }
}

class GetSeguimientosParams extends Equatable {
  final String? rutaId;
  final String? asesorId;
  final String? estado;

  const GetSeguimientosParams({
    this.rutaId,
    this.asesorId,
    this.estado,
  });

  @override
  List<Object?> get props => [rutaId, asesorId, estado];
}
class GetSeguimientoByIdUseCase implements UseCase<Seguimiento, String> {
  final SeguimientosRepository repository;

  GetSeguimientoByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Seguimiento>> call(final String id) async {
    if (id.isEmpty) {
      return const Left(ValidationFailure(message: 'ID de seguimiento inválido'));
    }
    return await repository.getSeguimientoById(id);
  }
}
class CreateSeguimientoUseCase implements UseCase<Seguimiento, CreateSeguimientoParams> {
  final SeguimientosRepository repository;

  CreateSeguimientoUseCase(this.repository);

  @override
  Future<Either<Failure, Seguimiento>> call(final CreateSeguimientoParams params) async {
    if (params.rutaId.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'La ruta es requerida'));
    }
    if (params.clienteId.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'El cliente es requerido'));
    }
    if (params.tipoVisita.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'El tipo de visita es requerido'));
    }

    final seguimiento = Seguimiento(
      id: '', // Se genera en el backend
      rutaId: params.rutaId,
      nombreRuta: params.nombreRuta,
      asesorId: params.asesorId,
      nombreAsesor: params.nombreAsesor,
      clienteId: params.clienteId,
      nombreCliente: params.nombreCliente,
      tipoVisita: params.tipoVisita,
      observaciones: params.observaciones,
      fechaProgramada: params.fechaProgramada,
      estado: 'pendiente',
      requiereAccion: params.requiereAccion,
      accionRequerida: params.accionRequerida,
    );

    final result = await repository.createSeguimiento(seguimiento);
    
    return result.fold(
      (final failure) => Left(failure),
      (final responseMap) {
        // Reconstruir el seguimiento con el ID retornado del backend
        final createdSeguimiento = seguimiento.copyWith(
          id: responseMap['id']?.toString() ?? '',
        );
        return Right(createdSeguimiento);
      },
    );
  }
}

class CreateSeguimientoParams extends Equatable {
  final String rutaId;
  final String nombreRuta;
  final String asesorId;
  final String nombreAsesor;
  final String clienteId;
  final String nombreCliente;
  final String tipoVisita;
  final String? observaciones;
  final DateTime? fechaProgramada;
  final bool requiereAccion;
  final String? accionRequerida;

  const CreateSeguimientoParams({
    required this.rutaId,
    required this.nombreRuta,
    required this.asesorId,
    required this.nombreAsesor,
    required this.clienteId,
    required this.nombreCliente,
    required this.tipoVisita,
    this.observaciones,
    this.fechaProgramada,
    required this.requiereAccion,
    this.accionRequerida,
  });

  @override
  List<Object?> get props => [
        rutaId,
        nombreRuta,
        asesorId,
        nombreAsesor,
        clienteId,
        nombreCliente,
        tipoVisita,
        observaciones,
        fechaProgramada,
        requiereAccion,
        accionRequerida,
      ];
}
class UpdateSeguimientoUseCase implements UseCase<Seguimiento, Seguimiento> {
  final SeguimientosRepository repository;

  UpdateSeguimientoUseCase(this.repository);

  @override
  Future<Either<Failure, Seguimiento>> call(final Seguimiento seguimiento) async {
    if (seguimiento.id.isEmpty) {
      return const Left(ValidationFailure(message: 'ID de seguimiento inválido'));
    }
    return await repository.updateSeguimiento(seguimiento);
  }
}
class CompleteSeguimientoUseCase implements UseCase<Seguimiento, CompleteSeguimientoParams> {
  final SeguimientosRepository repository;

  CompleteSeguimientoUseCase(this.repository);

  @override
  Future<Either<Failure, Seguimiento>> call(final CompleteSeguimientoParams params) async {
    if (params.id.isEmpty) {
      return const Left(ValidationFailure(message: 'ID de seguimiento inválido'));
    }
    return await repository.completeSeguimiento(
      params.id,
      observaciones: params.observaciones,
      montoRecaudado: params.montoRecaudado,
    );
  }
}

class CompleteSeguimientoParams extends Equatable {
  final String id;
  final String? observaciones;
  final double? montoRecaudado;

  const CompleteSeguimientoParams({
    required this.id,
    this.observaciones,
    this.montoRecaudado,
  });

  @override
  List<Object?> get props => [id, observaciones, montoRecaudado];
}
class DeleteSeguimientoUseCase implements UseCase<void, String> {
  final SeguimientosRepository repository;

  DeleteSeguimientoUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(final String id) async {
    if (id.isEmpty) {
      return const Left(ValidationFailure(message: 'ID de seguimiento inválido'));
    }
    return await repository.deleteSeguimiento(id);
  }
}
