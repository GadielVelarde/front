import 'package:dio/dio.dart';
import '../../models/cartera_model.dart';
import 'cartera_api_service.dart';

class CarteraApiServiceImpl implements CarteraApiService {
  // ignore: unused_field
  final Dio _dio;

  CarteraApiServiceImpl(this._dio);

  final List<CarteraModel> _mockCarteras = [
    CarteraModel(
      id: '1',
      clienteId: 'cli001',
      nombreCliente: 'Juan Pérez García',
      dni: '45678912',
      telefono: '987654321',
      email: 'juan.perez@email.com',
      agencia: 'Agencia Norte',
      zona: 'Cajamarca',
      asesorId: 'ase001',
      nombreAsesor: 'María López',
      montoTotal: 5000.00,
      montoPagado: 3500.00,
      saldoPendiente: 1500.00,
      diasMora: 0,
      estado: 'al_dia',
      fechaUltimoPago: DateTime.now().subtract(const Duration(days: 15)),
      fechaProximoVencimiento: DateTime.now().add(const Duration(days: 15)),
      direccion: 'Av. Comercio 123, Cajamarca',
      referencia: 'Frente al mercado central',
      requiereVisita: false,
      observaciones: 'Cliente puntual en sus pagos',
    ),
    CarteraModel(
      id: '2',
      clienteId: 'cli002',
      nombreCliente: 'Ana Torres Ruiz',
      dni: '78912345',
      telefono: '912345678',
      agencia: 'Agencia Sur',
      zona: 'Chota',
      asesorId: 'ase002',
      nombreAsesor: 'Carlos Ramírez',
      montoTotal: 8000.00,
      montoPagado: 4000.00,
      saldoPendiente: 4000.00,
      diasMora: 15,
      estado: 'en_mora',
      fechaUltimoPago: DateTime.now().subtract(const Duration(days: 45)),
      fechaProximoVencimiento: DateTime.now().subtract(const Duration(days: 15)),
      direccion: 'Jr. Lima 456, Chota',
      referencia: 'Cerca de la plaza de armas',
      requiereVisita: true,
      observaciones: 'Cliente con retraso, requiere seguimiento',
    ),
    CarteraModel(
      id: '3',
      clienteId: 'cli003',
      nombreCliente: 'Roberto Sánchez Vega',
      dni: '12345678',
      telefono: '998877665',
      email: 'roberto.sanchez@email.com',
      agencia: 'Agencia Centro',
      zona: 'Hualgayoc',
      asesorId: 'ase001',
      nombreAsesor: 'María López',
      montoTotal: 12000.00,
      montoPagado: 2000.00,
      saldoPendiente: 10000.00,
      diasMora: 45,
      estado: 'vencido',
      fechaUltimoPago: DateTime.now().subtract(const Duration(days: 90)),
      fechaProximoVencimiento: DateTime.now().subtract(const Duration(days: 45)),
      direccion: 'Calle Independencia 789, Hualgayoc',
      requiereVisita: true,
      observaciones: 'Cliente en situación de mora crítica, evaluar acción jurídica',
    ),
    CarteraModel(
      id: '4',
      clienteId: 'cli004',
      nombreCliente: 'Lucía Mendoza Castro',
      dni: '98765432',
      telefono: '955443322',
      agencia: 'Agencia Norte',
      zona: 'Cajamarca',
      asesorId: 'ase003',
      nombreAsesor: 'Pedro González',
      montoTotal: 3500.00,
      montoPagado: 3500.00,
      saldoPendiente: 0.00,
      diasMora: 0,
      estado: 'al_dia',
      fechaUltimoPago: DateTime.now().subtract(const Duration(days: 5)),
      fechaProximoVencimiento: DateTime.now().add(const Duration(days: 25)),
      direccion: 'Av. Atahualpa 321, Cajamarca',
      referencia: 'Al lado del banco',
      requiereVisita: false,
      observaciones: 'Cliente cumplió con todas sus cuotas',
    ),
    CarteraModel(
      id: '5',
      clienteId: 'cli005',
      nombreCliente: 'Miguel Flores Quispe',
      dni: '56789123',
      telefono: '966554433',
      agencia: 'Agencia Sur',
      zona: 'Chota',
      asesorId: 'ase002',
      nombreAsesor: 'Carlos Ramírez',
      montoTotal: 6500.00,
      montoPagado: 5500.00,
      saldoPendiente: 1000.00,
      diasMora: 8,
      estado: 'en_mora',
      fechaUltimoPago: DateTime.now().subtract(const Duration(days: 38)),
      fechaProximoVencimiento: DateTime.now().subtract(const Duration(days: 8)),
      direccion: 'Jr. Bolognesi 654, Chota',
      requiereVisita: true,
      observaciones: 'Cliente prometió pagar esta semana',
    ),
  ];

  @override
  Future<List<CarteraModel>> getCarteras() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return _mockCarteras;
  }

  @override
  Future<CarteraModel> getCarteraById(final String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    try {
      return _mockCarteras.firstWhere((final c) => c.id == id);
    } catch (e) {
      throw Exception('Cartera no encontrada');
    }
  }

  @override
  Future<List<CarteraModel>> getCarterasByAsesor(final String asesorId) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return _mockCarteras.where((final c) => c.asesorId == asesorId).toList();
  }

  @override
  Future<CarteraModel> createCartera(final CarteraModel cartera) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    _mockCarteras.add(cartera);
    return cartera;
  }

  @override
  Future<CarteraModel> updateCartera(final CarteraModel cartera) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final index = _mockCarteras.indexWhere((final c) => c.id == cartera.id);
    if (index != -1) {
      _mockCarteras[index] = cartera;
      return cartera;
    }
    throw Exception('Cartera no encontrada');
  }

  @override
  Future<CarteraModel> registrarPago({
    required final String carteraId,
    required final double monto,
    required final DateTime fecha,
    final String? comprobante,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    final cartera = await getCarteraById(carteraId);
    
    final updatedCartera = CarteraModel(
      id: cartera.id,
      clienteId: cartera.clienteId,
      nombreCliente: cartera.nombreCliente,
      dni: cartera.dni,
      telefono: cartera.telefono,
      email: cartera.email,
      agencia: cartera.agencia,
      zona: cartera.zona,
      asesorId: cartera.asesorId,
      nombreAsesor: cartera.nombreAsesor,
      montoTotal: cartera.montoTotal,
      montoPagado: cartera.montoPagado + monto,
      saldoPendiente: cartera.saldoPendiente - monto,
      diasMora: 0, // Reset mora al pagar
      estado: 'al_dia',
      fechaUltimoPago: fecha,
      fechaProximoVencimiento: cartera.fechaProximoVencimiento,
      direccion: cartera.direccion,
      referencia: cartera.referencia,
      requiereVisita: false,
      observaciones: 'Pago registrado el ${fecha.toIso8601String()}',
    );

    return await updateCartera(updatedCartera);
  }

  @override
  Future<CarteraModel> marcarRequiereVisita({
    required final String carteraId,
    required final bool requiere,
    final String? observaciones,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final cartera = await getCarteraById(carteraId);
    
    final updatedCartera = CarteraModel(
      id: cartera.id,
      clienteId: cartera.clienteId,
      nombreCliente: cartera.nombreCliente,
      dni: cartera.dni,
      telefono: cartera.telefono,
      email: cartera.email,
      agencia: cartera.agencia,
      zona: cartera.zona,
      asesorId: cartera.asesorId,
      nombreAsesor: cartera.nombreAsesor,
      montoTotal: cartera.montoTotal,
      montoPagado: cartera.montoPagado,
      saldoPendiente: cartera.saldoPendiente,
      diasMora: cartera.diasMora,
      estado: cartera.estado,
      fechaUltimoPago: cartera.fechaUltimoPago,
      fechaProximoVencimiento: cartera.fechaProximoVencimiento,
      direccion: cartera.direccion,
      referencia: cartera.referencia,
      requiereVisita: requiere,
      observaciones: observaciones ?? cartera.observaciones,
    );

    return await updateCartera(updatedCartera);
  }

  @override
  Future<void> deleteCartera(final String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _mockCarteras.removeWhere((final c) => c.id == id);
  }
}
