import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/routes.dart';
import '../../../../shared/presentation/widgets/seguimiento_field.dart';

/// Pantalla de detalle de seguimiento (solo lectura)
/// Muestra toda la información de un seguimiento completado
class SeguimientoDetailPage extends StatelessWidget {
  final String socioName;
  final String fechaSeguimiento;
  final String creditoAsociado;
  final String resultado;
  final String fechaAcordada;
  final String comentario;
  final List<String>? fotos;

  const SeguimientoDetailPage({
    super.key,
    required this.socioName,
    required this.fechaSeguimiento,
    required this.creditoAsociado,
    required this.resultado,
    required this.fechaAcordada,
    required this.comentario,
    this.fotos,
  });

  void _showCommentBottomSheet(final BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (final context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Comentario Completo',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              comentario,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Color(0xFF191C1F),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Title centered with divider
              const Text(
                'Seguimiento Diario',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF191C1F),
                ),
              ),
              const SizedBox(height: 8),
              const Divider(
                thickness: 1,
                indent: 70,
                endIndent: 70,
              ),
              const SizedBox(height: 8),
              Text(
                socioName,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF191C1F),
                ),
              ),
              const SizedBox(height: 24),

              // Fields
              SeguimientoField(
                context: context,
                labelText: 'Fecha del seguimiento',
                valueText: fechaSeguimiento,
              ),

              SeguimientoField(
                context: context,
                labelText: 'Credito Asociado',
                valueText: creditoAsociado,
                suffixIcon: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to credit detail
                  context.push(Routes.creditoInfo);
                },
              ),

              SeguimientoField(
                context: context,
                labelText: 'Resultado',
                valueText: resultado,
              ),

              SeguimientoField(
                context: context,
                labelText: 'Fecha acordada',
                valueText: fechaAcordada,
              ),

              SeguimientoField(
                context: context,
                labelText: 'Comentario',
                valueText: comentario.length > 50 
                    ? '${comentario.substring(0, 50)}...' 
                    : comentario,
                suffixIcon: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showCommentBottomSheet(context),
              ),

              const SizedBox(height: 24),

              // Fotos Section - Centered
              const Center(
                child: Text(
                  'Fotos',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Color(0xFF858587),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Photo placeholder or actual photos - Centered
              Center(
                child: fotos != null && fotos!.isNotEmpty
                    ? Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: fotos!
                            .map((final foto) => Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC7C7C7),
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(foto),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ))
                            .toList(),
                      )
                    : Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFE5E5E5),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: 32,
                              color: Color(0xFF858587),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Upload Photo',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: Color(0xFF858587),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
