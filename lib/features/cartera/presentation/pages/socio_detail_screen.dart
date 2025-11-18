import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:heroine/heroine.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/info_row.dart';
import '../bloc/socio_bloc.dart';
import '../bloc/socio_event.dart';
import '../bloc/socio_state.dart';


class SocioDetailScreen extends StatefulWidget {
  final String socioId;

  const SocioDetailScreen({super.key, required this.socioId});

  @override
  State<SocioDetailScreen> createState() => _SocioDetailScreenState();
}

class _SocioDetailScreenState extends State<SocioDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SocioBloc>().add(GetSocioDetailEvent(int.parse(widget.socioId)));
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => GoRouter.of(context).go(Routes.cartera),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocBuilder<SocioBloc, SocioState>(
          builder: (final context, final state) {
            if (state is SocioLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SocioDetailLoaded) {
              final socio = state.socio;
              final int namelength = socio.nombreCompleto.length;
              return Heroine(
                tag: 'socio-${socio.id}',
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  socio.nombreCompleto,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Divider(
                                  height: 1.0,
                                  indent: 1.6 * namelength,
                                  endIndent: 1.6 * namelength,
                                ),
                                const SizedBox(height: 16.0),
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                InfoRow(
                                  label: 'DNI',
                                  value: socio.dni,
                                  icon: Icons.credit_card,
                                ),
                                InfoRow(
                                  label: 'Nombre Completo',
                                  value: socio.nombreCompleto,
                                  icon: Icons.person,
                                ),
                                InfoRow(
                                  label: 'Número de Créditos',
                                  value: socio.numeroCreditos.toString(),
                                  icon: Icons.format_list_numbered,
                                  onTap: () => context.push(
                                    '${Routes.creditos}/${socio.id}?nombreSocio=${Uri.encodeComponent(socio.nombreCompleto)}',
                                  ),
                                ),
                                InfoRow(
                                  label: 'Última Fecha de Pago',
                                  value: socio.ultimaFechaPago != null
                                      ? '${socio.ultimaFechaPago!.day}/${socio.ultimaFechaPago!.month}/${socio.ultimaFechaPago!.year}'
                                      : 'Sin registro',
                                  icon: Icons.calendar_today,
                                ),
                                InfoRow(
                                  label: 'Número de Teléfono',
                                  value: socio.numeroTelefono,
                                  icon: Icons.phone,
                                ),
                                InfoRow(
                                  label: 'Dirección',
                                  value: socio.direccionLimpia,
                                  icon: Icons.location_on,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        bottom: 16.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.push(Routes.actualizarDatos);
                              },
                              icon: const Icon(Icons.edit, size: 18),
                              label: const Text('Actualizar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.push(Routes.seguimientoDiario);
                              },
                              icon: const Icon(Icons.track_changes, size: 18),
                              label: const Text('Seguimiento'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ],
                ),
              );
            } else if (state is SocioError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Socio no encontrado'));
          },
        ),
      ),
    );
  }
}
