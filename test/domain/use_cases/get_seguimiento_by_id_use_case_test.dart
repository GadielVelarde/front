import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../lib/features/seguimientos/domain/use_cases/seguimientos_use_cases.dart';
import '../../../lib/features/seguimientos/domain/entities/seguimiento.dart';
import '../../../lib/features/seguimientos/domain/repositories/seguimientos_repository.dart';
import '../../../lib/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'mocks.mocks.dart';

@GenerateMocks([SeguimientosRepository])
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
    final mockRepo = MockSeguimientosRepository();
    when(mockRepo.getSeguimientoById(any<String>())).thenAnswer((_) async => Right(seguimiento));
    final useCase = GetSeguimientoByIdUseCase(mockRepo);
    final result = await useCase('s1');
    expect(result.isRight(), true);
    result.fold((l) => null, (r) => expect(r, seguimiento));
  });
}
