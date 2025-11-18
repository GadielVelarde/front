
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:heroine/heroine.dart';

import '../../../../core/di/injection.dart';
import '../../../../shared/presentation/widgets/info_row.dart';
import '../bloc/credito_bloc.dart';
import '../bloc/credito_event.dart';
import '../bloc/credito_state.dart';

class CreditoInfoScreen extends StatefulWidget {
  final String creditoId;

  const CreditoInfoScreen({
    super.key,
    required this.creditoId,
  });

  @override
  State<CreditoInfoScreen> createState() => _CreditoInfoScreenState();
}

class _CreditoInfoScreenState extends State<CreditoInfoScreen> {
  late final CreditoBloc _creditoBloc;

  @override
  void initState() {
    super.initState();
    _creditoBloc = sl<CreditoBloc>();
    final creditoIdInt = int.parse(widget.creditoId);
    _creditoBloc.add(GetCreditoDetailEvent(creditoIdInt));
  }

  @override
  void dispose() {
    _creditoBloc.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: 'S/. ', decimalDigits: 2);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return BlocProvider.value(
      value: _creditoBloc,
      child: Scaffold(
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
        body: BlocBuilder<CreditoBloc, CreditoState>(
          builder: (final context, final state) {
            if (state is CreditoLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is CreditoError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar crédito',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            if (state is CreditoDetailLoaded) {
              final credito = state.credito;
              
              return Heroine(
                tag: 'credito-${credito.id}',
                child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Información del Crédito',
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
                    Expanded(
                      child: ListView(
                        children: [
                          InfoRow(
                            label: 'ID Crédito',
                            value: '#${credito.id}',
                            icon: Icons.tag,
                          ),
                          InfoRow(
                            label: 'Estado',
                            value: credito.estado,
                            icon: Icons.info,
                          ),
                          InfoRow(
                            label: 'Monto Total',
                            value: currencyFormat.format(credito.montoTotal),
                            icon: Icons.account_balance_wallet,
                          ),
                          InfoRow(
                            label: 'Monto Pagado',
                            value: currencyFormat.format(credito.montoPagado),
                            icon: Icons.payment,
                          ),
                          InfoRow(
                            label: 'Saldo Pendiente',
                            value: currencyFormat.format(credito.saldoPendiente),
                            icon: Icons.money_off,
                          ),
                          if (credito.montoCuota != null)
                            InfoRow(
                              label: 'Monto por Cuota',
                              value: currencyFormat.format(credito.montoCuota!),
                              icon: Icons.request_quote,
                            ),
                          InfoRow(
                            label: 'Número de Cuotas',
                            value: credito.numeroCuotas.toString(),
                            icon: Icons.format_list_numbered,
                          ),
                          InfoRow(
                            label: 'Cuotas Pagadas',
                            value: '${credito.cuotasPagadas} de ${credito.numeroCuotas}',
                            icon: Icons.check_circle_outline,
                          ),
                          InfoRow(
                            label: 'Cuotas Pendientes',
                            value: credito.cuotasPendientes.toString(),
                            icon: Icons.pending_actions,
                          ),
                          InfoRow(
                            label: 'Fecha de Desembolso',
                            value: dateFormat.format(credito.fechaDesembolso),
                            icon: Icons.calendar_today,
                          ),
                          InfoRow(
                            label: 'Próximo Vencimiento',
                            value: credito.fechaProximoVencimiento != null
                                ? dateFormat.format(credito.fechaProximoVencimiento!)
                                : 'No programada',
                            icon: Icons.event,
                          ),
                          if (credito.diasMora > 0)
                            InfoRow(
                              label: 'Días en Mora',
                              value: credito.diasMora.toString(),
                              icon: Icons.warning_amber,
                            ),
                          InfoRow(
                            label: 'Asesor',
                            value: credito.nombreAsesor,
                            icon: Icons.person,
                          ),
                          InfoRow(
                            label: 'Agencia',
                            value: credito.agencia,
                            icon: Icons.business,
                          ),
                        ],
                      ),
                    ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
