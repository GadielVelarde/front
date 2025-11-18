import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/cartera.dart';

class CarteraCard extends StatelessWidget {
  final Cartera cartera;

  const CarteraCard({super.key, required this.cartera});

  @override
  Widget build(final BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: 'S/ ', decimalDigits: 2);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(cartera.nombreCliente, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                  _buildEstadoChip(cartera.estado),
                ],
              ),
              const SizedBox(height: 4),
              Text('DNI: ${cartera.dni}', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Monto Total', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      Text(currencyFormat.format(cartera.montoTotal), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Saldo Pendiente', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      Text(currencyFormat.format(cartera.saldoPendiente), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cartera.saldoPendiente > 0 ? Colors.red : Colors.green)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: cartera.porcentajePagado / 100,
                  minHeight: 6,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(cartera.porcentajePagado >= 100 ? Colors.green : AppColors.primary),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (cartera.diasMora > 0) ...[
                    const Icon(Icons.warning, size: 16, color: Colors.red),
                    const SizedBox(width: 4),
                    Text('${cartera.diasMora} días de mora', style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                  if (cartera.requiereVisita) ...[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.orange, width: 1)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on, size: 12, color: Colors.orange),
                          SizedBox(width: 4),
                          Text('Requiere visita', style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEstadoChip(final String estado) {
    Color color;
    switch (estado) {
      case 'al_dia': color = Colors.green; break;
      case 'en_mora': color = Colors.orange; break;
      case 'vencido': color = Colors.red; break;
      case 'juridico': color = Colors.purple; break;
      default: color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: color, width: 1)),
      child: Text(estado.toUpperCase().replaceAll('_', ' '), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
