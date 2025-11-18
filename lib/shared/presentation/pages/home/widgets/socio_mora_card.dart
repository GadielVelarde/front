import 'package:flutter/material.dart';

class SocioMoraCard extends StatelessWidget {
  final String nombre;

  const SocioMoraCard({super.key, required this.nombre});

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: 99,
      height: 98,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          nombre,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 17),
        ),
      ),
    );
  }
}
