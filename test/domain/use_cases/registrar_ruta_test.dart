import 'package:flutter_test/flutter_test.dart';
import 'package:seguimiento_norandino/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:seguimiento_norandino/features/rutas/domain/entities/ruta.dart';
import 'package:seguimiento_norandino/features/rutas/domain/use_cases/rutas_use_cases.dart';
import 'package:seguimiento_norandino/features/rutas/domain/repositories/rutas_repository.dart';

// Mock del repositorio (simple fake used in tests)
class FakeRutasRepository implements RutasRepository {
  final Ruta Function(Ruta)? onCreate;

  FakeRutasRepository({this.onCreate});

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
    if (onCreate != null) {
      return Right(onCreate!(ruta));
    }
    return Right(ruta);
  }

  @override
  Future<Either<Failure, Ruta>> updateRuta(final Ruta ruta) {
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
  late CreateRutaUseCase registrarRuta;
  late FakeRutasRepository mockRutaRepository;

  setUp(() {
    mockRutaRepository = FakeRutasRepository();
    registrarRuta = CreateRutaUseCase(mockRutaRepository);
  });

  test('UC-R01: Debería registrar una nueva ruta correctamente', () async {
    final params = const CreateRutaParams(
      nombre: 'Ruta Lima 08/11',
      descripcion: 'Descripcion prueba',
      zona: 'Lima',
      agencia: 'Agencia 1',
    );

    // ignore: unused_local_variable
    final rutaCreada = Ruta(
      id: 'r1',
      nombre: params.nombre,
      descripcion: params.descripcion,
      zona: params.zona,
      agencia: params.agencia,
      fechaCreacion: DateTime.now(),
      estado: 'activa',
    );

    final resultado = await registrarRuta(params);

    expect(resultado.isRight(), true);
    resultado.fold((final l) => null, (final r) => expect(r.nombre, params.nombre));
  // Use FakeRutasRepository's onCreate to validate behavior if needed
  });
}
