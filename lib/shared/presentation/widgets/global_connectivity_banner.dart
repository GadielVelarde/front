import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/network/connectivity_service.dart';

/// Banner global de conectividad que se muestra en toda la aplicación
/// Solo para asesores que necesitan funcionalidad offline
class GlobalConnectivityBanner extends StatefulWidget {
  final ConnectivityService connectivityService;

  const GlobalConnectivityBanner({
    super.key,
    required this.connectivityService,
  });

  @override
  State<GlobalConnectivityBanner> createState() => _GlobalConnectivityBannerState();
}

class _GlobalConnectivityBannerState extends State<GlobalConnectivityBanner> {
  bool _isConnected = true;
  bool _wasDisconnected = false;
  bool _showReconnectedBanner = false;
  Timer? _reconnectedTimer;
  StreamSubscription<bool>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initializeConnectivity();
  }

  Future<void> _initializeConnectivity() async {
    _isConnected = widget.connectivityService.isConnected;
    _wasDisconnected = !_isConnected;
    
    if (mounted) {
      setState(() {});
    }

    // Escuchar cambios de conectividad
    _connectivitySubscription = widget.connectivityService.connectionStream.listen(
      (final bool isConnected) {
        if (mounted) {
          setState(() {
            // Si recuperamos la conexión después de estar desconectados
            if (isConnected && _wasDisconnected && !_showReconnectedBanner) {
              _showReconnectedBanner = true;

              // Ocultar el banner después de 8 segundos
              _reconnectedTimer?.cancel();
              _reconnectedTimer = Timer(const Duration(seconds: 10), () {
                if (mounted) {
                  setState(() {
                    _showReconnectedBanner = false;
                  });
                }
              });
            }

            _isConnected = isConnected;
            _wasDisconnected = !isConnected;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _reconnectedTimer?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    // Determinar si se debe mostrar algún banner
    final bool shouldShow = _showReconnectedBanner || !_isConnected;
    
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (final Widget child, final Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            )),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: shouldShow ? _buildBannerContent() : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildBannerContent() {
    // Mostrar mensaje de conexión recuperada
    if (_showReconnectedBanner && _isConnected) {
      return Container(
        key: const ValueKey('reconnected'),
        width: double.infinity,
        color: Colors.green.shade100,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green.shade800,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Conexión recuperada. Sincronizando datos...',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade900,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: 18,
                  color: Colors.green.shade800,
                ),
                onPressed: () {
                  _reconnectedTimer?.cancel();
                  setState(() {
                    _showReconnectedBanner = false;
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      );
    }

    // Sin conexión a internet
    return Container(
      key: const ValueKey('offline'),
      width: double.infinity,
      color: Colors.orange.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        bottom: false,
        child: Row(
            children: [
              Icon(
                Icons.offline_bolt,
                color: Colors.orange.shade800,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Sin conexión a internet',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade900,
                      ),
                    ),
                    Text(
                      'Los cambios se sincronizarán al conectarse',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}
