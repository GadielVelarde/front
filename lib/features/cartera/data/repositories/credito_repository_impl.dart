import '../../domain/entities/credito_completo.dart';
import '../../domain/repositories/credito_repository.dart';
import '../data_sources/remote/credito_api_service.dart';

class CreditoRepositoryImpl implements CreditoRepository {
  final CreditoApiService apiService;

  CreditoRepositoryImpl({required this.apiService});

  @override
  Future<List<CreditoCompleto>> getCreditosBySocio(final int socioId) async {
    try {
      final creditos = await apiService.getCreditosBySocio(socioId);
      return creditos;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CreditoCompleto> getCreditoDetail(final int creditoId) async {
    try {
      final creditoModel = await apiService.getCreditoDetail(creditoId);
      return creditoModel;
    } catch (e) {
      rethrow;
    }
  }
}
