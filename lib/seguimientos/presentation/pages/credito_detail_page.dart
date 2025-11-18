import 'package:flutter/material.dart';
import '../../../../shared/presentation/widgets/seguimiento_field.dart';

/// Pantalla de detalle de crédito
/// Muestra información completa del crédito asociado a un seguimiento
class CreditoDetailPage extends StatelessWidget {
  final String creditoNro;
  final String tipoCredito;
  final String saldoCapital;
  final String deudaTotal;
  final String tasaInteres;
  final String fechaVencimiento;
  final String ultimaFechaPago;
  final String diasMora;
  final String cuotasPagadas;
  final String socioAsociado;

  const CreditoDetailPage({
    super.key,
    required this.creditoNro,
    required this.tipoCredito,
    required this.saldoCapital,
    required this.deudaTotal,
    required this.tasaInteres,
    required this.fechaVencimiento,
    required this.ultimaFechaPago,
    required this.diasMora,
    required this.cuotasPagadas,
    required this.socioAsociado,
  });

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                creditoNro,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF191C1F),
                ),
              ),

              const SizedBox(height: 32),

              // Credit Fields
              SeguimientoField(
                context: context,
                labelText: 'Tipo de Credito',
                valueText: tipoCredito,
              ),

              SeguimientoField(
                context: context,
                labelText: 'Saldo Capital',
                valueText: saldoCapital,
              ),

              SeguimientoField(
                context: context,
                labelText: 'Deuda Total',
                valueText: deudaTotal,
              ),

              SeguimientoField(
                context: context,
                labelText: 'Tasa de interes',
                valueText: tasaInteres,
              ),

              SeguimientoField(
                context: context,
                labelText: 'Fecha de vencimiento',
                valueText: fechaVencimiento,
              ),

              SeguimientoField(
                context: context,
                labelText: 'Ultima fecha de pago',
                valueText: ultimaFechaPago,
                suffixIcon: const Icon(Icons.arrow_forward_ios),
                // Could navigate to payment history
              ),

              SeguimientoField(
                context: context,
                labelText: 'Días en Mora',
                valueText: diasMora,
              ),

              SeguimientoField(
                context: context,
                labelText: 'Cuotas Pagadas',
                valueText: cuotasPagadas,
              ),

              SeguimientoField(
                context: context,
                labelText: 'Socio Asociado',
                valueText: socioAsociado,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
