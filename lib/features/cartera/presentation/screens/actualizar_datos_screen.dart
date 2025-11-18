import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/presentation/widgets/seguimiento_field.dart';
import '../../../../shared/presentation/widgets/success_dialog.dart';
import '../widgets/direccion_search_bottom_sheet.dart';

class ActualizarDatosScreen extends StatefulWidget {
  const ActualizarDatosScreen({super.key});

  @override
  State<ActualizarDatosScreen> createState() => _ActualizarDatosScreenState();
}

class _ActualizarDatosScreenState extends State<ActualizarDatosScreen> {
  String _direccion = 'Jr. Meldrano Silva 165';

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () {
            context.pop();
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
              'Actualizar Datos',
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
            SeguimientoField(
              context: context,
              labelText: 'DNI',
              valueText: '63457899',
            ),
            SeguimientoField(
              context: context,
              labelText: 'Numero de telefono',
              valueText: '987654321',
            ),
            SeguimientoField(
              context: context,
              labelText: 'Dirección',
              valueText: _direccion,
              suffixIcon: const Icon(Icons.arrow_forward_ios),
              bottomSheet: DireccionSearchBottomSheet(
                selectedDireccion: _direccion,
                onDireccionSelected: (final direccion) {
                  setState(() {
                    _direccion = direccion;
                  });
                },
              ),
            ),
            const Spacer(),
            SafeArea(
              child: ElevatedButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (final context) => const SuccessDialog(
                      message: 'Tus datos fueron actualizados exitosamente :)',
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB03138),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Actualizar',
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
