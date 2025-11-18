import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:seguimiento_norandino/core/errors/failures.dart';
import 'package:seguimiento_norandino/features/rutas/domain/entities/ruta.dart';
import 'package:seguimiento_norandino/features/rutas/domain/use_cases/rutas_use_cases.dart';
import 'package:seguimiento_norandino/features/rutas/domain/repositories/rutas_repository.dart';

class FakeRutasRepository implements RutasRepository {
  final Ruta Function(Ruta)? onUpdate;
  FakeRutasRepository({this.onUpdate});

  @override
  Future<Either<Failure, List<Ruta>>> getRutas({final String? zona, final String? agencia, final String? asesorId}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Ruta>> getRutaById(final String id) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Ruta>> createRuta(final Ruta ruta) async {
    return Right(ruta);
  }

  @override
  Future<Either<Failure, Ruta>> updateRuta(final Ruta ruta) async {
    if (onUpdate != null) return Right(onUpdate!(ruta));
    return Right(ruta);
  }

  @override
  Future<Either<Failure, void>> deleteRuta(final String id) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Ruta>> assignAsesor(final String rutaId, final String asesorId) {
    throw UnimplementedError();
  }
}

void main() {
  test('UC-R05: Jefe aprueba una ruta correctamente (via UpdateRutaUseCase)', () async {
    final rutaId = 'r1';
    final ruta = Ruta(
      id: rutaId,
      nombre: 'Ruta X',
      descripcion: 'desc',
      zona: 'zona',
      agencia: 'ag',
      fechaCreacion: DateTime.now(),
      estado: 'Pendiente',
    );

    final approved = Ruta(
      id: rutaId,
      nombre: ruta.nombre,
      descripcion: ruta.descripcion,
      zona: ruta.zona,
      agencia: ruta.agencia,
      fechaCreacion: ruta.fechaCreacion,
      estado: 'Aprobada',
    );

    final fake = FakeRutasRepository(onUpdate: (_) => approved);
    final useCase = UpdateRutaUseCase(fake);

    final result = await useCase(ruta);
    expect(result.isRight(), true);
    result.fold((final l) => null, (final r) => expect(r.estado, 'Aprobada'));
  });

  test('UC-R05: Jefe deniega una ruta con motivo (via UpdateRutaUseCase)', () async {
    final rutaId = 'r1';
    final ruta = Ruta(
      id: rutaId,
      nombre: 'Ruta Y',
      descripcion: 'desc',
      zona: 'zona',
      agencia: 'ag',
      fechaCreacion: DateTime.now(),
      estado: 'Pendiente',
    );

    final denied = Ruta(
      id: rutaId,
      nombre: ruta.nombre,
      descripcion: 'Denegada: motivo',
      zona: ruta.zona,
      agencia: ruta.agencia,
      fechaCreacion: ruta.fechaCreacion,
      estado: 'Denegada',
    );

    final fake = FakeRutasRepository(onUpdate: (_) => denied);
    final useCase = UpdateRutaUseCase(fake);

    final result = await useCase(ruta);
    expect(result.isRight(), true);
    result.fold((final l) => null, (final r) => expect(r.estado, 'Denegada'));
  });
}
