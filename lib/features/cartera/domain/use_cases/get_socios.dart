import '../entities/socio.dart';
import '../entities/socio_resumen.dart';
import '../repositories/socio_repository.dart';

class GetSocios {
  final SocioRepository repository;

  GetSocios(this.repository);

  Future<(SocioResumen, List<Socio>)> call() {
    return repository.getSocios();
  }
}
