import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import '../../../lib/features/seguimientos/domain/use_cases/seguimientos_use_cases.dart';
import '../../../lib/features/seguimientos/domain/entities/seguimiento.dart';
import '../../../lib/features/seguimientos/domain/repositories/seguimientos_repository.dart';
import '../../../lib/core/errors/failures.dart';
import 'complete_seguimiento_use_case_test.mocks.dart';

@GenerateMocks([SeguimientosRepository])
void main() {
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
    final mockRepo = MockSeguimientosRepository();
    when(mockRepo.completeSeguimiento(any, observaciones: anyNamed('observaciones'), montoRecaudado: anyNamed('montoRecaudado')))
      .thenAnswer((_) async => Right(seguimiento));
    final useCase = CompleteSeguimientoUseCase(mockRepo);
    final params = CompleteSeguimientoParams(id: 's4', observaciones: 'ok', montoRecaudado: 100.0);
    final result = await useCase(params);
    expect(result.isRight(), true);
    result.fold((l) => null, (r) => expect(r, seguimiento));
  });
}
