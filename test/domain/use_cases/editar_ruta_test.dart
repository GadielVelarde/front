import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:seguimiento_norandino/core/errors/failures.dart';
import 'package:seguimiento_norandino/features/rutas/domain/use_cases/rutas_use_cases.dart';
import 'package:seguimiento_norandino/features/rutas/domain/entities/ruta.dart';
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
  

  test('UC-R02: Debería actualizar los datos de una ruta planificada', () async {
    final rutaActualizada = Ruta(
      id: 'r1',
      nombre: 'Ruta Lima Actualizada',
      descripcion: 'Descripcion de prueba',
      zona: 'Lima Centro',
      agencia: 'Agencia 1',
      fechaCreacion: DateTime(2025, 11, 9),
      estado: 'Planificada',
    );

    // Use a fake repo that returns the updated route
    final localFake = FakeRutasRepository(onUpdate: (_) => rutaActualizada);
    final localUseCase = UpdateRutaUseCase(localFake);

    final resultado = await localUseCase(rutaActualizada);

    expect(resultado.isRight(), true);
    resultado.fold((final l) => null, (final r) => expect(r, rutaActualizada));
  });
}
