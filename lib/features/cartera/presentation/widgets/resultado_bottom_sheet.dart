
import 'package:flutter/material.dart';
import 'resultado_item.dart';

class ResultadoBottomSheet extends StatelessWidget {
  final void Function(String)? onResultadoSelected;
  final String? selectedResultado;
  
  const ResultadoBottomSheet({
    super.key,
    this.onResultadoSelected,
    this.selectedResultado,
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
              'Resultado',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            ResultadoItem(selectedResultado: selectedResultado, onResultadoSelected: onResultadoSelected, context: context, text: 'Acuerdo de pago'),
            ResultadoItem(selectedResultado: selectedResultado, onResultadoSelected: onResultadoSelected, context: context, text: 'Acuerdo de proxima visita'),
            ResultadoItem(selectedResultado: selectedResultado, onResultadoSelected: onResultadoSelected, context: context, text: 'Acuerdo de proxima llamada'),
            ResultadoItem(selectedResultado: selectedResultado, onResultadoSelected: onResultadoSelected, context: context, text: 'Otro'),
          ],
        ),
      ),
    );
  }
}
