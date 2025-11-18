import 'package:flutter/material.dart';
import 'package:seguimiento_norandino/shared/presentation/pages/home/widgets/metric_card.dart';
import 'package:seguimiento_norandino/shared/presentation/pages/home/widgets/ruta_aprobacion_item.dart';

class JefeHomePage extends StatelessWidget {
  const JefeHomePage({super.key});

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          
          // Resumen del día
          _buildResumenSection(),
          
          const SizedBox(height: 32),
          
          // Rutas por aprobar
          _buildSection(
            title: 'Rutas por aprobar',
            onSeeAll: () {},
          ),
          const SizedBox(height: 16),
          _buildRutasAprobacionList(),
        ],
      ),
    );
  }

  Widget _buildResumenSection() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen del día',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  icon: Icons.route,
                  label: 'RUTAS TOTALES',
                  value: '34',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  icon: Icons.edit_outlined,
                  label: 'APROBACIONES',
                  value: '34',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  icon: Icons.check,
                  label: 'COMPLETADO',
                  value: '67%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required final String title, required final VoidCallback onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          GestureDetector(
            onTap: onSeeAll,
            child: Text(
              'Ver todas >',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRutasAprobacionList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 4,
      itemBuilder: (final context, final index) {
        return RutaAprobacionItem(
          titulo: 'Ruta Nro ${index + 1}',
          asesor: 'Asesor',
          estado: 'Estado',
        );
      },
    );
  }
}
