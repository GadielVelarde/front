import '../entities/credito_completo.dart';
import '../repositories/credito_repository.dart';

class GetCreditoDetail {
  final CreditoRepository repository;

  GetCreditoDetail(this.repository);

  Future<CreditoCompleto> call(final int creditoId) async {
    return await repository.getCreditoDetail(creditoId);
  }
}
