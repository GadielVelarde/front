import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/routing/routes.dart';
import '../../../cartera/domain/entities/socio.dart';

class SocioListItem extends StatelessWidget {
  final Socio socio;

  const SocioListItem({super.key, required this.socio});

  @override
  Widget build(final BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              GoRouter.of(context).go('${Routes.cartera}/socioDetail/${socio.id}');
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail/Imagen placeholder del socio
                Container(
                  width: 78,
                  height: 77,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
                
                const SizedBox(width: 15),
                
                // Información del socio
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre completo
                      Text(
                        socio.nombreCompleto,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 1.29,
                          letterSpacing: -0.41,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 5),
                      
                      // Última fecha de pago
                      Text(
                        socio.ultimaFechaPago != null
                            ? 'Último pago: ${dateFormat.format(socio.ultimaFechaPago!)}'
                            : 'Sin pagos registrados',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 1,
                        ),
                      ),
                      
                      const SizedBox(height: 5),
                      
                      // Dirección
                      Text(
                        socio.direccionLimpia,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                // Botón de flecha para navegar
                IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    GoRouter.of(context).go('${Routes.cartera}/socioDetail/${socio.id}');
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Divider
          Container(
            height: 1,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }
}
