import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../shared/presentation/widgets/seguimiento_field.dart';
import '../../../../shared/presentation/widgets/image_picker_widget.dart';
import '../../../../shared/presentation/widgets/calendar_dialog.dart';

/// Pantalla de creación de seguimiento
/// Formulario editable para registrar un nuevo seguimiento
class CreateSeguimientoPage extends StatefulWidget {
  const CreateSeguimientoPage({super.key});

  @override
  State<CreateSeguimientoPage> createState() => _CreateSeguimientoPageState();
}

class _CreateSeguimientoPageState extends State<CreateSeguimientoPage> {
  DateTime _fechaSeguimiento = DateTime.now();
  String? _creditoAsociado;
  String? _resultado;
  DateTime? _fechaAcordada;
  String _descripcion = '';

  void _showComentarioSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (final context) => _buildComentarioBottomSheet(),
    );
  }

  void _registrarSeguimiento() {
    if (_creditoAsociado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona un crédito')),
      );
      return;
    }
    if (_resultado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona un resultado')),
      );
      return;
    }

    // Show success message and go back
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Seguimiento registrado exitosamente')),
    );
    Navigator.of(context).pop();
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'Seguimiento Diario',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF191C1F),
                ),
              ),

              const SizedBox(height: 32),

              // Fecha del seguimiento
              SeguimientoField(
                context: context,
                labelText: 'Fecha del seguimiento',
                valueText: DateFormat('dd de MMMM de yyyy', 'es').format(_fechaSeguimiento),
                suffixIcon: const Icon(Icons.arrow_forward_ios),
                dialog: CalendarDialog(
                  onDateSelected: (final date) {
                    setState(() {
                      _fechaSeguimiento = date;
                    });
                  },
                ),
              ),

              // Credito Asociado
              SeguimientoField(
                context: context,
                labelText: 'Credito Asociado',
                valueText: _creditoAsociado ?? 'Credito Nro 1',
                suffixIcon: const Icon(Icons.arrow_forward_ios),
                // Add bottom sheet for credit selection
              ),

              // Resultado
              SeguimientoField(
                context: context,
                labelText: 'Resultado',
                valueText: _resultado ?? 'Acuerdo',
                suffixIcon: const Icon(Icons.arrow_forward_ios),
              ),

              // Fecha acordada
              SeguimientoField(
                context: context,
                labelText: 'Fecha acordada',
                valueText: _fechaAcordada != null
                    ? DateFormat('dd de MMMM de yyyy', 'es').format(_fechaAcordada!)
                    : '28 de Septiembre de 2025',
                suffixIcon: const Icon(Icons.arrow_forward_ios),
                dialog: CalendarDialog(
                  onDateSelected: (final date) {
                    setState(() {
                      _fechaAcordada = date;
                    });
                  },
                ),
              ),

              // Descripcion o Motivo
              GestureDetector(
                onTap: _showComentarioSheet,
                child: SeguimientoField(
                  context: context,
                  labelText: 'Descripcion o Motivo',
                  valueText: _descripcion.isEmpty 
                      ? 'Retraso por motivos familiares'
                      : _descripcion,
                  suffixIcon: const Icon(Icons.arrow_forward_ios),
                ),
              ),

              const SizedBox(height: 24),

              // Fotos Section
              const Text(
                'Fotos',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Color(0xFF858587),
                ),
              ),

              const SizedBox(height: 12),

              // Image Picker
              ImagePickerWidget(
                onImagePicked: (final image) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Foto seleccionada')),
                  );
                },
              ),

              const SizedBox(height: 40),

              // Registrar Button
              SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _registrarSeguimiento,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB03138),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Registrar Seguimiento',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComentarioBottomSheet() {
    final TextEditingController controller = TextEditingController(text: _descripcion);
    
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 36,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'Comentario',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF191C1F),
              ),
            ),

            const SizedBox(height: 20),

            // Text Area
            TextField(
              controller: controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Input text',
                filled: true,
                fillColor: const Color(0xFFF2F4F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Volver atras button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _descripcion = controller.text;
                  });
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF626262),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Volver atras',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
