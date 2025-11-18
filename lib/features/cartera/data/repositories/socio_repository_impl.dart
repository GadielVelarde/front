import '../../domain/entities/socio.dart';
import '../../domain/entities/socio_resumen.dart';
import '../../domain/entities/socio_detail.dart';
import '../../domain/repositories/socio_repository.dart';
import '../data_sources/remote/socio_api_service.dart';

class SocioRepositoryImpl implements SocioRepository {
  final SocioApiService apiService;

  SocioRepositoryImpl({required this.apiService});

  @override
  Future<(SocioResumen, List<Socio>)> getSocios() async {
    try {
      final response = await apiService.getSocios();
      return (response.resumen, response.socios);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SocioDetail> getSocioDetail(final int socioId) async {
    try {
      final detail = await apiService.getSocioDetail(socioId);
      return detail;
    } catch (e) {
      rethrow;
    }
  }
}
