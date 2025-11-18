import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/ruta.dart';
import '../repositories/rutas_repository.dart';
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(final Params params);
}
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
class GetRutasUseCase implements UseCase<List<Ruta>, GetRutasParams> {
  final RutasRepository repository;

  GetRutasUseCase(this.repository);

  @override
  Future<Either<Failure, List<Ruta>>> call(final GetRutasParams params) async {
    return await repository.getRutas(
      zona: params.zona,
      agencia: params.agencia,
      asesorId: params.asesorId,
    );
  }
}

class GetRutasParams extends Equatable {
  final String? zona;
  final String? agencia;
  final String? asesorId;

  const GetRutasParams({
    this.zona,
    this.agencia,
    this.asesorId,
  });

  @override
  List<Object?> get props => [zona, agencia, asesorId];
}
class GetRutaByIdUseCase implements UseCase<Ruta, String> {
  final RutasRepository repository;

  GetRutaByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Ruta>> call(final String id) async {
    if (id.isEmpty) {
      return const Left(ValidationFailure(message: 'ID de ruta inválido'));
    }
    return await repository.getRutaById(id);
  }
}
class CreateRutaUseCase implements UseCase<Ruta, CreateRutaParams> {
  final RutasRepository repository;

  CreateRutaUseCase(this.repository);

  @override
  Future<Either<Failure, Ruta>> call(final CreateRutaParams params) async {
    if (params.nombre.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'El nombre de la ruta es requerido'));
    }
    if (params.zona.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'La zona es requerida'));
    }
    if (params.agencia.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'La agencia es requerida'));
    }

    final ruta = Ruta(
      id: '', // Se genera en el backend
      nombre: params.nombre.trim(),
      descripcion: params.descripcion.trim(),
      zona: params.zona.trim(),
      agencia: params.agencia.trim(),
      asesorAsignado: params.asesorAsignado,
      tipoRuta: params.tipoRuta,
      estado: 'activa',
      fechaCreacion: DateTime.now(),
    );

    return await repository.createRuta(ruta);
  }
}

class CreateRutaParams extends Equatable {
  final String nombre;
  final String descripcion;
  final String zona;
  final String agencia;
  final String? asesorAsignado;
  final String? tipoRuta;

  const CreateRutaParams({
    required this.nombre,
    required this.descripcion,
    required this.zona,
    required this.agencia,
    this.asesorAsignado,
    this.tipoRuta,
  });

  @override
  List<Object?> get props => [nombre, descripcion, zona, agencia, asesorAsignado, tipoRuta];
}
class UpdateRutaUseCase implements UseCase<Ruta, Ruta> {
  final RutasRepository repository;

  UpdateRutaUseCase(this.repository);

  @override
  Future<Either<Failure, Ruta>> call(final Ruta ruta) async {
    if (ruta.id.isEmpty) {
      return const Left(ValidationFailure(message: 'ID de ruta inválido'));
    }
    if (ruta.nombre.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'El nombre de la ruta es requerido'));
    }
    return await repository.updateRuta(ruta);
  }
}
class DeleteRutaUseCase implements UseCase<void, String> {
  final RutasRepository repository;

  DeleteRutaUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(final String id) async {
    if (id.isEmpty) {
      return const Left(ValidationFailure(message: 'ID de ruta inválido'));
    }
    return await repository.deleteRuta(id);
  }
}
class AssignAsesorUseCase implements UseCase<Ruta, AssignAsesorParams> {
  final RutasRepository repository;

  AssignAsesorUseCase(this.repository);

  @override
  Future<Either<Failure, Ruta>> call(final AssignAsesorParams params) async {
    if (params.rutaId.isEmpty) {
      return const Left(ValidationFailure(message: 'ID de ruta inválido'));
    }
    if (params.asesorId.isEmpty) {
      return const Left(ValidationFailure(message: 'ID de asesor inválido'));
    }
    return await repository.assignAsesor(params.rutaId, params.asesorId);
  }
}

class AssignAsesorParams extends Equatable {
  final String rutaId;
  final String asesorId;

  const AssignAsesorParams({
    required this.rutaId,
    required this.asesorId,
  });

  @override
  List<Object?> get props => [rutaId, asesorId];
}
