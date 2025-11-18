import '../../models/cartera_model.dart';
abstract class CarteraApiService {
  Future<List<CarteraModel>> getCarteras();
  Future<CarteraModel> getCarteraById(final String id);
  Future<List<CarteraModel>> getCarterasByAsesor(final String asesorId);
  Future<CarteraModel> createCartera(final CarteraModel cartera);
  Future<CarteraModel> updateCartera(final CarteraModel cartera);
  Future<CarteraModel> registrarPago({
    required final String carteraId,
    required final double monto,
    required final DateTime fecha,
    final String? comprobante,
  });
  Future<CarteraModel> marcarRequiereVisita({
    required final String carteraId,
    required final bool requiere,
    final String? observaciones,
  });
  Future<void> deleteCartera(final String id);
}
