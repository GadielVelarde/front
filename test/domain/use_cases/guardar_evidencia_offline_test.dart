import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:seguimiento_norandino/core/errors/failures.dart';
import 'package:seguimiento_norandino/features/rutas/domain/use_cases/rutas_use_cases.dart';
import 'package:seguimiento_norandino/features/rutas/domain/repositories/rutas_repository.dart';
import 'package:seguimiento_norandino/features/rutas/domain/entities/ruta.dart';

class FakeRutasRepository implements RutasRepository {
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
    throw UnimplementedError();
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
  test('CreateRutaUseCase validation: nombre requerido', () async {
    final fake = FakeRutasRepository();
    final useCase = CreateRutaUseCase(fake);

    final params = const CreateRutaParams(
      nombre: '   ',
      descripcion: 'desc',
      zona: 'z',
      agencia: 'a',
    );

    final result = await useCase(params);
    expect(result.isLeft(), true);
    result.fold((final l) => expect(l, isA<ValidationFailure>()), (final r) => null);
  });
}
