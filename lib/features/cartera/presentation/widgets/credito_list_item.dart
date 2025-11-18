import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/routing/routes.dart';
import '../../domain/entities/credito_completo.dart';

class CreditoListItem extends StatelessWidget {
  final CreditoCompleto credito;
  
  const CreditoListItem({
    super.key,
    required this.credito,
  });

  Color _getEstadoColor() {
    switch (credito.estado.toLowerCase()) {
      case 'al dia':
      case 'al día':
        return Colors.green;
      case 'en mora':
        return Colors.red;
      case 'cancelado':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(final BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: 'S/. ', decimalDigits: 2);
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    return GestureDetector(
      onTap: () {
        context.push('${Routes.creditoInfo}/${credito.id}');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 78,
              height: 77,
              decoration: BoxDecoration(
                color: _getEstadoColor(),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Crédito #${credito.id}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Próximo pago: ${credito.fechaProximoVencimiento != null ? dateFormat.format(credito.fechaProximoVencimiento!) : "No programada"}',
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Por pagar: ${currencyFormat.format(credito.saldoPendiente)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getEstadoColor(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                credito.estado,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
