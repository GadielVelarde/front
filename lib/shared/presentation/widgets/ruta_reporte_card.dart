import 'package:flutter/material.dart';

class RutaReporteCard extends StatelessWidget {
  final String fecha;
  final String nombreRuta;
  final String? tipoRuta;
  final String asesor;
  final String actividad;
  final String resultado;
  final String aprobadoPor;
  final String socio;
  final String estado; // 'Aprobada', 'Pendiente', 'Anulada'
  final VoidCallback? onVerMas;
  final VoidCallback? onMapa;

  const RutaReporteCard({
    super.key,
    required this.fecha,
    required this.nombreRuta,
    required this.asesor,
    required this.actividad,
    required this.resultado,
    required this.aprobadoPor,
    required this.socio,
    required this.estado,
    this.onVerMas,
    this.onMapa, this.tipoRuta,
  });

  Color get _estadoColor {
    switch (estado.toLowerCase()) {
      case 'aprobada':
        return const Color(0xFF84CE7B);
      case 'pendiente':
        return const Color(0xFFFFA500);
      case 'anulada':
        return const Color(0xFFFF0000);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: 325,
      constraints: const BoxConstraints(minHeight: 243),
      margin: const EdgeInsets.only(bottom: 19),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          // Badge de estado
          Positioned(
            top: 30,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _estadoColor,
                borderRadius: BorderRadius.circular(48),
              ),
              child: Text(
                estado,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.6,
                ),
              ),
            ),
          ),
          
          // Contenido
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fecha y nombre de ruta
                Text(
                  '$fecha - $tipoRuta',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF494949),
                  ),
                ),
                
                const SizedBox(height: 6),
                
                // Asesor
                Text(
                  'Asesor: $asesor',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 1.29,
                    letterSpacing: -0.41,
                  ),
                ),
                
                const SizedBox(height: 6),
                
                // Divider
                Container(
                  height: 1,
                  color: Colors.black.withValues(alpha: 0.2),
                ),
                
                const SizedBox(height: 10),
                
                // Información en columnas
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Labels
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Actividad:',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF494949),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Resultado:',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF494949),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Aprobado por:',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF494949),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Socio:',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF494949),
                          ),
                        ),
                      ],
                    ),
                    
                    const Spacer(),
                    
                    // Valores
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          actividad,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          resultado,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          aprobadoPor,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          socio,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón Ver más
                    ElevatedButton(
                      onPressed: onVerMas,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB03138),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(95, 32),
                      ),
                      child: const Text(
                        'Ver mas',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Botón Mapa
                    ElevatedButton(
                      onPressed: onMapa,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C7278),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(95, 32),
                      ),
                      child: const Text(
                        'Mapa',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
