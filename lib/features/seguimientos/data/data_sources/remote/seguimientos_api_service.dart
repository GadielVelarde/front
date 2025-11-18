import '../../models/seguimiento_model.dart';

abstract class SeguimientosApiService {
  Future<List<SeguimientoModel>> fetchSeguimientos({final String? rutaId, final String? asesorId, final String? estado});
  Future<SeguimientoModel?> fetchSeguimientoById(final String id);
  Future<Map<String, dynamic>> createSeguimiento(final SeguimientoModel seguimiento);
  Future<SeguimientoModel> updateSeguimiento(final SeguimientoModel seguimiento);
  Future<void> deleteSeguimiento(final String id);
  Future<SeguimientoModel> completeSeguimiento(final String id, {final String? observaciones, final double? montoRecaudado});
}
