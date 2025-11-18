import '../../models/ruta_model.dart';
abstract class RutasApiService {
  Future<List<RutaModel>> fetchRutas({
    final String? zona,
    final String? agencia,
    final String? asesorId,
  });
  Future<RutaModel?> fetchRutaById(final String id);
  Future<RutaModel> createRuta(final RutaModel ruta);
  Future<RutaModel> updateRuta(final RutaModel ruta);
  Future<void> deleteRutafinal(final String id);
  Future<RutaModel> assignAsesor(final String rutaId, final String asesorId);
}
