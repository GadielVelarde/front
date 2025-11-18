import '../entities/socio.dart';
import '../entities/socio_resumen.dart';
import '../entities/socio_detail.dart';

abstract class SocioRepository {
  Future<(SocioResumen, List<Socio>)> getSocios();
  Future<SocioDetail> getSocioDetail(final int socioId);
}
