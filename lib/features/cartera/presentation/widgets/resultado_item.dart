import 'package:flutter/material.dart';

class ResultadoItem extends StatelessWidget {
  const ResultadoItem({
    super.key,
    required this.selectedResultado,
    required this.onResultadoSelected,
    required this.context,
    required this.text,
  });

  final String? selectedResultado;
  final void Function(String p1)? onResultadoSelected;
  final BuildContext context;
  final String text;

  @override
  Widget build(final BuildContext context) {
    final isSelected = selectedResultado == text;
    return GestureDetector(
      onTap: () {
        onResultadoSelected?.call(text);
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
