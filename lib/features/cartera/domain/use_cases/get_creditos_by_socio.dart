import '../entities/credito_completo.dart';
import '../repositories/credito_repository.dart';

class GetCreditosBySocio {
  final CreditoRepository repository;

  GetCreditosBySocio(this.repository);

  Future<List<CreditoCompleto>> call(final int socioId) {
    return repository.getCreditosBySocio(socioId);
  }
}
