import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import '../../../lib/features/seguimientos/domain/use_cases/seguimientos_use_cases.dart';
import '../../../lib/features/seguimientos/domain/entities/seguimiento.dart';
import '../../../lib/features/seguimientos/domain/repositories/seguimientos_repository.dart';
import '../../../lib/core/errors/failures.dart';
import 'create_seguimiento_use_case_test.mocks.dart';

@GenerateMocks([SeguimientosRepository])
void main() {
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
    final mockRepo = MockSeguimientosRepository();
    when(mockRepo.createSeguimiento(any)).thenAnswer((_) async => Right({'id': 's2'}));
    final useCase = CreateSeguimientoUseCase(mockRepo);
    final result = await useCase(params);
    expect(result.isRight(), true);
    result.fold((l) => null, (r) => expect(r.id, 's2'));
  });
}
