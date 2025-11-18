import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/routes.dart';
import '../../../../shared/presentation/widgets/seguimiento_field.dart';

class RegisterSocioScreen extends StatefulWidget {
  const RegisterSocioScreen({super.key});

  @override
  State<RegisterSocioScreen> createState() => _RegisterSocioScreenState();
}

class _RegisterSocioScreenState extends State<RegisterSocioScreen> {
  String _dni = '';
  bool _isLoading = false;

  bool get _isFormValid {
    return _dni.isNotEmpty && _dni.length == 8;
  }

  Future<void> _registrarSocio() async {
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingrese un DNI válido de 8 dígitos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulando llamada a la API
      await Future<void>.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      context.go('${Routes.cartera}${Routes.socioDetail}/$_dni');
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al registrar el socio: $e'),
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
              'Registrar Socio',
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
            IgnorePointer(
              ignoring: _isLoading,
              child: Opacity(
                opacity: _isLoading ? 0.5 : 1.0,
                child: SeguimientoField(
                  context: context,
                  labelText: 'DNI',
                  valueText: _dni.isEmpty ? 'Ingrese el DNI' : _dni,
                  suffixIcon: const Icon(Icons.edit),
                  bottomSheet: _buildDniBottomSheet(),
                ),
              ),
            ),
            const Spacer(),
            SafeArea(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _registrarSocio,
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
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Registrar Socio',
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

  Widget _buildDniBottomSheet() {
    final controller = TextEditingController(text: _dni);
    return _buildTextInputBottomSheet(
      title: 'Ingrese el DNI',
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: 8,
      onSave: (final value) {
        setState(() {
          _dni = value;
        });
      },
    );
  }

  Widget _buildTextInputBottomSheet({
    required final String title,
    required final TextEditingController controller,
    required final TextInputType keyboardType,
    final int? maxLength,
    required final void Function(String) onSave,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLength: maxLength,
            autofocus: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              counterText: maxLength != null ? '' : null,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              onSave(controller.text.trim());
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB03138),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Guardar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
