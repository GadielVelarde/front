import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/socio_bloc.dart';
import '../bloc/socio_state.dart';

class SocioSummaryCard extends StatelessWidget {
  const SocioSummaryCard({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<SocioBloc, SocioState>(
      builder: (final context, final state) {
        int totalSocios = 0;
        int sociosEnMora = 0;
        int sociosAlDia = 0;

        if (state is SociosLoaded) {
          totalSocios = state.resumen.totalSocios;
          sociosEnMora = state.resumen.sociosEnMora;
          sociosAlDia = state.resumen.sociosAlDia;
        }

        return Card(
          margin: const EdgeInsets.all(16.0),
          color: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(Icons.people, 'Socios', totalSocios.toString()),
                _buildDivider(),
                _buildSummaryItem(Icons.cancel, 'Estan en mora', sociosEnMora.toString()),
                _buildDivider(),
                _buildSummaryItem(Icons.check_circle, 'Estan al dia', sociosAlDia.toString()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryItem(final IconData icon, final String label, final String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 60,
      width: 1,
      color: Colors.white.withValues(alpha: 0.3),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }
}
