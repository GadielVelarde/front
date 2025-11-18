import '../entities/socio_detail.dart';
import '../repositories/socio_repository.dart';

class GetSocioDetail {
  final SocioRepository repository;

  GetSocioDetail(this.repository);

  Future<SocioDetail> call(final int socioId) {
    return repository.getSocioDetail(socioId);
  }
}
