
import 'package:flutter/material.dart';

import 'credito_item.dart';

class CreditoAsociadoBottomSheet extends StatelessWidget {
  final void Function(String)? onCreditoSelected;
  final String? selectedCredito;
  
  const CreditoAsociadoBottomSheet({
    super.key,
    this.onCreditoSelected,
    this.selectedCredito,
  });

  @override
  Widget build(final BuildContext context) {
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
              'Credito Asociado',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            CreditoItem(selectedCredito: selectedCredito, onCreditoSelected: onCreditoSelected, context: context, text: 'Credito Nro 1'),
            CreditoItem(selectedCredito: selectedCredito, onCreditoSelected: onCreditoSelected, context: context, text: 'Credito Nro 2'),
            CreditoItem(selectedCredito: selectedCredito, onCreditoSelected: onCreditoSelected, context: context, text: 'Credito Nro 3'),
            CreditoItem(selectedCredito: selectedCredito, onCreditoSelected: onCreditoSelected, context: context, text: 'Credito Nro 4'),
            CreditoItem(selectedCredito: selectedCredito, onCreditoSelected: onCreditoSelected, context: context, text: 'Ninguno'),
          ],
        ),
      ),
    );
  }
}
