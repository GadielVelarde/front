import 'package:flutter/material.dart';

class CreditoItem extends StatelessWidget {
  const CreditoItem({
    super.key,
    required this.selectedCredito,
    required this.onCreditoSelected,
    required this.context,
    required this.text,
  });

  final String? selectedCredito;
  final void Function(String p1)? onCreditoSelected;
  final BuildContext context;
  final String text;

  @override
  Widget build(final BuildContext context) {
    final isSelected = selectedCredito == text;
    return GestureDetector(
      onTap: () {
        onCreditoSelected?.call(text);
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
