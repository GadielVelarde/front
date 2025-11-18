import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seguimiento_norandino/core/routing/routes.dart';
import 'package:seguimiento_norandino/shared/presentation/pages/home/widgets/ruta_list_item.dart';
import 'package:seguimiento_norandino/shared/presentation/pages/home/widgets/socio_mora_card.dart';

import '../widgets/map_preview.dart';

class AsesorHomePage extends StatelessWidget {
  const AsesorHomePage({super.key});

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          
          // Tus próximas rutas
          _buildSection(
            title: 'Tus próximas rutas',
            onSeeAll: () {},
          ),
          const SizedBox(height: 16),
          _buildRutasList(),
          
          const SizedBox(height: 32),
          
          // Tus socios en mora
          _buildSection(
            title: 'Tus socios en mora',
            onSeeAll: () {},
          ),
          const SizedBox(height: 16),
          _buildSociosMoraList(),
          
          const SizedBox(height: 32),
          
          // Mapa de ubicaciones
          _buildMapSection(context),
          
          const SizedBox(height: 24),
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
              color: Colors.black,
            ),
          ),
          GestureDetector(
            onTap: onSeeAll,
            child: Text(
              'Ver todos >',
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

  Widget _buildRutasList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: 3,
      itemBuilder: (final context, final index) {
        return const RutaListItem(
          titulo: 'Title',
          descripcion: 'Description',
          direccion: 'Address',
        );
      },
    );
  }

  Widget _buildSociosMoraList() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        itemBuilder: (final context, final index) => const Padding(
          padding: EdgeInsets.only(right: 12),
          child: SocioMoraCard(nombre: 'Name'),
        ),
      ),
    );
  }

  Widget _buildMapSection(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mapa de ubicaciones',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              context.push(Routes.mapa);
            },
            child: Container(
              height: 246,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(11),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: AbsorbPointer(
                  child: MapPreviewWidget(
                    latitude: 40.7128,
                    longitude: -74.0060,
                    width: MediaQuery.of(context).size.width - 32,
                    height: 246,
                    zoom: 14.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
