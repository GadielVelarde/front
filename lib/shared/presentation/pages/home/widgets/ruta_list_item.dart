import 'package:flutter/material.dart';

class RutaListItem extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final String direccion;

  const RutaListItem({super.key, 
    required this.titulo,
    required this.descripcion,
    required this.direccion,
  });

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 19),
      child: Column(
        children: [
          Row(
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
                    Text(descripcion, style: const TextStyle(fontFamily: 'Arial', fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(direccion, style: const TextStyle(fontFamily: 'Arial', fontSize: 15)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Opacity(opacity: 0.2, child: Container(height: 1, color: Colors.black)),
        ],
      ),
    );
  }
}
