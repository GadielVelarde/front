import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import '../../../lib/features/seguimientos/domain/use_cases/seguimientos_use_cases.dart';
import '../../../lib/features/seguimientos/domain/entities/seguimiento.dart';
import '../../../lib/features/seguimientos/domain/repositories/seguimientos_repository.dart';
import '../../../lib/core/errors/failures.dart';
import 'delete_seguimiento_use_case_test.mocks.dart';

@GenerateMocks([SeguimientosRepository])
void main() {
  test('UC-S05: Debería eliminar un seguimiento', () async {
    final mockRepo = MockSeguimientosRepository();
    when(mockRepo.deleteSeguimiento(any)).thenAnswer((_) async => const Right<void, void>(null));
    final useCase = DeleteSeguimientoUseCase(mockRepo);
    final result = await useCase('s5');
    expect(result.isRight(), true);
  });
}
