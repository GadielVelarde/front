import 'package:mockito/annotations.dart';

@GenerateMocks([SeguimientosRepository])

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import '../../../lib/features/seguimientos/domain/use_cases/seguimientos_use_cases.dart';
import '../../../lib/features/seguimientos/domain/entities/seguimiento.dart';
import '../../../lib/features/seguimientos/domain/repositories/seguimientos_repository.dart';
import '../../../lib/core/errors/failures.dart';


class FakeSeguimientosRepository implements SeguimientosRepository {
  final Seguimiento Function(Seguimiento)? onUpdate;
  final Map<String, dynamic> Function(Seguimiento)? onCreate;
  final Seguimiento Function(String)? onGetById;
  final void Function(String)? onDelete;
  final Seguimiento Function(String, {String? observaciones, double? montoRecaudado})? onComplete;

  FakeSeguimientosRepository({this.onUpdate, this.onCreate, this.onGetById, this.onDelete, this.onComplete});

  @override
  Future<Either<Failure, List<Seguimiento>>> getSeguimientos({String? rutaId, String? asesorId, String? estado}) async {
    return Right([]);
  }

  @override
  Future<Either<Failure, Seguimiento>> getSeguimientoById(String id) async {
    if (onGetById != null) return Right(onGetById!(id));
    return Left(ServerFailure(message: 'Error de servidor'));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createSeguimiento(Seguimiento seguimiento) async {
    if (onCreate != null) return Right(onCreate!(seguimiento));
    return Right({'id': 'new_id'});
  }

  @override
  Future<Either<Failure, Seguimiento>> updateSeguimiento(Seguimiento seguimiento) async {
    if (onUpdate != null) return Right(onUpdate!(seguimiento));
    return Right(seguimiento);
  }

  @override
  Future<Either<Failure, void>> deleteSeguimiento(String id) async {
    if (onDelete != null) onDelete!(id);
    return Right(null);
  }

  @override
  Future<Either<Failure, Seguimiento>> completeSeguimiento(String id, {String? observaciones, double? montoRecaudado}) async {
    if (onComplete != null) return Right(onComplete!(id, observaciones: observaciones, montoRecaudado: montoRecaudado));
    return Left(ServerFailure(message: 'Error de servidor'));
  }
}

void main() {
  test('UC-S01: Debería obtener un seguimiento por ID', () async {
    final seguimiento = Seguimiento(
      id: 's1',
      rutaId: 'r1',
      nombreRuta: 'Ruta 1',
      asesorId: 'a1',
      nombreAsesor: 'Asesor 1',
      clienteId: 'c1',
      nombreCliente: 'Cliente 1',
      tipoVisita: 'cobranza',
      estado: 'pendiente',
      requiereAccion: false,
    );
    final repo = FakeSeguimientosRepository(onGetById: (_) => seguimiento);
    final useCase = GetSeguimientoByIdUseCase(repo);
    final result = await useCase('s1');
    expect(result.isRight(), true);
    result.fold((l) => null, (r) => expect(r, seguimiento));
  });

  test('UC-S02: Debería crear un seguimiento', () async {
    final params = CreateSeguimientoParams(
      rutaId: 'r1',
      nombreRuta: 'Ruta 1',
      asesorId: 'a1',
      nombreAsesor: 'Asesor 1',
      clienteId: 'c1',
      nombreCliente: 'Cliente 1',
      tipoVisita: 'cobranza',
      requiereAccion: false,
    );
    final repo = FakeSeguimientosRepository(onCreate: (_) => {'id': 's2'});
    final useCase = CreateSeguimientoUseCase(repo);
    final result = await useCase(params);
    expect(result.isRight(), true);
    result.fold((l) => null, (r) => expect(r.id, 's2'));
  });

  test('UC-S03: Debería actualizar un seguimiento', () async {
    final seguimiento = Seguimiento(
      id: 's3',
      rutaId: 'r1',
      nombreRuta: 'Ruta 1',
      asesorId: 'a1',
      nombreAsesor: 'Asesor 1',
      clienteId: 'c1',
      nombreCliente: 'Cliente 1',
      tipoVisita: 'cobranza',
      estado: 'pendiente',
      requiereAccion: false,
    );
    final repo = FakeSeguimientosRepository(onUpdate: (_) => seguimiento);
    final useCase = UpdateSeguimientoUseCase(repo);
    final result = await useCase(seguimiento);
    expect(result.isRight(), true);
    result.fold((l) => null, (r) => expect(r, seguimiento));
  });

  test('UC-S04: Debería completar un seguimiento', () async {
    final seguimiento = Seguimiento(
      id: 's4',
      rutaId: 'r1',
      nombreRuta: 'Ruta 1',
      asesorId: 'a1',
      nombreAsesor: 'Asesor 1',
      clienteId: 'c1',
      nombreCliente: 'Cliente 1',
      tipoVisita: 'cobranza',
      estado: 'completada',
      requiereAccion: false,
    );
    final repo = FakeSeguimientosRepository(onComplete: (id, {observaciones, montoRecaudado}) => seguimiento);
    final useCase = CompleteSeguimientoUseCase(repo);
    final params = CompleteSeguimientoParams(id: 's4', observaciones: 'ok', montoRecaudado: 100.0);
    final result = await useCase(params);
    expect(result.isRight(), true);
    result.fold((l) => null, (r) => expect(r, seguimiento));
  });

  test('UC-S05: Debería eliminar un seguimiento', () async {
    bool deleted = false;
    final repo = FakeSeguimientosRepository(onDelete: (_) => deleted = true);
    final useCase = DeleteSeguimientoUseCase(repo);
    final result = await useCase('s5');
    expect(result.isRight(), true);
    expect(deleted, true);
  });
}
