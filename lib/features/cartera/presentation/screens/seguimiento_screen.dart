
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/calendar_dialog.dart';
import '../../../../shared/presentation/widgets/image_picker_widget.dart';
import '../../../../shared/presentation/widgets/seguimiento_field.dart';
import '../../../../shared/presentation/widgets/success_dialog.dart';
import '../widgets/comentario_bottom_sheet.dart';
import '../widgets/credito_asociado_bottom_sheet.dart';
import '../widgets/resultado_bottom_sheet.dart';

class SeguimientoScreen extends StatefulWidget {
  const SeguimientoScreen({super.key});

  @override
  State<SeguimientoScreen> createState() => _SeguimientoScreenState();
}

class _SeguimientoScreenState extends State<SeguimientoScreen> {
  DateTime? fechaSeguimiento;
  String? creditoAsociado;
  String? resultado;
  DateTime? fechaAcordada;
  String? comentario;
  File? foto;
  DateTime? fechaRegistro;

  @override
  void initState() {
    super.initState();
    fechaSeguimiento = DateTime(2025, 9, 18);
    creditoAsociado = 'Credito Nro 1';
    resultado = 'Acuerdo de pago';
    fechaAcordada = DateTime(2025, 9, 28);
    comentario = 'Retraso por motivos familiares';
  }

  bool get isEditing => fechaRegistro != null;

  String formatDate(final DateTime? date) {
    if (date == null) return '';
    final months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }

  void registrarSeguimiento() {
    if (fechaSeguimiento == null ||
        creditoAsociado == null ||
        resultado == null ||
        fechaAcordada == null ||
        comentario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor complete todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!isEditing) {
      setState(() {
        fechaRegistro = DateTime.now();
      });
    }

    // final seguimientoData = {
    //   'fecha_seguimiento': fechaSeguimiento!.toIso8601String(),
    //   'credito_asociado': creditoAsociado,
    //   'resultado': resultado,
    //   'fecha_acordada': fechaAcordada!.toIso8601String(),
    //   'comentario': comentario,
    //   'foto': foto?.path,
    //   'fecha_registro': fechaRegistro!.toIso8601String(),
    // };

    showDialog<void>(
      context: context,
      builder: (final context) => const SuccessDialog(),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Seguimiento Diario',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            SeguimientoField(
              context: context,
              labelText: 'Fecha del seguimiento',
              valueText: formatDate(fechaSeguimiento),
              dialog: CalendarDialog(
                onDateSelected: (final date) {
                  setState(() {
                    fechaSeguimiento = date;
                  });
                },
              ),
            ),
            SeguimientoField(
              context: context,
              labelText: 'Credito Asociado',
              valueText: creditoAsociado ?? '',
              bottomSheet: CreditoAsociadoBottomSheet(
                selectedCredito: creditoAsociado,
                onCreditoSelected: (final credito) {
                  setState(() {
                    creditoAsociado = credito;
                  });
                },
              ),
            ),
            SeguimientoField(
              context: context,
              labelText: 'Resultado',
              valueText: resultado ?? '',
              bottomSheet: ResultadoBottomSheet(
                selectedResultado: resultado,
                onResultadoSelected: (final resultado) {
                  setState(() {
                    this.resultado = resultado;
                  });
                },
              ),
            ),
            SeguimientoField(
              context: context,
              labelText: 'Fecha acordada',
              valueText: formatDate(fechaAcordada),
              dialog: CalendarDialog(
                onDateSelected: (final date) {
                  setState(() {
                    fechaAcordada = date;
                  });
                },
              ),
            ),
            SeguimientoField(
              context: context,
              labelText: 'Comentario',
              valueText: comentario ?? '',
              bottomSheet: ComentarioBottomSheet(
                onComentarioChanged: (final comentario) {
                  setState(() {
                    this.comentario = comentario;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Fotos',
                        style: TextStyle(
                          color: Color(0xFF858587),
                          fontSize: 14,
                          
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Color(0xFFABABAD),),
                  const SizedBox(height: 20),
                  ImagePickerWidget(
                    onImagePicked: (final file) {
                      setState(() {
                        foto = file;
                      });
                    },
                  ),
                ],
              ),
            ),

            const Spacer(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ElevatedButton(
                  onPressed: registrarSeguimiento,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEditing ? AppColors.textSecondary : AppColors.primary,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    isEditing ? 'Editar Seguimiento' : 'Registrar Seguimiento',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
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