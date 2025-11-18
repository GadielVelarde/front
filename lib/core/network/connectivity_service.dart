import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Servicio para monitorear el estado de conectividad de red
/// Proporciona un Stream para escuchar cambios en tiempo real
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final _connectionStatusController = StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isConnected = false;

  Stream<bool> get connectionStream => _connectionStatusController.stream;

  bool get isConnected => _isConnected;

  /// Inicializa el servicio de conectividad
  Future<void> initialize() async {
    await _updateConnectionStatus();

    // Escuchar cambios de conectividad
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (final List<ConnectivityResult> results) async {
        await _updateConnectionStatus();
      },
      onError: (final error) {
        _isConnected = false;
        _connectionStatusController.add(false);
      },
    );
  }

  /// Actualiza el estado de conexión y notifica a los listeners
  Future<void> _updateConnectionStatus() async {
    try {
      final result = await _connectivity.checkConnectivity();
      final wasConnected = _isConnected;
      
      _isConnected = result.any((final element) => 
        element == ConnectivityResult.wifi ||
        element == ConnectivityResult.mobile ||
        element == ConnectivityResult.ethernet
      );

      if (wasConnected != _isConnected) {
        _connectionStatusController.add(_isConnected);
      }
    } catch (e) {
      _isConnected = false;
      _connectionStatusController.add(false);
    }
  }

  /// Verifica manualmente el estado de conexión
  Future<bool> checkConnection() async {
    await _updateConnectionStatus();
    return _isConnected;
  }

  /// Cierra el servicio y libera recursos
  Future<void> dispose() async {
    await _connectivitySubscription?.cancel();
    await _connectionStatusController.close();
  }
}
