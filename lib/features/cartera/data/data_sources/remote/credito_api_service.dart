import '../../models/credito_completo_model.dart';

abstract class CreditoApiService {
  Future<List<CreditoCompletoModel>> getCreditosBySocio(final int socioId);
  Future<CreditoCompletoModel> getCreditoDetail(final int creditoId);
}
