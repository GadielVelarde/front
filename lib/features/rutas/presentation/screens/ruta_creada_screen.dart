import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/routes.dart';

class RutaCreadaScreen extends StatelessWidget {
  final String rutaId;
  final String nombreRuta;

  const RutaCreadaScreen({
    super.key,
    required this.rutaId,
    required this.nombreRuta,
  });

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => context.go('/rutas'),
                ),
              ),
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFB03138).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFFB03138),
                  size: 80,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Ruta Creada',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'La ruta "$nombreRuta" fue creada exitosamente',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      icon: Icons.route,
                      label: 'ID de Ruta',
                      value: rutaId,
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      icon: Icons.info_outline,
                      label: 'Estado',
                      value: 'Activa',
                      valueColor: Colors.green,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => context.push('${Routes.rutaInfo}/$rutaId'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB03138),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Ver Detalles de la Ruta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.go(Routes.rutas),
                    child: const Text(
                      'Volver a Rutas',
                      style: TextStyle(
                        color: Color(0xFFB03138),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required final IconData icon,
    required final String label,
    required final String value,
    final Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFFB03138),
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
