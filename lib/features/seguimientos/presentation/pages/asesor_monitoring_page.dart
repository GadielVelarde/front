import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroine/heroine.dart';
import '../../../../core/routing/routes.dart';
import '../../../../shared/presentation/widgets/seguimiento_list_item.dart';

/// Pantalla de monitoreo de asesor
/// Muestra todos los seguimientos del día de un asesor específico
class AsesorMonitoringPage extends StatelessWidget {
  final String asesorName;

  const AsesorMonitoringPage({
    super.key,
    required this.asesorName,
  });

  @override
  Widget build(final BuildContext context) {
    final List<Map<String, String>> seguimientos = [
      {
        'socioName': 'Pedro Sánchez',
        'fecha': '18 de Septiembre de 2025',
        'resultado': 'Acuerdo de pago'
      },
      {
        'socioName': 'Laura Gómez',
        'fecha': '18 de Septiembre de 2025',
        'resultado': 'Visita realizada'
      },
      {
        'socioName': 'Roberto Díaz',
        'fecha': '18 de Septiembre de 2025',
        'resultado': 'Retraso justificado'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Title - Centered
            const Text(
              'Seguimientos del día',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF191C1F),
              ),
            ),
            const SizedBox(height: 4),
            const Divider(
              thickness: 1,
              indent: 70,
              endIndent: 70,
            ),
            const SizedBox(height: 4),
            Text(
              asesorName,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF191C1F),
              ),
            ),
            const SizedBox(height: 8),

            // Seguimientos List
            Expanded(
              child: ListView.separated(
                itemCount: seguimientos.length,
              separatorBuilder: (final context, final index) => const Divider(
                height: 1,
                color: Color(0xFFE5E5E5),
              ),
              itemBuilder: (final context, final index) {
                final seguimiento = seguimientos[index];
                return Heroine(
                  tag: 'seguimiento-${seguimiento['socioName']}-${seguimiento['fecha']}',
                  child: SeguimientoListItem(
                    socioName: seguimiento['socioName']!,
                    fecha: seguimiento['fecha']!,
                    resultado: seguimiento['resultado']!,
                    onTap: () {
                      context.push(
                        '${Routes.seguimientoDetail}'
                        '?socioName=${Uri.encodeComponent(seguimiento['socioName']!)}'
                        '&fechaSeguimiento=${Uri.encodeComponent(seguimiento['fecha']!)}'
                        '&creditoAsociado=${Uri.encodeComponent('Credito Nro 1')}'
                        '&resultado=${Uri.encodeComponent(seguimiento['resultado']!)}'
                        '&fechaAcordada=${Uri.encodeComponent('28 de Septiembre de 2025')}'
                        '&comentario=${Uri.encodeComponent('Retraso por motivos familiares')}',
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
        ),
      ),
    );
  }
}
