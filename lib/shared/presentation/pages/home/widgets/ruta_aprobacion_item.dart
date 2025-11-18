import 'package:flutter/material.dart';

class RutaAprobacionItem extends StatelessWidget {
  final String titulo;
  final String asesor;
  final String estado;

  const RutaAprobacionItem({super.key, 
    required this.titulo,
    required this.asesor,
    required this.estado,
  });

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 78,
            height: 77,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: const TextStyle(fontFamily: 'Inter', fontSize: 17)),
                const SizedBox(height: 2),
                Text(asesor, style: const TextStyle(fontFamily: 'Inter', fontSize: 15)),
                const SizedBox(height: 2),
                Text(estado, style: const TextStyle(fontFamily: 'Inter', fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
