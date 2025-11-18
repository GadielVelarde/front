import 'package:flutter/material.dart';

class SocioBottomSheet extends StatelessWidget {
  final void Function(String)? onSocioSelected;
  final String? selectedSocio;
  
  const SocioBottomSheet({
    super.key,
    this.onSocioSelected,
    this.selectedSocio,
  });

  @override
  Widget build(final BuildContext context) {
    final socios = [
      'Juan Pérez - DNI: 12345678',
      'María García - DNI: 87654321',
      'Carlos López - DNI: 11223344',
      'Ana Martínez - DNI: 44332211',
      'Pedro Sánchez - DNI: 55667788',
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Socio Visitado',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            ...socios.map((final socio) => _buildSocioItem(context, socio)),
          ],
        ),
      ),
    );
  }

  Widget _buildSocioItem(final BuildContext context, final String text) {
    final isSelected = selectedSocio == text;
    return GestureDetector(
      onTap: () {
        onSocioSelected?.call(text);
        Navigator.of(context).pop();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB03138) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFC7C7C7)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
