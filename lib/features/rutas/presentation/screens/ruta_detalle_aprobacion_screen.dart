import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_utils.dart';
import '../bloc/rutas_bloc.dart';
import '../bloc/rutas_state.dart';
import '../widgets/ruta_info_field.dart';

class RutaDetalleAprobacionScreen extends StatelessWidget {
  final String rutaId;

  const RutaDetalleAprobacionScreen({
    super.key,
    required this.rutaId,
  });

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<RutasBloc, RutasState>(
        builder: (final context, final state) {
          if (state is RutasLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Por ahora usamos datos mock
          return _buildContent(context);
        },
      ),
    );
  }

  Widget _buildContent(final BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              // Título
              const Text(
                'Ruta Lunes 08',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                  letterSpacing: -0.48,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Divider
              Container(
                height: 1,
                width: 200,
                color: Colors.black.withValues(alpha: 0.2),
              ),
              
              const SizedBox(height: 8),
              
              // Imagen del mapa
              Container(
                height: 167,
                width: 218,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: const Center(
                    child: Icon(
                      Icons.map,
                      size: 64,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Campo: Aprobación de la ruta
              const RutaInfoField(
                label: 'Aprobación de la ruta',
                value: 'Por aprobar',
                trailing: Icon(
                  Icons.pending,
                  color: Color(0xFFFFA500),
                  size: 24,
                ),
              ),
              
              // Campo: Tipo de ruta
              const RutaInfoField(
                label: 'Tipo de ruta',
                value: 'Cobranza',
              ),
              
              // Campo: Asesor Asociado
              const RutaInfoField(
                label: 'Asesor Asociado',
                value: 'Jose Perez',
              ),
              
              // Campo: Jefe Asociado
              const RutaInfoField(
                label: 'Jefe Asociado',
                value: 'Eduar Alejandria',
              ),
              
              // Campo: Socios Asociados
              RutaInfoField(
                label: 'Socios Asociados',
                value: 'Jose Paca, Luis Millones, ...',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: 24,
                ),
                onTap: () {
                },
              ),
              
              // Campo: Fecha de Inicio - Fin
              const RutaInfoField(
                label: 'Fecha de Inicio - Fin',
                value: '08 de Septiembre, 8:00 am - 13:00 pm',
              ),
              
              const SizedBox(height: 8),
              
              // Botones de acción
              Row(
                children: [
                  // Botón Rechazar
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showRechazarDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C7278),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(152, 48),
                      ),
                      child: const Text(
                        'Rechazar',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Botón Aprobar
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showAprobarDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB03138),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(152, 48),
                      ),
                      child: const Text(
                        'Aprobar',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
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

  void _showAprobarDialog(final BuildContext context) async {
    final confirmed = await AppUtils.showConfirmationDialog(
      context,
      title: 'Aprobar Ruta',
      message: '¿Estás seguro de que deseas aprobar esta ruta?',
      confirmText: 'Aprobar',
      cancelText: 'Cancelar',
    );

    if (confirmed == true) {
      if (context.mounted) {
        context.pop(); // Volver a la lista
        AppUtils.showSnackBar(
          context,
          message: 'Ruta aprobada exitosamente',
          backgroundColor: const Color(0xFF84CE7B),
        );
      }
    }
  }

  void _showRechazarDialog(final BuildContext context) async {
    final confirmed = await AppUtils.showConfirmationDialog(
      context,
      title: 'Rechazar Ruta',
      message: '¿Estás seguro de que deseas rechazar esta ruta?',
      confirmText: 'Rechazar',
      cancelText: 'Cancelar',
    );

    if (confirmed == true) {
      if (context.mounted) {
        context.pop(); // Volver a la lista
        AppUtils.showSnackBar(
          context,
          message: 'Ruta rechazada',
          backgroundColor: const Color(0xFFB03138),
        );
      }
    }
  }
}
