import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/presentation/widgets/comentario_bottom_sheet.dart';
import '../../../../shared/presentation/widgets/image_picker_widget.dart';
import '../../../../shared/presentation/widgets/resultado_visita_bottom_sheet.dart';
import '../../../../shared/presentation/widgets/seguimiento_field.dart';
import '../../../../shared/presentation/widgets/socio_bottom_sheet.dart';
import '../../../../shared/presentation/widgets/success_dialog.dart';
import '../../../../shared/presentation/widgets/tipo_visita_bottom_sheet.dart';

class RegistrarEvidenciaScreen extends StatefulWidget {
  final String rutaId;
  final String? socioDni;

  const RegistrarEvidenciaScreen({
    super.key,
    required this.rutaId,
    this.socioDni,
  });

  @override
  State<RegistrarEvidenciaScreen> createState() =>
      _RegistrarEvidenciaScreenState();
}

class _RegistrarEvidenciaScreenState extends State<RegistrarEvidenciaScreen> {
  String _socioVisitado = '';
  String _tipoVisita = '';
  String _resultadoVisita = '';
  String _observaciones = '';
  // ignore: unused_field
  File? _foto;
  bool _isLoading = false;

  bool get _isFormValid {
    return _socioVisitado.isNotEmpty &&
        _tipoVisita.isNotEmpty &&
        _resultadoVisita.isNotEmpty &&
        _observaciones.isNotEmpty;
  }

  Future<void> _registrarEvidencia() async {
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor complete todos los campos obligatorios'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Future<void>.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (final context) => const SuccessDialog(
          message: 'La evidencia fue registrada exitosamente :)',
        ),
      );

      if (!mounted) return;

      context.pop();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al registrar la evidencia: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (!_isLoading) context.pop();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Registrar Evidencia',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(
              thickness: 1,
              indent: 70,
              endIndent: 70,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: IgnorePointer(
                  ignoring: _isLoading,
                  child: Opacity(
                    opacity: _isLoading ? 0.5 : 1.0,
                    child: Column(
                      children: [
                        SeguimientoField(
                          context: context,
                          labelText: 'Socio Visitado',
                          valueText: _socioVisitado.isEmpty
                              ? 'Seleccione el socio'
                              : _socioVisitado,
                          suffixIcon: const Icon(Icons.person),
                          bottomSheet: SocioBottomSheet(
                            selectedSocio: _socioVisitado,
                            onSocioSelected: (final socio) {
                              setState(() {
                                _socioVisitado = socio;
                              });
                            },
                          ),
                        ),
                        SeguimientoField(
                          context: context,
                          labelText: 'Tipo de Visita',
                          valueText: _tipoVisita.isEmpty
                              ? 'Seleccione el tipo'
                              : _tipoVisita,
                          suffixIcon: const Icon(Icons.arrow_drop_down),
                          bottomSheet: TipoVisitaBottomSheet(
                            selectedTipoVisita: _tipoVisita,
                            onTipoVisitaSelected: (final tipo) {
                              setState(() {
                                _tipoVisita = tipo;
                              });
                            },
                          ),
                        ),
                        SeguimientoField(
                          context: context,
                          labelText: 'Resultado de la Visita',
                          valueText: _resultadoVisita.isEmpty
                              ? 'Seleccione el resultado'
                              : _resultadoVisita,
                          suffixIcon: const Icon(Icons.assignment_turned_in),
                          bottomSheet: ResultadoVisitaBottomSheet(
                            selectedResultado: _resultadoVisita,
                            onResultadoSelected: (final resultado) {
                              setState(() {
                                _resultadoVisita = resultado;
                              });
                            },
                          ),
                        ),
                        SeguimientoField(
                          context: context,
                          labelText: 'Observaciones',
                          valueText: _observaciones.isEmpty
                              ? 'Ingrese observaciones'
                              : _observaciones,
                          suffixIcon: const Icon(Icons.edit),
                          bottomSheet: ComentarioBottomSheet(
                            title: 'Observaciones',
                            onComentarioChanged: (final comentario) {
                              setState(() {
                                _observaciones = comentario;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        ImagePickerWidget(
                          onImagePicked: (final imagePath) {
                            setState(() {
                              _foto = imagePath;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _registrarEvidencia,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFormValid && !_isLoading
                      ? const Color(0xFFB03138)
                      : Colors.grey[400],
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Registrar Evidencia',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
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
