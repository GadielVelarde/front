import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/routes.dart';

class AprobacionRutasScreen extends StatelessWidget {
  const AprobacionRutasScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Aprobacion de Rutas',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
            letterSpacing: -0.48,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Divider
          Container(
            height: 1,
            width: 200,
            margin: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.black.withValues(alpha: 0.2),
          ),
          
          // Título "Pendientes"
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Pendientes',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
                letterSpacing: -0.4,
              ),
            ),
          ),
          
          // Lista de rutas pendientes
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 4,
              itemBuilder: (final context, final index) {
                return _RutaPendienteItem(
                  nombreRuta: 'Ruta Lunes ${index + 1}',
                  asesor: 'Asesor ${index + 1}',
                  estado: 'Pendiente',
                  onTap: () {
                    // Navegar a detalle de ruta para aprobación
                    context.push('${Routes.aprobacionRutas}/ruta_${index + 1}');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RutaPendienteItem extends StatelessWidget {
  final String nombreRuta;
  final String asesor;
  final String estado;
  final VoidCallback onTap;

  const _RutaPendienteItem({
    required this.nombreRuta,
    required this.asesor,
    required this.estado,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              // Thumbnail
              Container(
                width: 78,
                height: 77,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Icon(
                    Icons.map_outlined,
                    size: 32,
                    color: Colors.grey,
                  ),
                ),
              ),
              
              const SizedBox(width: 15),
              
              // Información
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombreRuta,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        height: 1.29,
                        letterSpacing: -0.41,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      asesor,
                      style: const TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        height: 1.33,
                        letterSpacing: -0.24,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      estado,
                      style: const TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        height: 1.33,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Flecha
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Colors.grey,
                ),
                onPressed: onTap,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Divider
          Container(
            height: 1,
            width: 200,
            margin: const EdgeInsets.only(left: 93),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }
}
