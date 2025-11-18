import '../../models/socios_response_model.dart';
import '../../models/socio_detail_model.dart';

abstract class SocioApiService {
  Future<SociosResponseModel> getSocios();
  Future<SocioDetailModel> getSocioDetail(final int socioId);
}
