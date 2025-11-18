import '../entities/credito_completo.dart';

abstract class CreditoRepository {
  Future<List<CreditoCompleto>> getCreditosBySocio(final int socioId);
  Future<CreditoCompleto> getCreditoDetail(final int creditoId);
}
