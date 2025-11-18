import 'package:flutter/material.dart';

/// Widget reutilizable para el botón de filtro de fecha
/// Usado en pantallas de seguimiento para mostrar y filtrar por fecha
class DateFilterButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? selectedDate;

  const DateFilterButton({
    super.key,
    this.onPressed,
    this.selectedDate,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFB03138),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  selectedDate ?? 'Fecha',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.calendar_today,
                  color: Colors.black,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
